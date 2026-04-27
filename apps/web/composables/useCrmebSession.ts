import { AUTH_STORAGE_KEYS } from '~/config/auth'

interface CrmebSessionItem {
  id: number
  name: string
  image: string
  price: string
}

export interface CrmebSessionState {
  loggedIn: boolean
  uid: number | null
  accountLabel: string
  cartCount: number
  collectCount: number
  cartItems: CrmebSessionItem[]
  collectItems: CrmebSessionItem[]
  syncStatus: 'ready' | 'degraded' | 'guest'
}

interface CrmebSessionResponse {
  status?: number
  msg?: string
  data?: CrmebSessionState
}

const DEFAULT_SESSION_STATE: CrmebSessionState = {
  loggedIn: false,
  uid: null,
  accountLabel: 'Sign In',
  cartCount: 0,
  collectCount: 0,
  cartItems: [],
  collectItems: [],
  syncStatus: 'guest',
}

export function useCrmebSession() {
  const state = useState<CrmebSessionState>('crmeb-session-state', () => ({ ...DEFAULT_SESSION_STATE }))
  const loading = useState<boolean>('crmeb-session-loading', () => false)
  const loaded = useState<boolean>('crmeb-session-loaded', () => false)

  function clearLocalAuthState(): void {
    if (!import.meta.client) {
      return
    }

    const tokenCookie = useCookie<string | null>(AUTH_STORAGE_KEYS.tokenCookie, { sameSite: 'lax' })
    const authCookie = useCookie<Record<string, unknown> | null>(AUTH_STORAGE_KEYS.authCookie, { sameSite: 'lax' })
    tokenCookie.value = null
    authCookie.value = null
    window.localStorage.removeItem(AUTH_STORAGE_KEYS.authStorage)
  }

  async function refreshSession(force = false): Promise<void> {
    if (loading.value || (loaded.value && !force)) {
      return
    }

    loading.value = true

    try {
      const response = await $fetch<CrmebSessionResponse>('/api/user/session')
      state.value = {
        ...DEFAULT_SESSION_STATE,
        ...(response?.data ?? {}),
      }

      if (!state.value.loggedIn) {
        clearLocalAuthState()
      }
    } catch {
      state.value = { ...DEFAULT_SESSION_STATE, syncStatus: state.value.loggedIn ? 'degraded' : 'guest' }
    } finally {
      loaded.value = true
      loading.value = false
    }
  }

  async function logout(): Promise<void> {
    try {
      await $fetch('/api/auth/logout', {
        method: 'POST',
      })
    } catch {
      // Ignore remote logout errors and always clear local auth state.
    }

    state.value = { ...DEFAULT_SESSION_STATE }
    loaded.value = true

    clearLocalAuthState()
  }

  return {
    session: state,
    loading,
    loaded,
    refreshSession,
    logout,
  }
}
