import { H3Event } from 'h3'
import { AUTH_STORAGE_KEYS } from '../../config/auth'

interface CrmebResponse<T> {
  status?: number
  msg?: string
  data?: T
}

function resolveTarget(base: string, path: string): string {
  return `${base.replace(/\/$/, '')}${path}`
}

export function withCrmebAuthHeaders(event: H3Event, headers?: HeadersInit): HeadersInit | undefined {
  const token = String(getCookie(event, AUTH_STORAGE_KEYS.tokenCookie) || '').trim()
  if (!token) {
    return headers
  }

  const normalized = new Headers(headers)
  if (!normalized.has('Authori-Zation') && !normalized.has('authori-zation')) {
    normalized.set('Authori-Zation', `Bearer ${token}`)
  }

  if (!normalized.has('Authorization') && !normalized.has('authorization')) {
    normalized.set('Authorization', `Bearer ${token}`)
  }

  return normalized
}

export async function requestCrmeb<T>(event: H3Event, path: string, options?: Parameters<typeof $fetch<T>>[1]): Promise<CrmebResponse<T>> {
  const config = useRuntimeConfig(event)

  try {
    return await $fetch<CrmebResponse<T>>(resolveTarget(config.apiBase, path), {
      ...options,
      headers: withCrmebAuthHeaders(event, options?.headers),
    })
  } catch (error) {
    const fetchError = error as {
      status?: number
      statusCode?: number
      data?: { msg?: string; message?: string }
      message?: string
    }

    return {
      status: fetchError.statusCode || fetchError.status || 400,
      msg: fetchError.data?.msg || fetchError.data?.message || fetchError.message || '请求 CRMEB 失败',
      data: undefined,
    }
  }
}
