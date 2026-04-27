export const AUTH_CAPTCHA_TYPE = 'blockPuzzle'
export const AUTH_SPREAD_QUERY_KEY = 'spread'
export const AUTH_SMS_COOLDOWN_SECONDS = 150
export const AUTH_BEHAVIOR_RELOAD_DELAY_MS = 1100

export const AUTH_STORAGE_KEYS = {
  tokenCookie: 'crmeb_token',
  authCookie: 'crmeb_auth',
  authStorage: 'nfr-crmeb-auth',
  registerDraft: 'nfr-register-intent-draft',
  authDeviceId: 'nfr-auth-device-id',
} as const

export const AUTH_COOKIE_KEYS = {
  captcha: 'nfr_auth_captcha_id',
  registerGuard: 'nfr_auth_register_guard',
} as const

export const AUTH_TIMEOUTS = {
  captchaTtlMs: 5 * 60 * 1000,
  captchaMinSolveMs: 1200,
  registerGuardTtlMs: 10 * 60 * 1000,
} as const

export const AUTH_RATE_LIMITS = {
  login: { limit: 10, windowMs: 10 * 60 * 1000 },
  register: { limit: 5, windowMs: 30 * 60 * 1000 },
  'register-code': { limit: 4, windowMs: 10 * 60 * 1000 },
  captcha: { limit: 18, windowMs: 10 * 60 * 1000 },
  'behavior-check': { limit: 35, windowMs: 60 * 1000 },
} as const

export const AUTH_PROMO_FALLBACK_IMAGES = [
  'https://picsum.photos/seed/nfr-login-b2b/1280/900',
  'https://picsum.photos/seed/nfr-login-distributor/1280/900',
  'https://picsum.photos/seed/nfr-login-1688/1280/900',
] as const
