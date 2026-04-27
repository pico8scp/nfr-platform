export const PRODUCT_LIST_DEFAULT_PAGE = 1
export const PRODUCT_LIST_DEFAULT_LIMIT = 18
export const PRODUCT_LIST_SOURCE_LIMIT = 240
export const PRODUCT_SUGGESTION_LIMIT = 8
export const PRODUCT_QUICK_LINK_LIMIT = 10
export const PRODUCT_DETAIL_FACET_SOURCE_LIMIT = 80
export const PRODUCT_FACET_GROUP_LIMIT = 12
export const PRODUCT_FACET_OPTION_LIMIT = 10

export const PRODUCT_SORT_OPTIONS = [
  { value: 'default', label: '综合推荐' },
  { value: 'sales_desc', label: '销量优先' },
  { value: 'price_asc', label: '价格从低到高' },
  { value: 'price_desc', label: '价格从高到低' },
] as const

export type ProductSortValue = (typeof PRODUCT_SORT_OPTIONS)[number]['value']

export const PRODUCT_FALLBACK_KEYWORDS = [
  '连衣裙',
  '半身裙',
  'T恤',
  '衬衫',
  '牛仔裤',
  '女士内裤',
  '文胸',
  '童装套装',
  '运动鞋',
  '手账',
] as const
