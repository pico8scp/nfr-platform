import { createHash, randomInt, randomUUID } from 'node:crypto'
import { createError, deleteCookie, getCookie, getRequestIP, H3Event, setCookie } from 'h3'
import { AUTH_COOKIE_KEYS, AUTH_RATE_LIMITS, AUTH_TIMEOUTS } from '../../config/auth'

type GuardAction = keyof typeof AUTH_RATE_LIMITS

interface CaptchaRecord {
  answer: string
  expiresAt: number
  issuedAt: number
}

interface RateRecord {
  count: number
  resetAt: number
}

interface RegisterGuardRecord {
  account: string
  expiresAt: number
}

const CAPTCHA_COOKIE = AUTH_COOKIE_KEYS.captcha
const CAPTCHA_TTL_MS = AUTH_TIMEOUTS.captchaTtlMs
const CAPTCHA_MIN_SOLVE_MS = AUTH_TIMEOUTS.captchaMinSolveMs
const REGISTER_GUARD_COOKIE = AUTH_COOKIE_KEYS.registerGuard
const REGISTER_GUARD_TTL_MS = AUTH_TIMEOUTS.registerGuardTtlMs

const CAPTCHA_STORE_KEY = '__nfrAuthCaptchaStore'
const RATE_STORE_KEY = '__nfrAuthRateStore'
const REGISTER_GUARD_STORE_KEY = '__nfrAuthRegisterGuardStore'

function getCaptchaStore(): Map<string, CaptchaRecord> {
  const scope = globalThis as typeof globalThis & { [CAPTCHA_STORE_KEY]?: Map<string, CaptchaRecord> }
  scope[CAPTCHA_STORE_KEY] ??= new Map<string, CaptchaRecord>()
  return scope[CAPTCHA_STORE_KEY]
}

function getRateStore(): Map<string, RateRecord> {
  const scope = globalThis as typeof globalThis & { [RATE_STORE_KEY]?: Map<string, RateRecord> }
  scope[RATE_STORE_KEY] ??= new Map<string, RateRecord>()
  return scope[RATE_STORE_KEY]
}

function getRegisterGuardStore(): Map<string, RegisterGuardRecord> {
  const scope = globalThis as typeof globalThis & { [REGISTER_GUARD_STORE_KEY]?: Map<string, RegisterGuardRecord> }
  scope[REGISTER_GUARD_STORE_KEY] ??= new Map<string, RegisterGuardRecord>()
  return scope[REGISTER_GUARD_STORE_KEY]
}

function now(): number {
  return Date.now()
}

function cleanupCaptchaStore(): void {
  const current = now()
  for (const [key, value] of getCaptchaStore()) {
    if (value.expiresAt <= current) {
      getCaptchaStore().delete(key)
    }
  }
}

function cleanupRateStore(): void {
  const current = now()
  for (const [key, value] of getRateStore()) {
    if (value.resetAt <= current) {
      getRateStore().delete(key)
    }
  }
}

function cleanupRegisterGuardStore(): void {
  const current = now()
  for (const [key, value] of getRegisterGuardStore()) {
    if (value.expiresAt <= current) {
      getRegisterGuardStore().delete(key)
    }
  }
}

function randomCaptchaText(length = 5): string {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
  let output = ''
  for (let index = 0; index < length; index += 1) {
    output += alphabet[randomInt(0, alphabet.length)]
  }
  return output
}

function buildCaptchaSvg(text: string): string {
  const chars = text.split('')
  const width = 160
  const height = 52
  const charSpacing = 21
  const backgroundLines = Array.from({ length: 8 }, () => {
    const x1 = randomInt(4, width - 20)
    const y1 = randomInt(4, height - 6)
    const x2 = randomInt(12, width - 4)
    const y2 = randomInt(6, height - 4)
    const color = randomInt(0, 2) === 0 ? '#cbd5e1' : '#fdba74'
    return `<line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" stroke="${color}" stroke-width="${(randomInt(12, 19) / 10).toFixed(1)}" stroke-linecap="round" opacity="0.82" />`
  }).join('')

  const dots = Array.from({ length: 28 }, () => {
    const cx = randomInt(8, width - 8)
    const cy = randomInt(8, height - 8)
    const fill = randomInt(0, 3) === 0 ? '#94a3b8' : '#fb923c'
    const radius = (randomInt(10, 22) / 10).toFixed(1)
    return `<circle cx="${cx}" cy="${cy}" r="${radius}" fill="${fill}" opacity="0.58" />`
  }).join('')

  const waves = Array.from({ length: 3 }, (_, index) => {
    const startY = 12 + (index * 12) + randomInt(-3, 4)
    const endY = startY + randomInt(-6, 7)
    const c1x = 24 + randomInt(-8, 8)
    const c1y = startY + randomInt(-10, 10)
    const c2x = width - 48 + randomInt(-10, 10)
    const c2y = endY + randomInt(-10, 10)
    const stroke = index % 2 === 0 ? '#0f172a' : '#ea580c'
    return `<path d="M 6 ${startY} C ${c1x} ${c1y}, ${c2x} ${c2y}, ${width - 6} ${endY}" fill="none" stroke="${stroke}" stroke-width="${(randomInt(10, 16) / 10).toFixed(1)}" stroke-linecap="round" opacity="0.28" />`
  }).join('')

  const letters = chars.map((char, index) => {
    const x = 14 + (index * charSpacing) + randomInt(-2, 3)
    const y = 34 + randomInt(-6, 7)
    const rotate = randomInt(-20, 21)
    const skewX = randomInt(-18, 19)
    const fill = index % 2 === 0 ? '#0f172a' : '#9a3412'
    const fontSize = randomInt(24, 31)
    return `<text x="${x}" y="${y}" fill="${fill}" font-size="${fontSize}" font-family="Verdana, Arial, sans-serif" font-weight="700" transform="rotate(${rotate} ${x} ${y}) skewX(${skewX})">${char}</text>`
  }).join('')

  const overlaySlices = Array.from({ length: 6 }, () => {
    const x = randomInt(8, width - 26)
    const y = randomInt(5, height - 13)
    const rectWidth = randomInt(10, 22)
    const rectHeight = randomInt(2, 6)
    const fill = randomInt(0, 2) === 0 ? '#ffffff' : '#ffedd5'
    return `<rect x="${x}" y="${y}" width="${rectWidth}" height="${rectHeight}" rx="2" fill="${fill}" opacity="0.52" />`
  }).join('')

  return `
    <svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}">
      <defs>
        <linearGradient id="bg" x1="0%" x2="100%" y1="0%" y2="100%">
          <stop offset="0%" stop-color="#fff7ed" />
          <stop offset="100%" stop-color="#ffffff" />
        </linearGradient>
      </defs>
      <rect width="${width}" height="${height}" rx="14" fill="url(#bg)" />
      <rect x="1" y="1" width="${width - 2}" height="${height - 2}" rx="13" fill="none" stroke="#fed7aa" />
      ${backgroundLines}
      ${dots}
      ${waves}
      ${letters}
      ${overlaySlices}
    </svg>
  `.trim()
}

function normalizeAnswer(input: string): string {
  return input.trim().toUpperCase()
}

function readIp(event: H3Event): string {
  return getRequestIP(event, { xForwardedFor: true }) || 'unknown'
}

function actionLimit(action: GuardAction): { limit: number; windowMs: number } {
  return AUTH_RATE_LIMITS[action]
}

function actionLimitMessage(action: GuardAction): string {
  switch (action) {
    case 'behavior-check':
      return '验证尝试过于频繁，请 1 分钟后再试。'
    case 'register-code':
      return '短信发送过于频繁，请稍后再试。'
    default:
      return '操作过于频繁，请稍后再试。'
  }
}

export function issueCaptcha(event: H3Event): { image: string; expiresIn: number } {
  cleanupCaptchaStore()
  enforceRateLimit(event, 'captcha')

  const id = randomUUID()
  const answer = randomCaptchaText(6)
  getCaptchaStore().set(id, {
    answer,
    issuedAt: now(),
    expiresAt: now() + CAPTCHA_TTL_MS,
  })

  setCookie(event, CAPTCHA_COOKIE, id, {
    httpOnly: true,
    sameSite: 'lax',
    path: '/',
    maxAge: Math.floor(CAPTCHA_TTL_MS / 1000),
  })

  const svg = buildCaptchaSvg(answer)
  const image = `data:image/svg+xml;base64,${Buffer.from(svg).toString('base64')}`
  return {
    image,
    expiresIn: Math.floor(CAPTCHA_TTL_MS / 1000),
  }
}

export function verifyCaptcha(event: H3Event, answer: string): void {
  cleanupCaptchaStore()

  const captchaId = getCookie(event, CAPTCHA_COOKIE)
  const record = captchaId ? getCaptchaStore().get(captchaId) : null
  const normalized = normalizeAnswer(answer)

  if (!record || !captchaId || record.expiresAt <= now()) {
    if (captchaId) {
      getCaptchaStore().delete(captchaId)
    }
    deleteCookie(event, CAPTCHA_COOKIE, { path: '/' })
    throw createError({ statusCode: 400, statusMessage: '验证码已失效，请刷新后重试。' })
  }

  getCaptchaStore().delete(captchaId)
  deleteCookie(event, CAPTCHA_COOKIE, { path: '/' })

  if (now() - record.issuedAt < CAPTCHA_MIN_SOLVE_MS) {
    throw createError({ statusCode: 400, statusMessage: '操作过快，请刷新验证码后重试。' })
  }

  if (!normalized || record.answer !== normalized) {
    throw createError({ statusCode: 400, statusMessage: '验证码错误，请重新输入。' })
  }
}

export function issueRegisterGuard(event: H3Event, account: string): void {
  cleanupRegisterGuardStore()

  const token = randomUUID()
  getRegisterGuardStore().set(token, {
    account: account.trim(),
    expiresAt: now() + REGISTER_GUARD_TTL_MS,
  })

  setCookie(event, REGISTER_GUARD_COOKIE, token, {
    httpOnly: true,
    sameSite: 'lax',
    path: '/',
    maxAge: Math.floor(REGISTER_GUARD_TTL_MS / 1000),
  })
}

export function hasRegisterGuard(event: H3Event, account: string): boolean {
  cleanupRegisterGuardStore()

  const token = getCookie(event, REGISTER_GUARD_COOKIE)
  const record = token ? getRegisterGuardStore().get(token) : null
  const normalizedAccount = account.trim()

  if (!token || !record || record.expiresAt <= now() || record.account !== normalizedAccount) {
    if (token) {
      getRegisterGuardStore().delete(token)
    }
    deleteCookie(event, REGISTER_GUARD_COOKIE, { path: '/' })
    return false
  }

  return true
}

export function clearRegisterGuard(event: H3Event): void {
  const token = getCookie(event, REGISTER_GUARD_COOKIE)
  if (token) {
    getRegisterGuardStore().delete(token)
  }
  deleteCookie(event, REGISTER_GUARD_COOKIE, { path: '/' })
}

export function enforceRateLimit(event: H3Event, action: GuardAction, identifier?: string): void {
  cleanupRateStore()

  const limit = actionLimit(action)
  const ip = readIp(event)
  const suffix = createHash('sha1').update(`${identifier || 'none'}`).digest('hex').slice(0, 12)
  const key = `${action}:${ip}:${suffix}`
  const current = now()
  const record = getRateStore().get(key)

  if (!record || record.resetAt <= current) {
    getRateStore().set(key, {
      count: 1,
      resetAt: current + limit.windowMs,
    })
    return
  }

  if (record.count >= limit.limit) {
    throw createError({ statusCode: 429, statusMessage: actionLimitMessage(action) })
  }

  record.count += 1
  getRateStore().set(key, record)
}
