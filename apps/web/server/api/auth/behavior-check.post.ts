import { createCipheriv } from 'node:crypto'

import { getHeader } from 'h3'

import { AUTH_CAPTCHA_TYPE } from '../../../config/auth'
import { enforceRateLimit } from '../../utils/auth-security'
import { requestCrmeb } from '../../utils/crmeb-request'

interface BehaviorCheckBody {
  token?: string
  secretKey?: string
  captchaType?: string
  website?: string
  deviceId?: string
  point?: {
    x?: number | string
    y?: number | string
  }
}

function encryptPayload(value: string, secretKey: string): string {
  const cipher = createCipheriv('aes-128-ecb', Buffer.from(secretKey, 'utf8'), null)
  cipher.setAutoPadding(true)
  return `${cipher.update(value, 'utf8', 'base64')}${cipher.final('base64')}`
}

export default defineEventHandler(async (event) => {
  const body = await readBody<BehaviorCheckBody>(event)
  const token = String(body?.token || '').trim()
  const secretKey = String(body?.secretKey || '').trim()
  const captchaType = String(body?.captchaType || AUTH_CAPTCHA_TYPE).trim() || AUTH_CAPTCHA_TYPE
  const website = String(body?.website || '').trim()
  const deviceId = String(body?.deviceId || '').trim().slice(0, 128)
  const x = Number(body?.point?.x ?? Number.NaN)
  const y = Number(body?.point?.y ?? Number.NaN)

  if (website) {
    return {
      status: 400,
      msg: '请求无效',
      data: null,
    }
  }

  if (!token || !secretKey || secretKey.length !== 16 || Number.isNaN(x) || Number.isNaN(y)) {
    return {
      status: 400,
      msg: '安全验证参数不完整。',
      data: null,
    }
  }

  try {
    const userAgent = String(getHeader(event, 'user-agent') || '').trim()
    enforceRateLimit(event, 'behavior-check', `${deviceId || 'anonymous'}:${userAgent}`)
  } catch (error) {
    const guardError = error as { statusCode?: number; statusMessage?: string; message?: string }
    return {
      status: guardError.statusCode || 429,
      msg: guardError.statusMessage || guardError.message || '验证尝试过于频繁，请 1 分钟后再试。',
      data: {
        rateLimited: true,
        retryAfterSeconds: 60,
      },
    }
  }

  const pointStr = JSON.stringify({
    x: Math.max(0, Math.round(x)),
    y: Math.max(0, Math.round(y)),
  })
  const pointJson = encryptPayload(pointStr, secretKey)

  const response = await requestCrmeb<null>(event, '/ajcheck', {
    method: 'POST',
    body: {
      token,
      pointJson,
      captchaType,
    },
  })

  if (response.status !== 200) {
    return {
      status: response.status || 400,
      msg: response.msg || '安全验证未通过',
      data: null,
    }
  }

  return {
    status: 200,
    msg: response.msg || '安全验证通过',
    data: {
      captchaVerification: encryptPayload(`${token}---${pointStr}`, secretKey),
      rateLimited: false,
      retryAfterSeconds: 0,
    },
  }
})
