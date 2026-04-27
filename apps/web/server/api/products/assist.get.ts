import { PRODUCT_FALLBACK_KEYWORDS, PRODUCT_LIST_SOURCE_LIMIT, PRODUCT_SUGGESTION_LIMIT } from '../../../config/product'
import {
  fetchCatalogCategories,
  fetchCatalogProducts,
  fetchPopularKeywords,
  uniqueKeywordList,
} from '../../utils/product-catalog'

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const keyword = String(query.keyword || '').trim()
  const limit = Math.max(1, Number(query.limit || PRODUCT_SUGGESTION_LIMIT))

  const [categories, popularKeywords, products] = await Promise.all([
    fetchCatalogCategories(event),
    fetchPopularKeywords(event),
    fetchCatalogProducts(event, {
      keyword,
      limit: PRODUCT_LIST_SOURCE_LIMIT,
    }),
  ])

  const flatCategories = categories.flatMap(function flatten(item): string[] {
    return [item.name, ...item.children.flatMap(flatten)]
  })

  const pool = [
    ...popularKeywords,
    ...flatCategories,
    ...products.map((item) => item.name),
    ...PRODUCT_FALLBACK_KEYWORDS,
  ]

  const suggestions = uniqueKeywordList(
    keyword
      ? pool.filter((item) => item.toLowerCase().includes(keyword.toLowerCase()))
      : pool,
    limit,
  )

  return {
    status: 200,
    msg: 'success',
    data: {
      keyword,
      suggestions,
      popularKeywords: uniqueKeywordList([
        ...popularKeywords,
        ...PRODUCT_FALLBACK_KEYWORDS,
      ], limit),
    },
  }
})
