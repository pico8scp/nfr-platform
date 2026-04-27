import { clearRegisterGuard, enforceRateLimit, hasRegisterGuard, verifyCaptcha } from '../../utils/auth-security'
import { requestCrmeb } from '../../utils/crmeb-request'

interface RegisterRequestBody {
  account?: string
  password?: string
  captcha?: string
  smsCode?: string
  spread?: string | number
  website?: string
}

export default defineEventHandler(async (event) => {
  const body = await readBody<RegisterRequestBody>(event)
  const account = String(body?.account || '').trim()
  const password = String(body?.password || '').trim()
  const smsCode = String(body?.smsCode || '').trim()
  const captcha = String(body?.captcha || '').trim()
  const spread = Number(String(body?.spread ?? '').trim())
  const website = String(body?.website || '').trim()

  if (website) {
    return {
      status: 400,
      msg: '请求无效',
      data: null,
    }
  }

  if (!account || !password || !smsCode) {
    return {
      status: 400,
      msg: '注册参数不完整。',
      data: null,
    }
  }

  try {
    enforceRateLimit(event, 'register', account)

    if (!hasRegisterGuard(event, account)) {
      verifyCaptcha(event, captcha)
    }
  } catch (error) {
    const guardError = error as { statusCode?: number; statusMessage?: string; message?: string }
    return {
      status: guardError.statusCode || 400,
      msg: guardError.statusMessage || guardError.message || '安全验证失败',
      data: null,
    }
  }

  const response = await requestCrmeb(event, '/register', {
    method: 'POST',
    body: {
      account,
      captcha: smsCode,
      password,
      spread: Number.isInteger(spread) && spread > 0 ? spread : 0,
    },
  })

  clearRegisterGuard(event)

  return response
})
