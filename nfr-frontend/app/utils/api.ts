// API utility for NFR Platform frontend
const API_BASE = (typeof process !== 'undefined' && process.env && process.env.NUXT_PUBLIC_API_BASE) || 'http://localhost:8000/api'

interface ApiOptions {
  token?: string
}

async function request<T>(path: string, options: RequestInit & { token?: string } = {}): Promise<T> {
  const { token, ...fetchOptions } = options
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    ...(fetchOptions.headers as Record<string, string> || {}),
  }
  if (token) {
    headers['Authorization'] = `Bearer ${token}`
  }
  const res = await fetch(`${API_BASE}${path}`, {
    ...fetchOptions,
    headers,
  })
  if (!res.ok) {
    const err = await res.json().catch(() => ({ detail: 'Request failed' }))
    throw new Error(err.detail || `HTTP ${res.status}`)
  }
  return res.json()
}

// ============ Auth ============

export const authApi = {
  register: (data: { email: string; password: string; username: string; phone?: string }) =>
    request<any>('/api/auth/register', { method: 'POST', body: JSON.stringify(data) }),

  login: (email: string, password: string) =>
    request<{ access_token: string }>('/api/auth/login', {
      method: 'POST',
      body: new URLSearchParams({ username: email, password }),
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    }),

  me: (token: string) =>
    request<any>('/api/auth/me', { token }),
}

// ============ Products ============

export interface SearchParams {
  q?: string
  category_id?: number
  price_min?: number
  price_max?: number
  min_rating?: number
  sort?: string
  page?: number
  page_size?: number
}

export interface FacetValue { value: string; count: number }
export interface Facet { name: string; values: FacetValue[] }
export interface ActivityTag { type: string; label: string }

export interface ProductListItem {
  id: number
  name: string
  img: string
  price: string
  original_price?: string
  discount: number
  rating?: number
  sold: number
  tags: ActivityTag[]
  has_bargain: boolean
  bargain_min_discount?: number
  has_full_reduction: boolean
  full_reduction_threshold?: number
  full_reduction_amount?: number
  has_group_buy: boolean
  has_discount: boolean
}

export interface CategoryNode {
  id: number
  name: string
  parent_id?: number
  level: number
  children: CategoryNode[]
}

export interface SearchResult {
  products: ProductListItem[]
  total: number
  page: number
  page_size: number
  facets: Facet[]
}

export interface ProductDetail {
  id: number
  name: string
  category_id?: number
  description?: string
  retail_price: number
  b2b_price?: number
  rating?: number
  sales_count: number
  images: { id: number; image_url: string; is_primary: boolean }[]
  variants: {
    id: number
    sku: string
    variant_name?: string
    retail_price: number
    b2b_price?: number
    stock: number
  }[]
  attributes: { attr_name: string; attr_value: string }[]
  tags: ActivityTag[]
  discount: number
  has_bargain: boolean
  bargain_min_discount?: number
  has_full_reduction: boolean
  full_reduction_threshold?: number
  full_reduction_amount?: number
}

export const productsApi = {
  search: (params: SearchParams) => {
    const sp = new URLSearchParams()
    if (params.q) sp.set('q', params.q)
    if (params.category_id) sp.set('category_id', String(params.category_id))
    if (params.price_min != null) sp.set('price_min', String(params.price_min))
    if (params.price_max != null) sp.set('price_max', String(params.price_max))
    if (params.min_rating != null) sp.set('min_rating', String(params.min_rating))
    if (params.sort) sp.set('sort', params.sort)
    sp.set('page', String(params.page || 1))
    sp.set('page_size', String(params.page_size || 20))
    return request<SearchResult>(`/api/products/search?${sp.toString()}`)
  },

  getProduct: (id: number) =>
    request<ProductDetail>(`/api/products/${id}`),

  getCategories: () =>
    request<CategoryNode[]>('/api/products/categories/tree'),
}

// ============ Cart ============

export interface CartItem {
  id: number
  product_id: number
  product_name: string
  product_image?: string
  variant_id?: number
  variant_name?: string
  price: number
  quantity: number
}

export interface Cart {
  items: CartItem[]
  total: number
}

export const cartApi = {
  get: (token: string) =>
    request<Cart>('/api/cart', { token }),

  addItem: (data: { product_id: number; variant_id?: number; quantity: number }, token: string) =>
    request<CartItem>('/api/cart/items', {
      method: 'POST',
      body: JSON.stringify(data),
      token,
    }),

  removeItem: (itemId: number, token: string) =>
    request<{ ok: boolean }>(`/api/cart/items/${itemId}`, {
      method: 'DELETE',
      token,
    }),
}

// ============ Orders ============

export interface OrderItem {
  id: number
  product_id: number
  product_name: string
  variant_name?: string
  price: number
  quantity: number
  image_url?: string
}

export interface Order {
  id: number
  order_no: string
  total_amount: number
  status: string
  shipping_name?: string
  shipping_phone?: string
  shipping_address?: string
  created_at?: string
  items: OrderItem[]
}

export const ordersApi = {
  list: (token: string) =>
    request<Order[]>('/api/orders', { token }),

  create: (data: {
    items: { product_id: number; variant_id?: number; quantity: number }[]
    shipping_name?: string
    shipping_phone?: string
    shipping_address?: string
    note?: string
  }, token: string) =>
    request<Order>('/api/orders', {
      method: 'POST',
      body: JSON.stringify(data),
      token,
    }),

  get: (orderId: number, token: string) =>
    request<Order>(`/api/orders/${orderId}`, { token }),
}
