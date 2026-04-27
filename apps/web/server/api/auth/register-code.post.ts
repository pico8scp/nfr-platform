import { AUTH_CAPTCHA_TYPE } from '../../../config/auth'
import { clearRegisterGuard, enforceRateLimit, issueRegisterGuard, verifyCaptcha } from '../../utils/auth-security'
import { requestCrmeb } from '../../utils/crmeb-request'

interface VerifyCodePayload {
  key?: string
  expire_time?: string | number
}

interface RegisterCodeRequestBody {
  phone?: string
  type?: string
  captcha?: string
  captchaType?: string
  captchaVerification?: string
  website?: string
}

export default defineEventHandler(async (event) => {
  const body = await readBody<RegisterCodeRequestBody>(event)
  const phone = String(body?.phone || '').trim()
  const type = String(body?.type || 'register').trim() || 'register'
  const captcha = String(body?.captcha || '').trim()
  const captchaType = String(body?.captchaType || AUTH_CAPTCHA_TYPE).trim() || AUTH_CAPTCHA_TYPE
  const captchaVerification = String(body?.captchaVerification || '').trim()
  const website = String(body?.website || '').trim()

  if (website) {
    return {
      status: 400,
      msg: '请求无效',
      data: null,
    }
  }

  if (!phone) {
    return {
      status: 400,
      msg: '请输入手机号。',
      data: null,
    }
  }

  try {
    enforceRateLimit(event, 'register-code', phone)
    verifyCaptcha(event, captcha)
  } catch (error) {
    const guardError = error as { statusCode?: number; statusMessage?: string; message?: string }
    return {
      status: guardError.statusCode || 400,
      msg: guardError.statusMessage || guardError.message || '安全验证失败',
      data: null,
    }
  }

  const keyResponse = await requestCrmeb<VerifyCodePayload>(event, '/verify_code')
  if (Number(keyResponse.status ?? 200) !== 200 || !keyResponse.data?.key) {
    clearRegisterGuard(event)
    return {
      status: keyResponse.status || 400,
      msg: keyResponse.msg || '获取短信验证码 key 失败',
      data: null,
    }
  }

  const response = await requestCrmeb(event, '/register/verify', {
    method: 'POST',
    body: {
      phone,
      type,
      key: String(keyResponse.data.key),
      captchaType,
      captchaVerification,
    },
  })

  if (Number(response.status ?? 200) === 200) {
    issueRegisterGuard(event, phone)
  } else {
    clearRegisterGuard(event)
  }

  return response
})
