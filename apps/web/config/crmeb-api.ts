export const CRMEB_PROXY_BASE = '/api/api-proxy'
export const CRMEB_API_BASE = 'http://172.17.0.1:50050/api'
export const CRMEB_PUBLIC_ORIGIN = 'http://192.168.1.67:50050'
export const CRMEB_HOME_PAGE_ID = 1
export const CRMEB_HOME_RECOMMENDED_CATEGORY_IDS = [67, 1038378, 311, 312, 54, 1813, 10166, 2]

export const CRMEB_HOME_ENDPOINTS = {
  home: '/index',
  config: '/site_config',
  diy: '/v2/diy/get_diy/default',
  category: '/category',
  products: '/home/products',
  cartCount: '/cart/count',
  coupons: '/coupons',
  combinationList: '/combination/list',
} as const

export const CRMEB_PRODUCT_ENDPOINTS = {
  category: '/category',
  products: '/products',
  pcProducts: '/pc/get_products',
  detail: '/product/detail',
  replyConfig: '/reply/config',
  replyList: '/reply/list',
  hotKeywords: '/search/keyword',
  hotProducts: '/product/hot',
} as const

export const CRMEB_USER_ENDPOINTS = {
  accountMenu: '/menu/user',
  profile: '/userinfo',
  cartCount: '/cart/count',
  cartList: '/cart/list',
  cartAdd: '/cart/add',
  collectList: '/collect/user',
  collectAdd: '/collect/add',
  collectDel: '/collect/del',
  logout: '/logout',
} as const

export const CRMEB_MARKETING_ENDPOINTS = {
  couponReceive: '/coupon/receive',
  couponReceiveBatch: '/coupon/receive/batch',
  bargainList: '/bargain/list',
  combinationList: '/combination/list',
  seckillIndex: '/seckill/index',
} as const

export type CrmebHomeEndpointKey = keyof typeof CRMEB_HOME_ENDPOINTS
export type CrmebUserEndpointKey = keyof typeof CRMEB_USER_ENDPOINTS

export function resolveApiPath(base: string, path: string): string {
  return `${base.replace(/\/$/, '')}${path}`
}

export function resolveHomeDiyPath(pageId?: string | number | null): string {
  const normalized = String(pageId ?? '').trim()
  if (!normalized || normalized === '0') {
    return CRMEB_HOME_ENDPOINTS.diy
  }

  return `${CRMEB_HOME_ENDPOINTS.diy}?page_id=${encodeURIComponent(normalized)}`
}

export function resolveProductDetailPath(productId: string | number): string {
  return `${CRMEB_PRODUCT_ENDPOINTS.detail}/${encodeURIComponent(String(productId))}`
}

function isPrivateAssetHost(hostname: string): boolean {
  const normalized = hostname.trim().toLowerCase()
  if (!normalized) {
    return false
  }

  if (
    normalized === 'localhost'
    || normalized === '127.0.0.1'
    || normalized === '0.0.0.0'
    || normalized === '172.17.0.1'
    || normalized === 'host.docker.internal'
  ) {
    return true
  }

  return /^10\.\d+\.\d+\.\d+$/.test(normalized)
    || /^192\.168\.\d+\.\d+$/.test(normalized)
    || /^172\.(1[6-9]|2\d|3[0-1])\.\d+\.\d+$/.test(normalized)
}

export function resolveCrmebAssetUrl(input: string | undefined, publicOrigin: string): string {
  if (!input) {
    return ''
  }

  const trimmed = input.trim()
  if (!trimmed) {
    return ''
  }

  if (/^https?:\/\//i.test(trimmed)) {
    try {
      const source = new URL(trimmed)
      const target = new URL(publicOrigin)

      if (source.host === target.host) {
        source.protocol = target.protocol
        return source.toString()
      }

      if (isPrivateAssetHost(source.hostname)) {
        source.protocol = target.protocol
        source.host = target.host
        return source.toString()
      }

      return source.toString()
    } catch {
      return trimmed
    }
  }

  if (trimmed.startsWith('/')) {
    return `${publicOrigin.replace(/\/$/, '')}${trimmed}`
  }

  return `${publicOrigin.replace(/\/$/, '')}/${trimmed.replace(/^\//, '')}`
}
