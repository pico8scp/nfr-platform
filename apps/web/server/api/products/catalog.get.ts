import {
  PRODUCT_FALLBACK_KEYWORDS,
  PRODUCT_LIST_DEFAULT_LIMIT,
  PRODUCT_LIST_DEFAULT_PAGE,
  PRODUCT_LIST_SOURCE_LIMIT,
  PRODUCT_QUICK_LINK_LIMIT,
  PRODUCT_SORT_OPTIONS,
} from '../../../config/product'
import {
  buildCatalogFacetGroups,
  buildCatalogQuickLinks,
  fetchCatalogCategories,
  fetchCatalogProducts,
  fetchPopularKeywords,
  filterCatalogProductsByFacets,
  filterProductsByCategory,
  paginateCatalogProducts,
  resolveSelectedCategory,
  sortCatalogProducts,
  uniqueKeywordList,
} from '../../utils/product-catalog'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const reservedQueryKeys = new Set(['keyword', 'category_id', 'page', 'limit', 'scene', 'sort'])
  const isTrackingQueryKey = (key: string): boolean => {
    return key.startsWith('_') || key.startsWith('utm_') || key === 'spm' || key === 'from'
  }
  const keyword = String(query.keyword || '').trim()
  const categoryId = Number(String(query.category_id || '').trim())
  const page = Math.max(1, Number(query.page || PRODUCT_LIST_DEFAULT_PAGE))
  const limit = Math.max(1, Number(query.limit || PRODUCT_LIST_DEFAULT_LIMIT))
  const scene = String(query.scene || '').trim()
  const selectedFilters = Object.fromEntries(
    Object.entries(query)
      .map(([key, value]) => [key, Array.isArray(value) ? value[0] : value] as const)
      .filter(([key, value]) => !reservedQueryKeys.has(key) && !isTrackingQueryKey(key) && typeof value === 'string' && value.trim())
      .map(([key, value]) => [key, String(value).trim()]),
  )
  const requestedSort = String(query.sort || 'default').trim()
  const allowedSorts = new Set(PRODUCT_SORT_OPTIONS.map((item) => item.value))
  const sort = allowedSorts.has(requestedSort as typeof PRODUCT_SORT_OPTIONS[number]['value'])
    ? requestedSort as typeof PRODUCT_SORT_OPTIONS[number]['value']
    : 'default'
  const effectiveSort = scene === 'hot' && sort === 'default'
    ? 'sales_desc'
    : sort

  const [categories, products, popularKeywords] = await Promise.all([
    fetchCatalogCategories(event),
    fetchCatalogProducts(event, {
      keyword,
      limit: PRODUCT_LIST_SOURCE_LIMIT,
      includeDetailFacets: true,
    }),
    fetchPopularKeywords(event),
  ])

  const { selected, descendantIds } = resolveSelectedCategory(
    categories,
    Number.isFinite(categoryId) && categoryId > 0 ? categoryId : 0,
  )

  const categoryFiltered = filterProductsByCategory(products, descendantIds)
  const facetGroups = buildCatalogFacetGroups(categoryFiltered, categories)
  const facetFiltered = filterCatalogProductsByFacets(categoryFiltered, selectedFilters, categories)
  const sortedItems = sortCatalogProducts(facetFiltered, effectiveSort)
  const pagination = paginateCatalogProducts(sortedItems, page, limit)
  const quickLinks = buildCatalogQuickLinks({
    keyword,
    selectedCategory: selected,
    categories,
    facetGroups,
    limit: PRODUCT_QUICK_LINK_LIMIT,
  })

  return {
    status: 200,
    msg: 'success',
    data: {
      keyword,
      categoryId: selected?.id || null,
      selectedCategory: selected,
      page: pagination.page,
      limit: pagination.limit,
      total: pagination.total,
      totalPages: pagination.totalPages,
      sort: effectiveSort,
      scene,
      selectedFilters,
      facets: facetGroups,
      items: pagination.items,
      quickLinks,
      popularKeywords: uniqueKeywordList([
        ...popularKeywords,
        ...PRODUCT_FALLBACK_KEYWORDS,
      ], PRODUCT_QUICK_LINK_LIMIT),
    },
  }
})
