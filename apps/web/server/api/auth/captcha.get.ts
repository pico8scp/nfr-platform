import { issueCaptcha } from '../../utils/auth-security'

export default defineEventHandler((event) => {
  const captcha = issueCaptcha(event)

  return {
    status: 200,
    msg: 'ok',
    data: captcha,
  }
})
