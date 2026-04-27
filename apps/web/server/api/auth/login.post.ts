import { enforceRateLimit, verifyCaptcha } from '../../utils/auth-security'
import { requestCrmeb } from '../../utils/crmeb-request'

interface LoginRequestBody {
  account?: string
  password?: string
  captcha?: string
  website?: string
}

export default defineEventHandler(async (event) => {
  const body = await readBody<LoginRequestBody>(event)
  const account = String(body?.account || '').trim()
  const password = String(body?.password || '').trim()
  const captcha = String(body?.captcha || '').trim()
  const website = String(body?.website || '').trim()

  if (website) {
    return {
      status: 400,
      msg: '请求无效',
      data: null,
    }
  }

  if (!account || !password) {
    return {
      status: 400,
      msg: '请输入账号和密码。',
      data: null,
    }
  }

  try {
    enforceRateLimit(event, 'login', account)
    verifyCaptcha(event, captcha)
  } catch (error) {
    const guardError = error as { statusCode?: number; statusMessage?: string; message?: string }
    return {
      status: guardError.statusCode || 400,
      msg: guardError.statusMessage || guardError.message || '安全验证失败',
      data: null,
    }
  }

  return await requestCrmeb(event, '/login', {
    method: 'POST',
    body: {
      account,
      password,
    },
  })
})
