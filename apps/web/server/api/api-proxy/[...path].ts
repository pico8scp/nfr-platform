import { AUTH_STORAGE_KEYS } from '~/config/auth'
import { resolveApiPath } from '~/config/crmeb-api'
import { withCrmebAuthHeaders } from '../../utils/crmeb-request'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig(event)
  const method = getMethod(event).toUpperCase()
  const path = getRequestURL(event).pathname.replace(/^\/api\/api-proxy/, '')
  const target = resolveApiPath(config.apiBase, path)
  const token = String(getCookie(event, AUTH_STORAGE_KEYS.tokenCookie) || '').trim()
  const query = getQuery(event)
  const incomingHeaders = getProxyRequestHeaders(event)
  const sanitizedHeaders = new Headers(withCrmebAuthHeaders(event, incomingHeaders))

  sanitizedHeaders.delete('host')
  sanitizedHeaders.delete('connection')
  sanitizedHeaders.delete('content-length')
  sanitizedHeaders.delete('cookie')

  if (token && !sanitizedHeaders.has('Authori-Zation')) {
    sanitizedHeaders.set('Authori-Zation', `Bearer ${token}`)
  }

  if (token && !sanitizedHeaders.has('Authorization')) {
    sanitizedHeaders.set('Authorization', `Bearer ${token}`)
  }

  const body = method === 'GET' || method === 'HEAD'
    ? undefined
    : await readBody(event)

  try {
    return await $fetch(target, {
      method,
      query,
      body,
      headers: sanitizedHeaders,
    })
  } catch (error) {
    const fetchError = error as {
      data?: Record<string, unknown>
      response?: { status?: number; _data?: Record<string, unknown> }
      message?: string
    }

    const responseData = fetchError.data ?? fetchError.response?._data
    if (responseData) {
      return responseData
    }

    return {
      status: fetchError.response?.status || 400,
      msg: fetchError.message || 'CRMEB proxy request failed',
      data: null,
    }
  }
})
