import { AUTH_STORAGE_KEYS } from '../../../config/auth'
import { CRMEB_USER_ENDPOINTS } from '../../../config/crmeb-api'
import { requestCrmeb } from '../../utils/crmeb-request'

export default defineEventHandler(async (event) => {
  const token = String(getCookie(event, AUTH_STORAGE_KEYS.tokenCookie) || '').trim()

  if (token) {
    await requestCrmeb(event, CRMEB_USER_ENDPOINTS.logout, {
      method: 'GET',
      headers: {
        'Authori-Zation': `Bearer ${token}`,
      },
    })
  }

  deleteCookie(event, AUTH_STORAGE_KEYS.tokenCookie, { path: '/' })
  deleteCookie(event, AUTH_STORAGE_KEYS.authCookie, { path: '/' })

  return {
    status: 200,
    msg: 'success',
    data: true,
  }
})
