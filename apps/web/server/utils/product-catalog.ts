import { H3Event } from 'h3'
import { resolveHomeFallbackProductImage } from '../../config/home'
import {
  PRODUCT_DETAIL_FACET_SOURCE_LIMIT,
  PRODUCT_FACET_GROUP_LIMIT,
  PRODUCT_FACET_OPTION_LIMIT,
  ProductSortValue,
} from '../../config/product'
import { CRMEB_PRODUCT_ENDPOINTS, resolveCrmebAssetUrl, resolveProductDetailPath } from '../../config/crmeb-api'
import { requestCrmeb } from './crmeb-request'
import {
  type CatalogFacetPayload,
  extractBaseFacetPayload,
  extractDetailFacetPayload,
  mergeFacetPayload,
  normalizeFacetToken,
  normalizeQuickLinkKeyword,
  resolveFacetDisplayLabel,
  shouldUseGroupForQuickLinks,
  uniqueFacetValues,
} from './product-facet-normalizer'

interface CrmebCategoryItem {
  id?: number | string
  pid?: number | string
  cate_name?: string
  name?: string
  pic?: string
  image?: string
  big_pic?: string
  children?: CrmebCategoryItem[]
}

interface CrmebProductItem {
  [key: string]: unknown
  id?: number | string
  store_name?: string
  title?: string
  image?: string
  pic?: string
  recommend_image?: string
  price?: number | string
  ot_price?: number | string
  sales?: number | string
  stock?: number | string
  activity?: string | string[]
  cate_id?: string | number
  star?: number | string
  unit_name?: string
  label_list?: Array<{ label_name?: string; name?: string }>
}

export interface CatalogCategoryNode {
  id: number
  parentId: number | null
  name: string
  image: string
  children: CatalogCategoryNode[]
}

export interface CatalogProductItem {
  id: number
  name: string
  image: string
  price: string
  originalPrice: string
  score: number
  sales: number
  stock: number
  badge: string
  unitName: string
  cateIds: number[]
  facetValues: Record<string, string[]>
  facetLabels: Record<string, string>
}

export type CatalogFacetKey = string

export interface CatalogFacetOption {
  value: string
  label: string
  count: number
}

export interface CatalogFacetGroup {
  key: CatalogFacetKey
  label: string
  kind: 'fixed' | 'dynamic'
  options: CatalogFacetOption[]
}

export type CatalogFacetFilters = Record<string, string | undefined>

export interface CatalogQuickLinkItem {
  label: string
  type: 'keyword' | 'category'
  keyword?: string
  categoryId?: number
}

export interface CatalogSelectedCategory {
  id: number
  name: string
  parentId: number | null
  path: Array<{ id: number; name: string }>
}

export function normalizeArray<T>(input: unknown): T[] {
  if (Array.isArray(input)) {
    return input as T[]
  }

  if (input && typeof input === 'object') {
    const record = input as Record<string, unknown>

    if (Array.isArray(record.list)) {
      return record.list as T[]
    }

    if (record.data && typeof record.data === 'object') {
      const nested = record.data as Record<string, unknown>
      if (Array.isArray(nested.list)) {
        return nested.list as T[]
      }
    }

    if (Array.isArray(record.data)) {
      return record.data as T[]
    }
  }

  return []
}

export function toText(value: unknown, fallback = ''): string {
  if (typeof value === 'string') {
    return value.trim() || fallback
  }

  if (typeof value === 'number') {
    return String(value)
  }

  return fallback
}

export function toNumber(value: unknown, fallback = 0): number {
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

function formatPrice(value: unknown, fallback = '0.00'): string {
  const amount = toNumber(value, Number.NaN)
  if (!Number.isFinite(amount)) {
    return fallback
  }

  return amount.toFixed(2)
}

function inferBadge(activity: unknown, fallback = ''): string {
  if (Array.isArray(activity)) {
    const firstText = activity.find((item) => typeof item === 'string' && item.trim())
    if (typeof firstText === 'string') {
      return firstText.trim()
    }
  }

  const text = toText(activity)
  if (text) {
    return text
  }

  return fallback
}

function pickCategoryImage(item: CrmebCategoryItem, publicOrigin: string): string {
  const preferred = toText(item.pic ?? item.image ?? item.big_pic)
  if (preferred) {
    return resolveCrmebAssetUrl(preferred, publicOrigin)
  }

  const child = normalizeArray<CrmebCategoryItem>(item.children).find((candidate) => {
    return Boolean(toText(candidate.pic ?? candidate.image ?? candidate.big_pic))
  })

  return resolveCrmebAssetUrl(toText(child?.pic ?? child?.image ?? child?.big_pic), publicOrigin)
}

function mapCategoryTree(item: CrmebCategoryItem, publicOrigin: string): CatalogCategoryNode {
  const id = toNumber(item.id, 0)
  return {
    id,
    parentId: toNumber(item.pid, Number.NaN) > 0 ? toNumber(item.pid, 0) : null,
    name: toText(item.cate_name ?? item.name, `分类 ${id}`),
    image: pickCategoryImage(item, publicOrigin),
    children: normalizeArray<CrmebCategoryItem>(item.children).map((child) => mapCategoryTree(child, publicOrigin)),
  }
}

function flattenCategories(items: CatalogCategoryNode[]): CatalogCategoryNode[] {
  return items.flatMap((item) => [item, ...flattenCategories(item.children)])
}

function findCategoryPath(items: CatalogCategoryNode[], categoryId: number, parents: CatalogCategoryNode[] = []): CatalogCategoryNode[] | null {
  for (const item of items) {
    if (item.id === categoryId) {
      return [...parents, item]
    }

    const nested = findCategoryPath(item.children, categoryId, [...parents, item])
    if (nested) {
      return nested
    }
  }

  return null
}

function collectDescendantIds(item: CatalogCategoryNode): number[] {
  return [item.id, ...item.children.flatMap((child) => collectDescendantIds(child))]
}

function parseProductCategoryIds(input: unknown): number[] {
  return toText(input)
    .split(',')
    .map((item) => Number(item.trim()))
    .filter((item) => Number.isFinite(item) && item > 0)
}

const PRODUCT_PRICE_RANGES: Array<{ value: string; label: string; test: (price: number) => boolean }> = [
  { value: '0-50', label: '50???', test: (price) => price < 50 },
  { value: '50-100', label: '50-100?', test: (price) => price >= 50 && price < 100 },
  { value: '100-200', label: '100-200?', test: (price) => price >= 100 && price < 200 },
  { value: '200-500', label: '200-500?', test: (price) => price >= 200 && price < 500 },
  { value: '500+', label: '500???', test: (price) => price >= 500 },
]

const PRODUCT_RATING_GROUPS: Array<{ value: string; label: string; test: (score: number) => boolean }> = [
  { value: '4.5', label: '4.5???', test: (score) => score >= 4.5 },
  { value: '4.8', label: '4.8???', test: (score) => score >= 4.8 },
  { value: '5.0', label: '5???', test: (score) => score >= 5 },
]

async function fetchCatalogProductDetailFacets(event: H3Event, id: number): Promise<CatalogFacetPayload> {
  if (!id) {
    return {
      facetValues: {},
      facetLabels: {},
    }
  }

  const response = await requestCrmeb<unknown>(event, resolveProductDetailPath(id), {
    method: 'GET',
  })

  if (Number(response.status ?? 400) !== 200) {
    return {
      facetValues: {},
      facetLabels: {},
    }
  }

  return extractDetailFacetPayload(response.data)
}

function mapProduct(item: CrmebProductItem, index: number, publicOrigin: string): CatalogProductItem {
  const id = toNumber(item.id, index + 1)
  const name = toText(item.store_name ?? item.title, `商品 ${id}`)
  const baseFacets = extractBaseFacetPayload(item, name)
  const image = resolveCrmebAssetUrl(
    toText(item.image ?? item.recommend_image ?? item.pic),
    publicOrigin,
  ) || resolveHomeFallbackProductImage(id)

  return {
    id,
    name,
    image,
    price: formatPrice(item.price),
    originalPrice: formatPrice(item.ot_price ?? item.price),
    score: toNumber(item.star, 0),
    sales: toNumber(item.sales, 0),
    stock: toNumber(item.stock, 0),
    badge: inferBadge(item.activity, toText(item.label_list?.[0]?.label_name ?? item.label_list?.[0]?.name)),
    unitName: toText(item.unit_name, '件'),
    cateIds: parseProductCategoryIds(item.cate_id),
    facetValues: baseFacets.facetValues,
    facetLabels: baseFacets.facetLabels,
  }
}

export async function fetchCatalogCategories(event: H3Event): Promise<CatalogCategoryNode[]> {
  const response = await requestCrmeb<unknown>(event, CRMEB_PRODUCT_ENDPOINTS.category, {
    method: 'GET',
  })

  const publicOrigin = useRuntimeConfig(event).public.crmebOrigin
  const roots = normalizeArray<CrmebCategoryItem>(response.data)
  return roots.map((item) => mapCategoryTree(item, publicOrigin))
}

export async function fetchCatalogProducts(
  event: H3Event,
  options: { keyword?: string; limit?: number; includeDetailFacets?: boolean } = {},
): Promise<CatalogProductItem[]> {
  const limit = Math.max(1, options.limit ?? 120)
  const query = {
    page: 1,
    limit,
    ...(options.keyword ? { keyword: options.keyword.trim() } : {}),
  }

  const response = await requestCrmeb<unknown>(event, CRMEB_PRODUCT_ENDPOINTS.products, {
    method: 'GET',
    query,
  })

  const publicOrigin = useRuntimeConfig(event).public.crmebOrigin
  const items = normalizeArray<CrmebProductItem>(response.data)
    .map((item, index) => mapProduct(item, index, publicOrigin))
    .filter((item) => item.id > 0)

  if (!options.includeDetailFacets || !items.length) {
    return items
  }

  const sourceLimit = Math.min(items.length, PRODUCT_DETAIL_FACET_SOURCE_LIMIT)
  const detailPayloads = await Promise.allSettled(
    items.slice(0, sourceLimit).map((item) => fetchCatalogProductDetailFacets(event, item.id)),
  )

  return items.map((item, index) => {
    if (index >= sourceLimit) {
      return item
    }

    const detailPayload = detailPayloads[index]
    if (detailPayload?.status !== 'fulfilled') {
      return item
    }

    const merged = mergeFacetPayload(
      {
        facetValues: item.facetValues,
        facetLabels: item.facetLabels,
      },
      detailPayload.value,
    )

    return {
      ...item,
      facetValues: merged.facetValues,
      facetLabels: merged.facetLabels,
    }
  })
}

export async function fetchPopularKeywords(event: H3Event): Promise<string[]> {
  const response = await requestCrmeb<unknown>(event, CRMEB_PRODUCT_ENDPOINTS.hotKeywords, {
    method: 'GET',
  })

  return normalizeArray<Record<string, unknown>>(response.data)
    .map((item) => {
      return toText(
        item.keyword
          ?? item.title
          ?? item.name
          ?? item.value
          ?? item.label,
      )
    })
    .filter(Boolean)
}

export function resolveSelectedCategory(
  categories: CatalogCategoryNode[],
  categoryId: number,
): { selected: CatalogSelectedCategory | null; descendantIds: number[] } {
  if (!categoryId) {
    return {
      selected: null,
      descendantIds: [],
    }
  }

  const path = findCategoryPath(categories, categoryId)
  if (!path?.length) {
    return {
      selected: null,
      descendantIds: [],
    }
  }

  const current = path[path.length - 1]
  return {
    selected: {
      id: current.id,
      name: current.name,
      parentId: current.parentId,
      path: path.map((item) => ({ id: item.id, name: item.name })),
    },
    descendantIds: collectDescendantIds(current),
  }
}

export function filterProductsByCategory(items: CatalogProductItem[], categoryIds: number[]): CatalogProductItem[] {
  if (!categoryIds.length) {
    return items
  }

  const matched = new Set(categoryIds)
  return items.filter((item) => item.cateIds.some((id) => matched.has(id)))
}

export function sortCatalogProducts(items: CatalogProductItem[], sort: ProductSortValue): CatalogProductItem[] {
  const next = [...items]

  switch (sort) {
    case 'sales_desc':
      return next.sort((left, right) => right.sales - left.sales || right.id - left.id)
    case 'price_asc':
      return next.sort((left, right) => Number(left.price) - Number(right.price) || right.id - left.id)
    case 'price_desc':
      return next.sort((left, right) => Number(right.price) - Number(left.price) || right.id - left.id)
    default:
      return next.sort((left, right) => right.id - left.id)
  }
}

function buildTokenFacetOptions(values: string[], limit = PRODUCT_FACET_OPTION_LIMIT): CatalogFacetOption[] {
  const counter = new Map<string, number>()

  for (const token of values) {
    counter.set(token, (counter.get(token) ?? 0) + 1)
  }

  return [...counter.entries()]
    .sort((left, right) => right[1] - left[1] || left[0].localeCompare(right[0], 'zh-CN'))
    .slice(0, limit)
    .map(([value, count]) => ({
      value,
      label: value,
      count,
    }))
}

function buildCategoryLookup(categories: CatalogCategoryNode[]): Map<number, CatalogCategoryNode> {
  return new Map(flattenCategories(categories).map((item) => [item.id, item]))
}

function getCategoryDepth(categoryId: number, categoryLookup: Map<number, CatalogCategoryNode>): number {
  let depth = 0
  let current = categoryLookup.get(categoryId)

  while (current) {
    depth += 1
    current = current.parentId ? categoryLookup.get(current.parentId) : undefined
  }

  return depth
}

function collectProductTypeLabels(item: CatalogProductItem, categoryLookup: Map<number, CatalogCategoryNode>): string[] {
  const matchedNodes = item.cateIds
    .map((id) => categoryLookup.get(id))
    .filter((node): node is CatalogCategoryNode => Boolean(node))

  if (!matchedNodes.length) {
    return []
  }

  const maxDepth = matchedNodes.reduce((current, node) => {
    return Math.max(current, getCategoryDepth(node.id, categoryLookup))
  }, 0)

  return uniqueFacetValues(
    matchedNodes
      .filter((node) => getCategoryDepth(node.id, categoryLookup) === maxDepth)
      .map((node) => node.name),
  )
}

export function buildCatalogFacetGroups(items: CatalogProductItem[], categories: CatalogCategoryNode[]): CatalogFacetGroup[] {
  const ratingOptions = PRODUCT_RATING_GROUPS
    .map((entry) => ({
      value: entry.value,
      label: entry.label,
      count: items.filter((item) => entry.test(item.score)).length,
    }))
    .filter((entry) => entry.count > 0)

  const priceOptions = PRODUCT_PRICE_RANGES
    .map((entry) => ({
      value: entry.value,
      label: entry.label,
      count: items.filter((item) => entry.test(Number(item.price))).length,
    }))
    .filter((entry) => entry.count > 0)

  const groups: CatalogFacetGroup[] = []
  const categoryLookup = buildCategoryLookup(categories)

  if (ratingOptions.length) {
    groups.push({ key: 'rating', label: '评分', kind: 'fixed', options: ratingOptions })
  }

  if (priceOptions.length) {
    groups.push({ key: 'price_range', label: '价格区间', kind: 'fixed', options: priceOptions })
  }

  const productTypeOptions = buildTokenFacetOptions(
    items.flatMap((item) => collectProductTypeLabels(item, categoryLookup)),
    10,
  )
  if (productTypeOptions.length) {
    groups.push({ key: 'product_type', label: '商品类型', kind: 'fixed', options: productTypeOptions })
  }

  const dynamicEntries = new Map<string, { label: string; values: string[] }>()

  for (const item of items) {
    for (const [key, values] of Object.entries(item.facetValues)) {
      const label = resolveFacetDisplayLabel(key, item.facetLabels[key])
      const current = dynamicEntries.get(key)
      if (current) {
        current.values.push(...values)
      } else {
        dynamicEntries.set(key, { label, values: [...values] })
      }
    }
  }

  for (const [key, entry] of [...dynamicEntries.entries()].sort((left, right) => {
    return right[1].values.length - left[1].values.length || left[1].label.localeCompare(right[1].label, 'zh-CN')
  }).slice(0, PRODUCT_FACET_GROUP_LIMIT)) {
    const options = buildTokenFacetOptions(entry.values)
    if (!options.length) {
      continue
    }

    groups.push({
      key,
      label: entry.label,
      kind: 'dynamic',
      options,
    })
  }

  return groups
}

function matchPriceRange(price: number, rangeValue: string): boolean {
  const target = PRODUCT_PRICE_RANGES.find((entry) => entry.value === rangeValue)
  return target ? target.test(price) : true
}

export function filterCatalogProductsByFacets(
  items: CatalogProductItem[],
  filters: CatalogFacetFilters,
  categories: CatalogCategoryNode[],
): CatalogProductItem[] {
  const categoryLookup = buildCategoryLookup(categories)

  return items.filter((item) => {
    for (const [key, value] of Object.entries(filters)) {
      if (!value) {
        continue
      }

      if (key === 'rating') {
        if (item.score < Number(value)) {
          return false
        }
        continue
      }

      if (key === 'price_range') {
        if (!matchPriceRange(Number(item.price), value)) {
          return false
        }
        continue
      }

      if (key === 'product_type') {
        if (!collectProductTypeLabels(item, categoryLookup).includes(value)) {
          return false
        }
        continue
      }

      if (!(item.facetValues[key] ?? []).includes(value)) {
        return false
      }
    }

    return true
  })
}

export function paginateCatalogProducts(items: CatalogProductItem[], page: number, limit: number): {
  items: CatalogProductItem[]
  total: number
  page: number
  limit: number
  totalPages: number
} {
  const safeLimit = Math.max(1, limit)
  const total = items.length
  const totalPages = Math.max(1, Math.ceil(total / safeLimit))
  const safePage = Math.min(Math.max(1, page), totalPages)
  const start = (safePage - 1) * safeLimit

  return {
    items: items.slice(start, start + safeLimit),
    total,
    page: safePage,
    limit: safeLimit,
    totalPages,
  }
}

export function uniqueKeywordList(items: string[], limit: number): string[] {
  const unique: string[] = []
  const seen = new Set<string>()

  for (const item of items) {
    const text = item.trim()
    if (!text) {
      continue
    }

    const key = text.toLowerCase()
    if (seen.has(key)) {
      continue
    }

    seen.add(key)
    unique.push(text)

    if (unique.length >= limit) {
      break
    }
  }

  return unique
}

export function buildCatalogQuickLinks(options: {
  keyword: string
  selectedCategory: CatalogSelectedCategory | null
  categories: CatalogCategoryNode[]
  facetGroups: CatalogFacetGroup[]
  limit: number
}): CatalogQuickLinkItem[] {
  const quickLinks: CatalogQuickLinkItem[] = []
  const path = options.selectedCategory
    ? findCategoryPath(options.categories, options.selectedCategory.id) || []
    : []
  const currentNode = path[path.length - 1] || null

  if (currentNode?.children.length) {
    quickLinks.push(
      ...currentNode.children.map((item) => ({
        label: item.name,
        type: 'category' as const,
        categoryId: item.id,
      })),
    )
  }

  const relatedGroups = options.facetGroups.filter((group) => shouldUseGroupForQuickLinks(group))

  if (options.keyword) {
    quickLinks.push(
      ...relatedGroups
        .slice(0, 4)
        .flatMap((group) => group.options.slice(0, 3).map((option) => {
          return {
            label: option.label,
            type: 'keyword' as const,
            keyword: normalizeQuickLinkKeyword(options.keyword, option.label),
          }
        })),
    )
  } else {
    quickLinks.push(
      ...relatedGroups
        .slice(0, 4)
        .flatMap((group) => group.options.slice(0, 2).map((option) => ({
          label: option.label,
          type: 'keyword' as const,
          keyword: option.label,
        }))),
    )
  }

  const unique = new Set<string>()
  return quickLinks.filter((item) => {
    if (item.type === 'keyword' && !normalizeFacetToken(item.label)) {
      return false
    }

    if (item.type === 'keyword' && !item.keyword) {
      return false
    }

    const key = `${item.type}:${item.keyword || item.categoryId || item.label}`.toLowerCase()
    if (unique.has(key)) {
      return false
    }

    unique.add(key)
    return true
  }).slice(0, options.limit)
}
