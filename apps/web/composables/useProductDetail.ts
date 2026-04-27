import type { ProductDetailData } from '~/server/utils/product-detail'

interface ProductDetailResponse {
  status?: number
  msg?: string
  data?: ProductDetailData
}

const DEFAULT_PRODUCT_DETAIL: ProductDetailData = {
  id: 0,
  name: '',
  subtitle: '',
  price: '0.00',
  originalPrice: '0.00',
  b2bPrice: '0.00',
  score: 0,
  sales: 0,
  stock: 0,
  unitName: 'pcs',
  badge: '',
  gallery: [],
  breadcrumbs: [],
  summaryPoints: [],
  services: [],
  specGroups: [],
  params: [],
  descriptionHtml: '',
  userCollect: false,
  cartButton: false,
  reviewStats: null,
  reviews: [],
  skuOptions: [],
  marketingCoupons: [],
  marketingActivities: [],
  relatedProducts: [],
  sourceMode: 'fallback',
}

export function useProductDetail() {
  const detail = useState<ProductDetailData>('product-detail-state', () => ({ ...DEFAULT_PRODUCT_DETAIL }))
  const loading = useState<boolean>('product-detail-loading', () => false)

  async function loadDetail(productId: number): Promise<void> {
    if (!Number.isFinite(productId) || productId <= 0) {
      detail.value = { ...DEFAULT_PRODUCT_DETAIL }
      return
    }

    loading.value = true

    try {
      const response = await $fetch<ProductDetailResponse>(`/api/products/${productId}`)
      detail.value = {
        ...DEFAULT_PRODUCT_DETAIL,
        ...(response.data ?? {}),
      }
    } catch {
      detail.value = { ...DEFAULT_PRODUCT_DETAIL }
    } finally {
      loading.value = false
    }
  }

  return {
    detail,
    loading,
    loadDetail,
  }
}
