import type { H3Event } from 'h3'
import { resolveHomeFallbackProductImage } from '../../config/home'
import { CRMEB_PRODUCT_ENDPOINTS, resolveCrmebAssetUrl, resolveProductDetailPath } from '../../config/crmeb-api'
import {
  fetchCatalogCategories,
  normalizeArray,
  resolveSelectedCategory,
  toNumber,
  toText,
  type CatalogCategoryNode,
} from './product-catalog'
import { requestCrmeb } from './crmeb-request'

export interface ProductDetailBreadcrumb {
  id: number
  name: string
}

export interface ProductDetailSpecGroup {
  name: string
  options: string[]
}

export interface ProductDetailParamItem {
  label: string
  value: string
}

export interface ProductDetailRelatedItem {
  id: number
  name: string
  image: string
  price: string
  originalPrice: string
  badge: string
}

export interface ProductDetailReviewStats {
  total: number
  goodRate: number
  star: number
  goodCount: number
  neutralCount: number
  poorCount: number
}

export interface ProductDetailReviewItem {
  id: string
  nickname: string
  comment: string
  rating: number
  time: string
  sku: string
  merchantReply: string
  merchantReplyTime: string
  images: string[]
}

export interface ProductDetailSkuOption {
  key: string
  sku: string
  uniqueId: string
  price: string
  originalPrice: string
  stock: number
  image: string
}

export interface ProductDetailCouponItem {
  id: number
  title: string
  amount: string
  minPrice: string
  expireText: string
  receiveType: number
  receiveTypeText: string
  scopeText: string
  isUsed: boolean
}

export interface ProductDetailData {
  id: number
  name: string
  subtitle: string
  price: string
  originalPrice: string
  b2bPrice: string
  score: number
  sales: number
  stock: number
  unitName: string
  badge: string
  gallery: string[]
  breadcrumbs: ProductDetailBreadcrumb[]
  summaryPoints: string[]
  services: string[]
  specGroups: ProductDetailSpecGroup[]
  params: ProductDetailParamItem[]
  descriptionHtml: string
  userCollect: boolean
  cartButton: boolean
  reviewStats: ProductDetailReviewStats | null
  reviews: ProductDetailReviewItem[]
  skuOptions: ProductDetailSkuOption[]
  marketingCoupons: ProductDetailCouponItem[]
  marketingActivities: string[]
  relatedProducts: ProductDetailRelatedItem[]
  sourceMode: 'detail' | 'fallback'
}

function isRecord(input: unknown): input is Record<string, unknown> {
  return Boolean(input) && typeof input === 'object' && !Array.isArray(input)
}

function formatPrice(value: unknown, fallback = '0.00'): string {
  const amount = toNumber(value, Number.NaN)
  if (!Number.isFinite(amount)) {
    return fallback
  }

  return amount.toFixed(2)
}

function uniqueStrings(values: Array<string | undefined | null>): string[] {
  const seen = new Set<string>()
  const result: string[] = []

  for (const value of values) {
    const text = String(value ?? '').trim()
    if (!text) {
      continue
    }

    const key = text.toLowerCase()
    if (seen.has(key)) {
      continue
    }

    seen.add(key)
    result.push(text)
  }

  return result
}

function normalizeTextValue(input: unknown): string {
  return String(input ?? '')
    .replace(/&nbsp;/gi, ' ')
    .replace(/\s+/g, ' ')
    .trim()
}

function parseJsonIfPossible(input: string): unknown {
  const text = input.trim()
  if (!text) {
    return null
  }

  if (!text.startsWith('{') && !text.startsWith('[') && !text.startsWith('"')) {
    return null
  }

  try {
    return JSON.parse(text)
  } catch {
    return null
  }
}

function collectTextValues(input: unknown): string[] {
  if (input === null || input === undefined) {
    return []
  }

  if (Array.isArray(input)) {
    return input.flatMap((item) => collectTextValues(item))
  }

  if (isRecord(input)) {
    const preferredKeys = ['value', 'text', 'name', 'label', 'label_name', 'title', 'attr_value']
    const preferred = preferredKeys.flatMap((key) => collectTextValues(input[key]))
    if (preferred.length) {
      return preferred
    }

    return Object.values(input).flatMap((item) => collectTextValues(item))
  }

  const text = String(input).trim()
  if (!text) {
    return []
  }

  const parsed = parseJsonIfPossible(text)
  if (parsed !== null) {
    return collectTextValues(parsed)
  }

  return text
    .split(/[\n\r|;,，、]+/)
    .map((item) => item.trim())
    .filter((item) => item.length > 0 && item.length <= 80)
}

function parseCategoryIds(input: unknown): number[] {
  return collectTextValues(input)
    .flatMap((value) => value.split(','))
    .map((item) => Number(item.trim()))
    .filter((item) => Number.isFinite(item) && item > 0)
}

function parseGalleryImages(input: unknown, publicOrigin: string): string[] {
  const values = Array.isArray(input) ? input : collectTextValues(input)

  return uniqueStrings(
    values
      .map((value) => resolveCrmebAssetUrl(String(value), publicOrigin))
      .filter(Boolean),
  )
}

function sanitizeProductSubtitle(input: unknown): string {
  const blockedPattern = /(供应商|1688货号|加入订货单|RMB\s*\d*(?:\.\d+)?|新款|持续不断|亚马逊跨境|欧美外贸)/i
  const rawText = normalizeTextValue(toText(input))
  if (!rawText) {
    return ''
  }

  const segments = rawText
    .split(/[|｜]/)
    .map((item) => normalizeTextValue(item))
    .filter(Boolean)
    .filter((item) => !blockedPattern.test(item))

  if (segments.length) {
    return segments.slice(0, 3).join(' | ')
  }

  return rawText
    .replace(/供应商[:：][^|｜]+/gi, '')
    .replace(/1688货号[:：][^|｜]+/gi, '')
    .replace(/加入订货单>?/gi, '')
    .replace(/RMB\s*\d*(?:\.\d+)?/gi, '')
    .replace(/(亚马逊跨境|欧美外贸|春夏新品|持续不断|大吉大利|新款)/gi, '')
    .split(/[|｜]/)
    .map((item) => normalizeTextValue(item))
    .filter(Boolean)
    .filter((item) => !blockedPattern.test(item))
    .slice(0, 3)
    .join(' | ')
}

function sanitizeImageTag(input: string): string {
  const srcMatch = input.match(/\bsrc=["']([^"']+)["']/i)
  if (!srcMatch?.[1]) {
    return ''
  }

  const src = normalizeTextValue(srcMatch[1])
  if (!src) {
    return ''
  }

  return `<img src="${src}" alt="product detail image" loading="lazy" decoding="async">`
}

function extractImageTags(input: string): string[] {
  const tags = [...input.matchAll(/<img\b[^>]*\bsrc=["'][^"']+["'][^>]*>/gi)]
    .map((match) => sanitizeImageTag(match[0]))
    .filter(Boolean)

  const seen = new Set<string>()
  const result: string[] = []

  for (const tag of tags) {
    const srcMatch = tag.match(/\bsrc=["']([^"']+)["']/i)
    const src = normalizeTextValue(srcMatch?.[1] ?? '')
    if (!src || seen.has(src)) {
      continue
    }

    seen.add(src)
    result.push(tag)
  }

  return result
}

function trimBeforePrimaryImageBlock(input: string): string {
  const output = input.trim()
  if (!/detail\.1688\.com\/offer\//i.test(output) || !/\busemap=/i.test(output)) {
    return output
  }

  const imageMatch = /<img\b[^>]*\busemap=["'][^"']+["'][^>]*>/i.exec(output)
  if (!imageMatch || typeof imageMatch.index !== 'number') {
    return output
  }

  const blockStart = output.slice(0, imageMatch.index).lastIndexOf('<div')
  if (blockStart >= 0) {
    return output.slice(blockStart).trimStart()
  }

  return output.slice(imageMatch.index).trimStart()
}

function removeDownloadHintBlocks(input: string): string {
  return input
    .replace(
      /<div[^>]*class=["'][^"']*rich-text-component[^"']*["'][^>]*>[\s\S]*?(pan\.baidu\.com|pwd=)[\s\S]*?<\/div>/gi,
      '',
    )
    .replace(/<p[^>]*>[\s\S]*?(pan\.baidu\.com|pwd=)[\s\S]*?<\/p>/gi, '')
}

function keepTrailingRichImageGroup(input: string): string {
  const markerPattern = /<div[^>]*class=["'][^"']*rich-text-component[^"']*["'][^>]*>[\s\S]*?<\/div>/gi
  const markers = [...input.matchAll(markerPattern)]

  if (!markers.length) {
    return input
  }

  const lastMarker = markers[markers.length - 1]
  if (typeof lastMarker.index !== 'number') {
    return input
  }

  const trailingHtml = input.slice(lastMarker.index + lastMarker[0].length).trim()
  if (extractImageTags(trailingHtml).length >= 3) {
    return trailingHtml
  }

  return input.replace(markerPattern, '')
}

function buildProductImageOnlyHtml(input: string): string {
  const prioritized = keepTrailingRichImageGroup(input)
  const prioritizedImages = extractImageTags(prioritized)
  const fallbackImages = extractImageTags(input)
  const selectedImages = prioritizedImages.length >= 3 ? prioritizedImages : fallbackImages

  if (!selectedImages.length) {
    return ''
  }

  return [
    '<div class="detail-rich-image-stack">',
    ...selectedImages.map((tag) => `<figure class="detail-rich-image-item">${tag}</figure>`),
    '</div>',
  ].join('')
}

function pruneDescriptionNoise(input: string): string {
  return removeDownloadHintBlocks(trimBeforePrimaryImageBlock(input))
}

function sanitizeHtml(input: string, publicOrigin: string): string {
  const withoutDangerousTags = pruneDescriptionNoise(input)
    .replace(/<script[\s\S]*?<\/script>/gi, '')
    .replace(/<style[\s\S]*?<\/style>/gi, '')
    .replace(/<iframe[\s\S]*?<\/iframe>/gi, '')
    .replace(/\son\w+="[^"]*"/gi, '')
    .replace(/\son\w+='[^']*'/gi, '')
    .replace(/<div[^>]*id=["']offer-template-\d+["'][^>]*>\s*<\/div>/gi, '')
    .replace(/<div[^>]*title=["']SHOPTOOL_[^"']*["'][^>]*>[\s\S]*?<\/div>/gi, '')
    .replace(/<[^>]*title=["']SHOPTOOL_[^"']*["'][^>]*>/gi, (tag) => tag.replace(/\s*title=["']SHOPTOOL_[^"']*["']/i, ''))

  const normalizedAssets = withoutDangerousTags
    .replace(
      /\s(src|data-src)=["']([^"']+)["']/gi,
      (_, attribute: string, url: string) => ` ${attribute}="${resolveCrmebAssetUrl(url, publicOrigin)}"`,
    )
    .replace(/<div[^>]*>\s*<\/div>/gi, '')
    .replace(/<p[^>]*>\s*(?:&nbsp;|\s)*<\/p>/gi, '')
    .trim()

  const imageOnlyHtml = buildProductImageOnlyHtml(normalizedAssets)
  return imageOnlyHtml || normalizedAssets
}

function toHtmlParagraphs(text: string): string {
  return text
    .split(/\n+/)
    .map((item) => item.trim())
    .filter(Boolean)
    .map((item) => `<p>${item}</p>`)
    .join('')
}

function resolveDescriptionHtml(
  htmlSource: unknown,
  params: ProductDetailParamItem[],
  summaryPoints: string[],
  publicOrigin: string,
): string {
  const html = toText(htmlSource)
  if (html) {
    if (/<[a-z][\s\S]*>/i.test(html)) {
      return sanitizeHtml(html, publicOrigin)
    }

    return toHtmlParagraphs(html)
  }

  const paramRows = params
    .slice(0, 8)
    .map((item) => `<li><strong>${item.label}:</strong> ${item.value}</li>`)
    .join('')

  const pointRows = summaryPoints
    .slice(0, 6)
    .map((item) => `<li>${item}</li>`)
    .join('')

  return [
    '<div class="detail-rich-text">',
    '<p>This item is synced from the current supply catalog and can be used as the base product detail surface for future wholesale and retail conversion.</p>',
    pointRows ? `<ul>${pointRows}</ul>` : '',
    paramRows ? `<h3>Key specifications</h3><ul>${paramRows}</ul>` : '',
    '</div>',
  ].join('')
}

function buildBreadcrumbs(categories: CatalogCategoryNode[], cateIds: number[]): ProductDetailBreadcrumb[] {
  for (const cateId of cateIds) {
    const resolved = resolveSelectedCategory(categories, cateId)
    if (resolved.selected?.path.length) {
      return resolved.selected.path
    }
  }

  return []
}

function parseSpecGroups(input: unknown): ProductDetailSpecGroup[] {
  if (!input) {
    return []
  }

  const groups = normalizeArray<Record<string, unknown>>(input)
    .map((item) => {
      const name = toText(item.attr_name ?? item.name ?? item.title)
      const rawValues = item.attr_values ?? item.values ?? item.value ?? item.detail
      const options = uniqueStrings(collectTextValues(rawValues)).slice(0, 24)
      if (!name || !options.length) {
        return null
      }

      return {
        name,
        options,
      }
    })
    .filter((item): item is ProductDetailSpecGroup => Boolean(item))

  return groups.slice(0, 6)
}

function parseParams(input: unknown): ProductDetailParamItem[] {
  const paramMap = new Map<string, string[]>()

  const appendParam = (labelInput: unknown, valueInput: unknown): void => {
    const label = normalizeTextValue(labelInput)
    if (!label) {
      return
    }

    const values = uniqueStrings(collectTextValues(valueInput).map((item) => normalizeTextValue(item)))
    if (!values.length) {
      return
    }

    const bucket = paramMap.get(label) ?? []
    paramMap.set(label, uniqueStrings([...bucket, ...values]))
  }

  if (!input) {
    return []
  }

  if (Array.isArray(input)) {
    for (const item of input) {
      if (!isRecord(item)) {
        appendParam('参数', item)
        continue
      }

      const label = item.name
        ?? item.title
        ?? item.key
        ?? item.param_name
        ?? item.attr_name
        ?? item.label
        ?? item.value

      const value = item.detail
        ?? item.content
        ?? item.param_value
        ?? item.text
        ?? item.val
        ?? item.attr_values
        ?? item.attr_value
        ?? item.values
        ?? (label === item.value ? '' : item.value)

      appendParam(label, value)
    }
  }

  if (isRecord(input) && !Array.isArray(input)) {
    for (const [key, value] of Object.entries(input)) {
      appendParam(key, value)
    }
  }

  return [...paramMap.entries()]
    .map(([label, values]) => ({
      label,
      value: values.join(' / '),
    }))
    .filter((item) => item.label && item.value)
    .slice(0, 24)
}

function buildParamsFromSpecGroups(specGroups: ProductDetailSpecGroup[]): ProductDetailParamItem[] {
  return specGroups
    .map((group) => ({
      label: group.name,
      value: group.options.join(' / '),
    }))
    .filter((item) => item.label && item.value)
}

function buildParamsFromStoreInfo(input: Record<string, unknown>): ProductDetailParamItem[] {
  return [
    { label: '单位', value: toText(input.unit_name) },
    { label: '起订量', value: toText(input.min_qty) },
    { label: '货号', value: toText(input.spu ?? input.bar_code) },
  ].filter((item) => normalizeTextValue(item.value))
}

function mergeParamItems(...groups: ProductDetailParamItem[][]): ProductDetailParamItem[] {
  const merged = new Map<string, string[]>()

  for (const group of groups) {
    for (const item of group) {
      const label = normalizeTextValue(item.label)
      const values = uniqueStrings(
        item.value
          .split('/')
          .map((value) => normalizeTextValue(value)),
      )

      if (!label || !values.length) {
        continue
      }

      const bucket = merged.get(label) ?? []
      merged.set(label, uniqueStrings([...bucket, ...values]))
    }
  }

  return [...merged.entries()]
    .map(([label, values]) => ({
      label,
      value: values.join(' / '),
    }))
    .slice(0, 24)
}

function inferBadge(activity: unknown, labelList: unknown): string {
  const activityText = uniqueStrings(collectTextValues(activity))[0]
  if (activityText) {
    return activityText
  }

  return uniqueStrings(collectTextValues(labelList))[0] || ''
}

function parseServiceItems(input: unknown): string[] {
  return uniqueStrings(collectTextValues(input)).slice(0, 6)
}

function mapCouponReceiveTypeText(code: number): string {
  switch (code) {
    case 1:
      return '直接领取'
    case 2:
      return '下单赠券'
    case 3:
      return '会员赠券'
    case 4:
      return '会员专享'
    default:
      return '可领取'
  }
}

function mapCouponExpireText(item: Record<string, unknown>): string {
  if (toNumber(item.is_permanent, 0) === 1) {
    return '长期可领'
  }

  const endTime = toText(item.end_time)
  if (endTime) {
    return endTime
  }

  const couponDays = toNumber(item.coupon_time, 0)
  if (couponDays > 0) {
    return `领取后 ${couponDays} 天内可用`
  }

  return '限时可领'
}

function mapCouponScopeText(item: Record<string, unknown>): string {
  const productIds = parseCategoryIds(item.product_id)
  if (productIds.length) {
    return '指定商品可用'
  }

  const categoryIds = parseCategoryIds(item.category_id)
  if (categoryIds.length) {
    return '当前分类可用'
  }

  return '全场可用'
}

function mapMarketingCoupons(input: unknown): ProductDetailCouponItem[] {
  return normalizeArray<Record<string, unknown>>(input)
    .map((item, index) => {
      const id = toNumber(item.id, index + 1)
      const title = toText(item.coupon_title ?? item.title, `优惠券 ${index + 1}`)
      if (!id || !title) {
        return null
      }

      const receiveType = toNumber(item.receive_type, 0)

      return {
        id,
        title,
        amount: formatPrice(item.coupon_price),
        minPrice: formatPrice(item.use_min_price),
        expireText: mapCouponExpireText(item),
        receiveType,
        receiveTypeText: mapCouponReceiveTypeText(receiveType),
        scopeText: mapCouponScopeText(item),
        isUsed: Boolean(toNumber(item.is_use, 0)),
      }
    })
    .filter((item): item is ProductDetailCouponItem => Boolean(item) && !item.isUsed)
    .sort((left, right) => Number(right.amount) - Number(left.amount))
    .slice(0, 3)
}

function mapMarketingActivities(detailRoot: Record<string, unknown>, detailPayload: unknown): string[] {
  const payloadActivity = isRecord(detailPayload)
    ? normalizeArray<Record<string, unknown> | string>(detailPayload.activity)
    : []

  const activityTexts = payloadActivity.flatMap((item) => collectTextValues(item))

  const flagTexts = [
    toNumber(detailRoot.is_seckill, 0) === 1 ? '秒杀活动' : '',
    toNumber(detailRoot.is_bargain, 0) === 1 ? '砍价活动' : '',
    toNumber(detailRoot.is_new, 0) === 1 ? '新品推荐' : '',
    toNumber(detailRoot.is_best, 0) === 1 ? '精选热卖' : '',
    toNumber(detailRoot.is_benefit, 0) === 1 ? '优惠商品' : '',
    toNumber(detailRoot.presale, 0) === 1 ? '预售商品' : '',
  ]

  return uniqueStrings([
    ...activityTexts,
    ...flagTexts,
  ]).slice(0, 6)
}

function mapReviewStats(input: unknown): ProductDetailReviewStats | null {
  if (!isRecord(input)) {
    return null
  }

  const total = toNumber(input.sum_count ?? input.replyCount, 0)
  const goodRate = toNumber(input.reply_chance ?? input.replyChance, total ? 0 : 100)
  const star = toNumber(input.reply_star ?? input.star, total ? 0 : 5)
  const goodCount = toNumber(input.good_count, 0)
  const neutralCount = toNumber(input.in_count, 0)
  const poorCount = toNumber(input.poor_count, 0)

  if (!total && !goodCount && !neutralCount && !poorCount) {
    return {
      total: 0,
      goodRate,
      star,
      goodCount: 0,
      neutralCount: 0,
      poorCount: 0,
    }
  }

  return {
    total,
    goodRate,
    star,
    goodCount,
    neutralCount,
    poorCount,
  }
}

function mapReviewItem(input: unknown, publicOrigin: string, index: number): ProductDetailReviewItem | null {
  if (!isRecord(input)) {
    return null
  }

  const comment = toText(input.comment, '此用户没有填写评价')
  const nickname = toText(input.nickname, '匿名用户')
  const time = toText(input.add_time)
  const sku = toText(input.suk ?? input.sku)
  const merchantReply = toText(input.merchant_reply_content)
  const merchantReplyTime = toText(input.merchant_reply_time)
  const rating = toNumber(input.star ?? input.product_score, 0)
  const images = parseGalleryImages(input.pics ?? input.pictures, publicOrigin)

  return {
    id: toText(input.id, `review-${index + 1}`),
    nickname,
    comment,
    rating,
    time,
    sku,
    merchantReply,
    merchantReplyTime,
    images,
  }
}

function mapReviewList(input: unknown, publicOrigin: string): ProductDetailReviewItem[] {
  return normalizeArray<Record<string, unknown>>(input)
    .map((item, index) => mapReviewItem(item, publicOrigin, index))
    .filter((item): item is ProductDetailReviewItem => Boolean(item))
    .slice(0, 8)
}

function mapRelatedProducts(input: unknown, currentId: number, publicOrigin: string): ProductDetailRelatedItem[] {
  return normalizeArray<Record<string, unknown>>(input)
    .map((item) => ({
      id: toNumber(item.id, 0),
      name: toText(item.store_name ?? item.title ?? item.name),
      image: resolveCrmebAssetUrl(toText(item.image ?? item.pic ?? item.recommend_image), publicOrigin),
      price: formatPrice(item.price),
      originalPrice: formatPrice(item.ot_price ?? item.price),
      badge: inferBadge(item.activity, item.label_list),
    }))
    .filter((item) => item.id > 0 && item.id !== currentId && item.name && item.image)
    .slice(0, 8)
}

function mapSkuOptions(input: unknown, publicOrigin: string): ProductDetailSkuOption[] {
  if (!isRecord(input)) {
    return []
  }

  return Object.entries(input)
    .map(([key, value]) => {
      if (!isRecord(value)) {
        return null
      }

      const uniqueId = toText(value.unique)
      const sku = toText(value.suk ?? key, key)

      if (!sku) {
        return null
      }

      return {
        key: toText(key, sku),
        sku,
        uniqueId,
        price: formatPrice(value.price),
        originalPrice: formatPrice(value.ot_price ?? value.price),
        stock: toNumber(value.stock ?? value.product_stock, 0),
        image: resolveCrmebAssetUrl(toText(value.image), publicOrigin),
      }
    })
    .filter((item): item is ProductDetailSkuOption => Boolean(item))
}

function extractDetailRoot(input: unknown): Record<string, unknown> | null {
  if (!isRecord(input)) {
    return null
  }

  const candidateKeys = ['storeInfo', 'productInfo', 'product', 'info', 'goodsInfo', 'data']
  for (const key of candidateKeys) {
    if (isRecord(input[key])) {
      return input[key] as Record<string, unknown>
    }
  }

  return input
}

function mapDetailRecord(options: {
  id: number
  detailPayload: unknown
  categories: CatalogCategoryNode[]
  reviewConfigPayload: unknown
  reviewListPayload: unknown
  publicOrigin: string
}): ProductDetailData | null {
  const detailRoot = extractDetailRoot(options.detailPayload)
  if (!detailRoot) {
    return null
  }

  const gallery = uniqueStrings([
    ...parseGalleryImages(detailRoot.slider_image ?? detailRoot.images ?? detailRoot.image_base, options.publicOrigin),
    resolveCrmebAssetUrl(toText(detailRoot.image ?? detailRoot.pic ?? detailRoot.recommend_image), options.publicOrigin),
  ]).filter(Boolean)

  const specGroups = parseSpecGroups(
    (isRecord(options.detailPayload) ? (options.detailPayload.productAttr ?? options.detailPayload.attrs ?? options.detailPayload.attr) : null)
      ?? detailRoot.attr
      ?? detailRoot.specs,
  )
  const rawParams = parseParams(
    (isRecord(options.detailPayload) ? (options.detailPayload.params_list ?? options.detailPayload.param ?? options.detailPayload.productParams) : null)
      ?? detailRoot.params_list
      ?? detailRoot.param,
  )
  const params = mergeParamItems(
    rawParams,
    buildParamsFromSpecGroups(specGroups),
    buildParamsFromStoreInfo(detailRoot),
  )
  const badge = inferBadge(detailRoot.activity, detailRoot.label_list)
  const sales = toNumber(detailRoot.sales, 0)
  const stock = toNumber(detailRoot.stock, 0)
  const score = toNumber(detailRoot.star ?? detailRoot.score, 0)
  const unitName = toText(detailRoot.unit_name, 'pcs')
  const categoryIds = parseCategoryIds(detailRoot.cate_id)
  const breadcrumbs = buildBreadcrumbs(options.categories, categoryIds)
  const services = parseServiceItems(
    (isRecord(options.detailPayload) ? options.detailPayload.protection_list : null) ?? detailRoot.protection_list,
  )
  const reviewStats = mapReviewStats(options.reviewConfigPayload)
    ?? mapReviewStats({
      replyCount: isRecord(options.detailPayload) ? options.detailPayload.replyCount : 0,
      replyChance: isRecord(options.detailPayload) ? options.detailPayload.replyChance : 100,
    })
  const reviewList = mapReviewList(options.reviewListPayload, options.publicOrigin)
  const latestReply = isRecord(options.detailPayload) ? mapReviewItem(options.detailPayload.reply, options.publicOrigin, 0) : null
  const reviews = reviewList.length
    ? reviewList
    : latestReply
      ? [latestReply]
      : []
  const skuOptions = mapSkuOptions(
    isRecord(options.detailPayload) ? options.detailPayload.productValue : null,
    options.publicOrigin,
  )
  const marketingCoupons = mapMarketingCoupons(
    isRecord(options.detailPayload) ? options.detailPayload.coupons : null,
  )
  const marketingActivities = mapMarketingActivities(detailRoot, options.detailPayload)

  return {
    id: toNumber(detailRoot.id, options.id),
    name: toText(detailRoot.store_name ?? detailRoot.title ?? detailRoot.name, `Product ${options.id}`),
    subtitle: sanitizeProductSubtitle(detailRoot.store_info ?? detailRoot.description ?? detailRoot.info),
    price: formatPrice(detailRoot.price),
    originalPrice: formatPrice(detailRoot.ot_price ?? detailRoot.price),
    b2bPrice: (toNumber(detailRoot.price, 0) * 0.78).toFixed(2),
    score,
    sales,
    stock,
    unitName,
    badge,
    gallery: gallery.length ? gallery : [resolveHomeFallbackProductImage(options.id)],
    breadcrumbs,
    summaryPoints: [],
    services,
    specGroups,
    params,
    descriptionHtml: resolveDescriptionHtml(
      detailRoot.store_content ?? detailRoot.description,
      params,
      [],
      options.publicOrigin,
    ),
    userCollect: Boolean(detailRoot.userCollect),
    cartButton: Boolean(detailRoot.cart_button),
    reviewStats,
    reviews,
    skuOptions,
    marketingCoupons,
    marketingActivities,
    relatedProducts: mapRelatedProducts(
      isRecord(options.detailPayload) ? options.detailPayload.good_list : null,
      options.id,
      options.publicOrigin,
    ),
    sourceMode: 'detail',
  }
}

export async function fetchProductDetail(event: H3Event, id: number): Promise<ProductDetailData> {
  const publicOrigin = useRuntimeConfig(event).public.crmebOrigin
  const [categories, detailResponse, reviewConfigResponse, reviewListResponse] = await Promise.all([
    fetchCatalogCategories(event),
    requestCrmeb<unknown>(event, resolveProductDetailPath(id), { method: 'GET' }),
    requestCrmeb<unknown>(event, `${CRMEB_PRODUCT_ENDPOINTS.replyConfig}/${encodeURIComponent(String(id))}`, { method: 'GET' }),
    requestCrmeb<unknown>(event, `${CRMEB_PRODUCT_ENDPOINTS.replyList}/${encodeURIComponent(String(id))}`, { method: 'GET' }),
  ])

  if (Number(detailResponse.status ?? 400) === 200) {
    const mappedDetail = mapDetailRecord({
      id,
      detailPayload: detailResponse.data,
      categories,
      reviewConfigPayload: Number(reviewConfigResponse.status ?? 400) === 200 ? reviewConfigResponse.data : null,
      reviewListPayload: Number(reviewListResponse.status ?? 400) === 200 ? reviewListResponse.data : null,
      publicOrigin,
    })

    if (mappedDetail) {
      return mappedDetail
    }
  }

  throw createError({
    statusCode: 404,
    statusMessage: 'Product detail not available',
  })
}
