import { AUTH_STORAGE_KEYS } from '../../../config/auth'
import { CRMEB_USER_ENDPOINTS, resolveCrmebAssetUrl } from '../../../config/crmeb-api'
import { requestCrmeb } from '../../utils/crmeb-request'

interface SessionPreviewItem {
  id: number
  name: string
  image: string
  price: string
}

interface SessionPayload {
  loggedIn: boolean
  uid: number | null
  accountLabel: string
  cartCount: number
  collectCount: number
  cartItems: SessionPreviewItem[]
  collectItems: SessionPreviewItem[]
  syncStatus: 'ready' | 'degraded' | 'guest'
}

interface CrmebUserProfile {
  uid?: number | string
}

function toText(value: unknown, fallback = ''): string {
  if (typeof value === 'string') {
    return value.trim() || fallback
  }

  if (typeof value === 'number') {
    return String(value)
  }

  return fallback
}

function toNumber(value: unknown, fallback = 0): number {
  if (typeof value === 'number' && Number.isFinite(value)) {
    return value
  }

  if (typeof value === 'string') {
    const parsed = Number(value)
    if (Number.isFinite(parsed)) {
      return parsed
    }
  }

  return fallback
}

function formatPrice(value: unknown): string {
  const amount = toNumber(value, Number.NaN)
  if (!Number.isFinite(amount)) {
    return ''
  }

  return amount.toFixed(2)
}

function normalizeArray<T>(input: unknown): T[] {
  if (Array.isArray(input)) {
    return input as T[]
  }

  if (!input || typeof input !== 'object') {
    return []
  }

  const record = input as Record<string, unknown>
  const collectionKeys = ['list', 'data', 'cartList', 'valid', 'productList', 'goodsList']

  for (const key of collectionKeys) {
    if (Array.isArray(record[key])) {
      return record[key] as T[]
    }
  }

  for (const value of Object.values(record)) {
    if (Array.isArray(value)) {
      return value as T[]
    }
  }

  return []
}

function extractListCandidates(input: unknown): Array<Record<string, unknown>> {
  const direct = normalizeArray<Record<string, unknown>>(input)
  if (direct.length) {
    return direct
  }

  if (!input || typeof input !== 'object') {
    return []
  }

  const record = input as Record<string, unknown>
  const nestedKeys = ['data', 'list', 'cart_info', 'cartList', 'valid', 'productList', 'goodsList']

  for (const key of nestedKeys) {
    const nested = normalizeArray<Record<string, unknown>>(record[key])
    if (nested.length) {
      return nested
    }
  }

  return []
}

function extractCount(input: unknown): number {
  if (!input || typeof input !== 'object') {
    return toNumber(input, 0)
  }

  const record = input as Record<string, unknown>
  const candidates = [
    record.count,
    record.total,
    record.cartCount,
    record.collectCount,
    record.num,
    record.data,
  ]

  for (const candidate of candidates) {
    const count = toNumber(candidate, Number.NaN)
    if (Number.isFinite(count)) {
      return count
    }
  }

  const derivedList = extractListCandidates(input)
  return derivedList.length
}

function mapPreviewItems(items: Array<Record<string, unknown>>, publicOrigin: string): SessionPreviewItem[] {
  return items.slice(0, 3).map((item, index) => {
    const nestedProduct = (item.productInfo && typeof item.productInfo === 'object')
      ? item.productInfo as Record<string, unknown>
      : null

    const nestedProductAttr = (item.productAttr && typeof item.productAttr === 'object')
      ? item.productAttr as Record<string, unknown>
      : null

    const id = toNumber(
      item.product_id
      ?? item.id
      ?? item.pid
      ?? nestedProduct?.id
      ?? nestedProduct?.product_id,
      index + 1,
    )

    const name = toText(
      item.store_name
      ?? item.product_name
      ?? item.title
      ?? nestedProduct?.store_name
      ?? nestedProduct?.title
      ?? nestedProductAttr?.suk,
      `商品 ${id}`,
    )

    const image = resolveCrmebAssetUrl(
      toText(
        item.image
        ?? item.product_image
        ?? item.pic
        ?? nestedProduct?.image
        ?? nestedProduct?.pic
        ?? nestedProductAttr?.image,
      ),
      publicOrigin,
    )

    const price = formatPrice(
      item.truePrice
      ?? item.price
      ?? item.product_price
      ?? nestedProduct?.price
      ?? nestedProductAttr?.price,
    )

    return {
      id,
      name,
      image,
      price,
    }
  })
}

function parseJwtUid(token: string): number | null {
  const parts = token.split('.')
  if (parts.length < 2) {
    return null
  }

  try {
    const normalized = parts[1].replace(/-/g, '+').replace(/_/g, '/')
    const padded = normalized.padEnd(normalized.length + ((4 - normalized.length % 4) % 4), '=')
    const jsonText = Buffer.from(padded, 'base64').toString('utf8')
    const payload = JSON.parse(jsonText) as { jti?: { id?: number | string } }
    const uid = toNumber(payload?.jti?.id, Number.NaN)
    return Number.isFinite(uid) && uid > 0 ? uid : null
  } catch {
    return null
  }
}

export default defineEventHandler(async (event) => {
  const token = String(getCookie(event, AUTH_STORAGE_KEYS.tokenCookie) || '').trim()
  const publicOrigin = useRuntimeConfig(event).public.crmebOrigin

  if (!token) {
    const guestPayload: SessionPayload = {
      loggedIn: false,
      uid: null,
      accountLabel: 'Sign In',
      cartCount: 0,
      collectCount: 0,
      cartItems: [],
      collectItems: [],
      syncStatus: 'guest',
    }

    return {
      status: 200,
      msg: 'success',
      data: guestPayload,
    }
  }

  const headers = {
    'Authori-Zation': `Bearer ${token}`,
  }

  const profileResponse = await requestCrmeb<CrmebUserProfile>(event, CRMEB_USER_ENDPOINTS.profile, {
    method: 'GET',
    headers,
  })

  if (Number(profileResponse.status ?? 400) !== 200) {
    const invalidPayload: SessionPayload = {
      loggedIn: false,
      uid: null,
      accountLabel: 'Sign In',
      cartCount: 0,
      collectCount: 0,
      cartItems: [],
      collectItems: [],
      syncStatus: 'guest',
    }

    return {
      status: 200,
      msg: 'success',
      data: invalidPayload,
    }
  }

  const [cartCountResponse, cartListResponse, collectListResponse] = await Promise.all([
    requestCrmeb<unknown>(event, CRMEB_USER_ENDPOINTS.cartCount, {
      method: 'GET',
      query: { numType: 'true' },
      headers,
    }),
    requestCrmeb<unknown>(event, CRMEB_USER_ENDPOINTS.cartList, {
      method: 'GET',
      query: { page: 1, limit: 3 },
      headers,
    }),
    requestCrmeb<unknown>(event, CRMEB_USER_ENDPOINTS.collectList, {
      method: 'GET',
      query: { page: 1, limit: 3 },
      headers,
    }),
  ])

  const cartAuthorized = Number(cartCountResponse.status ?? 400) === 200 || Number(cartListResponse.status ?? 400) === 200
  const collectAuthorized = Number(collectListResponse.status ?? 400) === 200
  const syncStatus: SessionPayload['syncStatus'] = cartAuthorized && collectAuthorized ? 'ready' : 'degraded'

  const cartPayload = cartListResponse.data ?? {}
  const collectPayload = collectListResponse.data ?? {}
  const profilePayload = profileResponse.data ?? {}

  const payload: SessionPayload = {
    loggedIn: true,
    uid: toNumber(profilePayload.uid, parseJwtUid(token) ?? 0) || null,
    accountLabel: 'Account',
    cartCount: extractCount(cartCountResponse.data ?? cartPayload),
    collectCount: extractCount(collectPayload),
    cartItems: mapPreviewItems(extractListCandidates(cartPayload), publicOrigin),
    collectItems: mapPreviewItems(extractListCandidates(collectPayload), publicOrigin),
    syncStatus,
  }

  return {
    status: 200,
    msg: 'success',
    data: payload,
  }
})
