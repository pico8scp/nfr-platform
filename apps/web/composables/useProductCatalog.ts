import { PRODUCT_LIST_DEFAULT_LIMIT, PRODUCT_LIST_DEFAULT_PAGE, type ProductSortValue } from '~/config/product'
import type {
  CatalogFacetFilters,
  CatalogFacetGroup,
  CatalogProductItem,
  CatalogQuickLinkItem,
  CatalogSelectedCategory,
} from '~/server/utils/product-catalog'

interface ProductCatalogResponse {
  status?: number
  msg?: string
  data?: {
    keyword?: string
    categoryId?: number | null
    selectedCategory?: CatalogSelectedCategory | null
    page?: number
    limit?: number
    total?: number
    totalPages?: number
    sort?: ProductSortValue
    scene?: string
    selectedFilters?: CatalogFacetFilters
    facets?: CatalogFacetGroup[]
    items?: CatalogProductItem[]
    quickLinks?: CatalogQuickLinkItem[]
    popularKeywords?: string[]
  }
}

export interface ProductCatalogState {
  keyword: string
  categoryId: number | null
  selectedCategory: CatalogSelectedCategory | null
  page: number
  limit: number
  total: number
  totalPages: number
  sort: ProductSortValue
  scene: string
  selectedFilters: CatalogFacetFilters
  facets: CatalogFacetGroup[]
  items: CatalogProductItem[]
  quickLinks: CatalogQuickLinkItem[]
  popularKeywords: string[]
}

const DEFAULT_PRODUCT_CATALOG_STATE: ProductCatalogState = {
  keyword: '',
  categoryId: null,
  selectedCategory: null,
  page: PRODUCT_LIST_DEFAULT_PAGE,
  limit: PRODUCT_LIST_DEFAULT_LIMIT,
  total: 0,
  totalPages: 1,
  sort: 'default',
  scene: '',
  selectedFilters: {},
  facets: [],
  items: [],
  quickLinks: [],
  popularKeywords: [],
}

export function useProductCatalog() {
  const state = useState<ProductCatalogState>('product-catalog-state', () => ({ ...DEFAULT_PRODUCT_CATALOG_STATE }))
  const loading = useState<boolean>('product-catalog-loading', () => false)

  async function loadCatalog(query: Record<string, string | number | undefined>): Promise<void> {
    loading.value = true

    try {
      const response = await $fetch<ProductCatalogResponse>('/api/products/catalog', {
        query,
      })

      state.value = {
        ...DEFAULT_PRODUCT_CATALOG_STATE,
        ...(response.data ?? {}),
        selectedFilters: response.data?.selectedFilters ?? {},
        facets: response.data?.facets ?? [],
        items: response.data?.items ?? [],
        quickLinks: response.data?.quickLinks ?? [],
        popularKeywords: response.data?.popularKeywords ?? [],
      }
    } catch {
      state.value = { ...DEFAULT_PRODUCT_CATALOG_STATE }
    } finally {
      loading.value = false
    }
  }

  return {
    catalog: state,
    loading,
    loadCatalog,
  }
}
