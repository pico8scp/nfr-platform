// Auth composable
import { ref } from 'vue'
import { authApi } from '~/utils/api'

const user = ref<any>(null)
const token = ref<string | null>(null)
const loading = ref(false)

export function useAuth() {
  // Load token from localStorage on init
  if (process.client && !token.value) {
    token.value = localStorage.getItem('token')
  }

  async function login(email: string, password: string) {
    loading.value = true
    try {
      const res = await authApi.login(email, password)
      token.value = res.access_token
      localStorage.setItem('token', res.access_token)
      await fetchMe()
      return true
    } catch (e: any) {
      throw new Error(e.message || 'Login failed')
    } finally {
      loading.value = false
    }
  }

  async function register(data: { email: string; password: string; username: string; phone?: string }) {
    loading.value = true
    try {
      await authApi.register(data)
      // Auto login after register
      return await login(data.email, data.password)
    } catch (e: any) {
      throw new Error(e.message || 'Registration failed')
    } finally {
      loading.value = false
    }
  }

  async function fetchMe() {
    if (!token.value) return
    try {
      user.value = await authApi.me(token.value)
    } catch {
      logout()
    }
  }

  function logout() {
    user.value = null
    token.value = null
    localStorage.removeItem('token')
  }

  function isLoggedIn() {
    return !!token.value
  }

  return {
    user,
    token,
    loading,
    login,
    register,
    logout,
    fetchMe,
    isLoggedIn,
  }
}
