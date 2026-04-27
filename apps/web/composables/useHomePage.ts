import {
  HOME_DISPLAY_LIMITS,
  HOME_DEFAULT_DEAL_PRODUCTS,
  HOME_DEFAULT_FEATURED_PRODUCTS,
  HOME_DEFAULT_SECKILL_PRODUCTS,
  resolveHomeFallbackProductImage,
} from '~/config/home'
import { CRMEB_HOME_ENDPOINTS, resolveApiPath, resolveCrmebAssetUrl, resolveHomeDiyPath } from '~/config/crmeb-api'

interface DiyMenuItem {
  id?: number | string
  name?: string
  title?: string
  info?: string | DiyConfigField[]
  pic?: string
  image?: string
  img?: string
  url?: string
  link?: string
  show?: boolean
}

interface DiyBannerItem {
  id?: number | string
  title?: string
  info?: string | DiyConfigField[]
  pic?: string
  image?: string
  img?: string
  url?: string
  link?: string
}

interface DiyConfigField {
  title?: string
  value?: string
  val?: string
}

interface DiyListItem {
  chiild?: DiyConfigField[]
  child?: DiyConfigField[]
  show?: boolean
}

interface DiyComponent {
  cname?: string
  name?: string
  title?: string
  configNum?: string
  titleConfig?: {
    val?: string
    value?: string
  }
  titleTxtConfig?: {
    value?: string
  }
  menuConfig?: {
    list?: DiyMenuItem[]
  }
  swiperConfig?: {
    list?: DiyBannerItem[]
  }
  listConfig?: {
    list?: DiyListItem[]
  }
  list?: Array<Record<string, unknown>>
  [key: string]: unknown
}

interface CategoryResponseItem {
  id?: number | string
  pid?: number | string
  sort?: number | string
  cate_name?: string
  name?: string
  pic?: string
  image?: string
  big_pic?: string
  children?: CategoryResponseItem[]
}

interface ProductResponseItem {
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
  label_list?: Array<{ label_name?: string; name?: string }>
}

interface CouponResponseItem {
  id?: number | string
  coupon_title?: string
  title?: string
  coupon_price?: number | string
  use_min_price?: number | string
  end_time?: string
}

interface CombinationResponseItem {
  id?: number | string
  title?: string
  image?: string
  price?: number | string
  sales?: number | string
  stock?: number | string
}

export interface HomeNavItem {
  id: string
  name: string
  link: string
}

export interface HomeBannerItem {
  id: string
  tag: string
  title: string
  subtitle: string
  cta: string
  link: string
  bg: string
  image?: string
  emoji?: string
}

export interface HomeShortcutItem {
  id: string
  name: string
  link: string
  icon: string
}

export interface HomeCategoryItem {
  id: number
  name: string
  link: string
  image?: string
}

export interface HomeCategoryTreeItem {
  id: number
  name: string
  link: string
  image?: string
  children: HomeCategoryTreeItem[]
}

export interface HomeCouponItem {
  id: number
  title: string
  amount: string
  minPrice: string
  expireText: string
}

export interface HomeProductItem {
  id: number
  name: string
  image: string
  price: string
  originalPrice: string
  sales: number
  stock: number
  badge?: string
}

export interface HomePageData {
  siteName: string
  topNotice: string
  cartCount: number
  navItems: HomeNavItem[]
  banners: HomeBannerItem[]
  shortcutItems: HomeShortcutItem[]
  categoryTreeRoots: HomeCategoryTreeItem[]
  categoryEntries: HomeCategoryItem[]
  couponList: HomeCouponItem[]
  featuredProducts: HomeProductItem[]
  dealProducts: HomeProductItem[]
  seckillProducts: HomeProductItem[]
  footerLinks: Array<{ name: string; link: string }>
}

const DEFAULT_BANNERS: HomeBannerItem[] = [
  {
    id: 'banner-1',
    tag: '首页主推',
    title: '沿用旧版 B2C 首页布局',
    subtitle: '首页模块已切换到商城风格，后续继续补齐真实运营素材。',
    cta: '立即选购',
    link: '/products',
    bg: 'linear-gradient(135deg, #ff8a5b 0%, #ff5f6d 100%)',
    emoji: '🛍️',
  },
  {
    id: 'banner-2',
    tag: '优惠活动',
    title: '优惠券 / 秒杀 / 拼团位',
    subtitle: '首页模块优先保障核心浏览链路，空数据模块自动降级。',
    cta: '查看活动',
    link: '/coupons',
    bg: 'linear-gradient(135deg, #4f8cff 0%, #6a5cff 100%)',
    emoji: '🎫',
  },
  {
    id: 'banner-3',
    tag: '分类导购',
    title: '搜索、分类、购物车入口已保留',
    subtitle: '首页主链路先跑通，再逐步细化业务页面跳转。',
    cta: '浏览分类',
    link: '/products',
    bg: 'linear-gradient(135deg, #11c7a7 0%, #00a2ff 100%)',
    emoji: '📦',
  },
]

const DEFAULT_SHORTCUTS: HomeShortcutItem[] = [
  { id: 'shortcut-1', name: '每日秒杀', link: '/seckill', icon: '⏰' },
  { id: 'shortcut-2', name: '拼团专区', link: '/combination', icon: '👥' },
  { id: 'shortcut-3', name: '领券中心', link: '/coupons', icon: '🎫' },
  { id: 'shortcut-4', name: '新品首发', link: '/products?scene=new', icon: '✨' },
  { id: 'shortcut-5', name: '热卖榜单', link: '/products?scene=hot', icon: '🔥' },
  { id: 'shortcut-6', name: '全部分类', link: '/products', icon: '🧭' },
]

const DEFAULT_FOOTER_LINKS = [
  { name: '帮助中心', link: '/help' },
  { name: '售后服务', link: '/service' },
  { name: '用户协议', link: '/agreement' },
  { name: '隐私政策', link: '/privacy' },
]

const DEFAULT_PRODUCTS: HomeProductItem[] = HOME_DEFAULT_FEATURED_PRODUCTS.map((item) => ({ ...item }))
const DEFAULT_DEALS: HomeProductItem[] = HOME_DEFAULT_DEAL_PRODUCTS.map((item) => ({ ...item }))
const DEFAULT_SECKILL: HomeProductItem[] = HOME_DEFAULT_SECKILL_PRODUCTS.map((item) => ({ ...item }))

function normalizeArray<T>(input: unknown): T[] {
  if (Array.isArray(input)) {
    return input as T[]
  }

  if (input && typeof input === 'object') {
    const record = input as Record<string, unknown>

    if (Array.isArray(record.list)) {
      return record.list as T[]
    }

    if (record.data && Array.isArray((record.data as Record<string, unknown>).list)) {
      return ((record.data as Record<string, unknown>).list as T[])
    }

    if (Array.isArray(record.data)) {
      return record.data as T[]
    }
  }

  return []
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

function formatPrice(value: unknown, fallback: string): string {
  const numberValue = toNumber(value, Number.NaN)
  if (Number.isNaN(numberValue)) {
    return fallback
  }

  return numberValue.toFixed(2)
}

function inferBadge(activity: unknown, fallback?: string): string | undefined {
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

function pickCategoryImage(item: CategoryResponseItem, publicOrigin: string): string {
  const primary = toText(item.pic ?? item.image ?? item.big_pic)
  if (primary) {
    return resolveCrmebAssetUrl(primary, publicOrigin)
  }

  const childWithImage = normalizeArray<CategoryResponseItem>(item.children).find((child) => {
    return Boolean(toText(child.pic ?? child.image ?? child.big_pic))
  })

  return resolveCrmebAssetUrl(
    toText(childWithImage?.pic ?? childWithImage?.image ?? childWithImage?.big_pic),
    publicOrigin,
  )
}

function extractDiyComponents(input: unknown): DiyComponent[] {
  if (!input || typeof input !== 'object') {
    return []
  }

  const record = input as Record<string, unknown>
  const value = record.value

  if (Array.isArray(value)) {
    return value as DiyComponent[]
  }

  if (value && typeof value === 'object') {
    return Object.values(value as Record<string, unknown>).filter((item): item is DiyComponent => Boolean(item) && typeof item === 'object')
  }

  if (typeof value === 'string') {
    try {
      const parsed = JSON.parse(value)
      if (Array.isArray(parsed)) {
        return parsed as DiyComponent[]
      }
      if (parsed && typeof parsed === 'object') {
        return Object.values(parsed as Record<string, unknown>).filter((item): item is DiyComponent => Boolean(item) && typeof item === 'object')
      }
    } catch {
      return []
    }
  }

  return []
}

function findDiyComponent(components: DiyComponent[], names: string[]): DiyComponent | undefined {
  return components.find((component) => {
    const aliases = [toText(component.name), toText(component.cname)]
      .map((name) => name.toLowerCase())
      .filter(Boolean)

    return names.some((name) => aliases.includes(name.toLowerCase()))
  })
}

function getDiyConfigValue(fields: unknown, titles: string[]): string {
  const normalizedFields = normalizeArray<DiyConfigField>(fields)

  for (const field of normalizedFields) {
    const fieldTitle = toText(field.title)
    if (titles.includes(fieldTitle)) {
      return toText(field.value ?? field.val)
    }
  }

  return ''
}

function getDiyMenus(components: DiyComponent[]): DiyMenuItem[] {
  const menuComponent = findDiyComponent(components, ['menu', 'menus'])
  if (!menuComponent) {
    return []
  }

  return normalizeArray<DiyMenuItem>(menuComponent.menuConfig?.list ?? menuComponent.list)
    .map((item, index) => {
      const title = toText(item.name ?? item.title, getDiyConfigValue(item.info, ['标题', '名称']))
      const link = toText(item.url ?? item.link, getDiyConfigValue(item.info, ['链接']))
      const image = toText(item.image ?? item.pic ?? item.img)

      return {
        id: item.id ?? `menu-${index + 1}`,
        name: title,
        title,
        url: link,
        link,
        image,
        pic: image,
      }
    })
    .filter((item) => Boolean(item.name || item.link || item.image))
}

function getDiyBanners(components: DiyComponent[]): DiyBannerItem[] {
  const swiperComponent = findDiyComponent(components, ['swiper', 'banner', 'homecomb'])
  if (!swiperComponent) {
    return []
  }

  return normalizeArray<DiyBannerItem>(swiperComponent.swiperConfig?.list ?? swiperComponent.list)
    .map((item, index) => {
      const title = toText(item.title, getDiyConfigValue(item.info, ['标题', '名称']))
      const link = toText(item.url ?? item.link, getDiyConfigValue(item.info, ['链接']))
      const image = toText(item.image ?? item.pic ?? item.img)

      return {
        id: item.id ?? `banner-${index + 1}`,
        title,
        info: getDiyConfigValue(item.info, ['描述', '副标题']),
        url: link,
        link,
        image,
        pic: image,
      }
    })
    .filter((item) => Boolean(item.image || item.title || item.link))
}

function getDiyNotice(components: DiyComponent[]): string {
  const noticeComponent = findDiyComponent(components, ['notice', 'news'])
  if (!noticeComponent) {
    return ''
  }

  const noticeItems = normalizeArray<DiyListItem>(noticeComponent.listConfig?.list ?? noticeComponent.list)

  for (const item of noticeItems) {
    const title = getDiyConfigValue(item.chiild ?? item.child, ['标题'])
    if (title) {
      return title
    }
  }

  return toText(
    noticeComponent.titleConfig?.val
      ?? noticeComponent.titleConfig?.value
      ?? noticeComponent.titleTxtConfig?.value
      ?? noticeComponent.title
      ?? noticeComponent.configNum,
  )
}

function fillProducts(source: HomeProductItem[], count: number, fallbackBadge?: string): HomeProductItem[] {
  const deduped = source.filter((item, index, items) => items.findIndex((candidate) => candidate.id === item.id) === index)
  if (deduped.length >= count) {
    return deduped.slice(0, count)
  }

  const extended = [...deduped]

  for (let index = 0; extended.length < count && deduped.length > 0; index += 1) {
    const baseItem = deduped[index % deduped.length]
    extended.push({
      ...baseItem,
      id: baseItem.id + (index + 1) * 10000,
      badge: baseItem.badge ?? fallbackBadge,
    })
  }

  return extended.slice(0, count)
}

function mapProduct(product: ProductResponseItem, fallbackId: number, publicOrigin: string, fallbackBadge?: string): HomeProductItem {
  const productBadge = inferBadge(product.activity)
    ?? toText(product.label_list?.[0]?.label_name ?? product.label_list?.[0]?.name)
    ?? fallbackBadge

  return {
    id: toNumber(product.id, fallbackId),
    name: toText(product.store_name ?? product.title, `商品 ${fallbackId}`),
    image: resolveCrmebAssetUrl(
      toText(product.image ?? product.recommend_image ?? product.pic),
      publicOrigin,
    ) || resolveHomeFallbackProductImage(fallbackId),
    price: formatPrice(product.price, '0.00'),
    originalPrice: formatPrice(product.ot_price ?? product.price, formatPrice(product.price, '0.00')),
    sales: toNumber(product.sales, 0),
    stock: toNumber(product.stock, 0),
    badge: productBadge,
  }
}

function mapCategory(item: CategoryResponseItem, index: number, publicOrigin: string): HomeCategoryItem {
  const id = toNumber(item.id, index + 1)
  return {
    id,
    name: toText(item.cate_name ?? item.name, `分类 ${id}`),
    link: `/products?category_id=${id}`,
    image: pickCategoryImage(item, publicOrigin),
  }
}

function mapCategoryTree(item: CategoryResponseItem, index: number, publicOrigin: string): HomeCategoryTreeItem {
  const mapped = mapCategory(item, index, publicOrigin)
  return {
    ...mapped,
    children: normalizeArray<CategoryResponseItem>(item.children).map((child, childIndex) => mapCategoryTree(child, childIndex, publicOrigin)),
  }
}

function extractCategoryRoots(input: unknown): CategoryResponseItem[] {
  const categories = normalizeArray<CategoryResponseItem>(input)
  if (!categories.length) {
    return []
  }

  const explicitRoots = categories.filter((item) => toNumber(item.pid, Number.NaN) === 0)
  if (explicitRoots.length) {
    return explicitRoots
  }

  return categories
}

function flattenCategoryTree(items: CategoryResponseItem[]): CategoryResponseItem[] {
  return items.flatMap((item) => [item, ...flattenCategoryTree(normalizeArray<CategoryResponseItem>(item.children))])
}

function parseCategoryIds(value: string): number[] {
  return value
    .split(',')
    .map((item) => Number(item.trim()))
    .filter((item) => Number.isFinite(item) && item > 0)
}

function mapCoupon(item: CouponResponseItem, index: number): HomeCouponItem {
  const amount = formatPrice(item.coupon_price, '0.00')
  return {
    id: toNumber(item.id, index + 1),
    title: toText(item.coupon_title ?? item.title, `优惠券 ${index + 1}`),
    amount,
    minPrice: formatPrice(item.use_min_price, '0.00'),
    expireText: toText(item.end_time, '限时可领'),
  }
}

function mapShortcut(item: DiyMenuItem, index: number): HomeShortcutItem {
  const id = toText(item.id, `shortcut-${index + 1}`)
  const name = toText(item.name ?? item.title, `快捷入口 ${index + 1}`)
  return {
    id,
    name,
    link: toText(item.url ?? item.link, '/products'),
    icon: ['🧭', '🎁', '🔥', '✨', '👥', '🛒'][index % 6],
  }
}

function mapNav(item: DiyMenuItem, index: number): HomeNavItem {
  return {
    id: toText(item.id, `nav-${index + 1}`),
    name: toText(item.name ?? item.title, `导航 ${index + 1}`),
    link: toText(item.url ?? item.link, '/products'),
  }
}

function mapBanner(item: DiyBannerItem, index: number, publicOrigin: string): HomeBannerItem {
  const colors = [
    'linear-gradient(135deg, #ff8a5b 0%, #ff5f6d 100%)',
    'linear-gradient(135deg, #4f8cff 0%, #6a5cff 100%)',
    'linear-gradient(135deg, #11c7a7 0%, #00a2ff 100%)',
  ]

  return {
    id: toText(item.id, `banner-${index + 1}`),
    tag: index === 0 ? '首页推荐' : '商城活动',
    title: toText(item.title, `商城活动 ${index + 1}`),
    subtitle: toText(item.info, '首页运营内容已接入。'),
    cta: '查看详情',
    link: toText(item.url ?? item.link, '/products'),
    bg: colors[index % colors.length],
    image: resolveCrmebAssetUrl(toText(item.pic ?? item.image), publicOrigin),
    emoji: ['🛍️', '🎫', '📦'][index % 3],
  }
}

async function safeFetch<T>(url: string): Promise<T | null> {
  try {
    return await $fetch<T>(url)
  } catch {
    return null
  }
}

export function useHomePage() {
  const config = useRuntimeConfig()
  const apiBase = config.public.apiBase
  const crmebOrigin = config.public.crmebOrigin
  const homePageId = toText(config.public.homePageId)
  const recommendedCategoryIds = parseCategoryIds(toText(config.public.recommendedCategoryIds))

  const state = useState<HomePageData>('home-page-data', () => ({
    siteName: '品质商城',
    topNotice: '新用户首单立减，首页活动与优惠券实时更新',
    cartCount: 0,
    navItems: DEFAULT_SHORTCUTS.slice(0, HOME_DISPLAY_LIMITS.navItems).map((item) => ({ id: item.id, name: item.name, link: item.link })),
    banners: DEFAULT_BANNERS,
    shortcutItems: DEFAULT_SHORTCUTS.slice(0, HOME_DISPLAY_LIMITS.shortcutItems),
    categoryTreeRoots: [],
    categoryEntries: [],
    couponList: [],
    featuredProducts: DEFAULT_PRODUCTS,
    dealProducts: DEFAULT_DEALS,
    seckillProducts: DEFAULT_SECKILL,
    footerLinks: DEFAULT_FOOTER_LINKS,
  }))

  const loading = useState<boolean>('home-page-loading', () => false)
  const loaded = useState<boolean>('home-page-loaded', () => false)

  async function loadHomePage(force = false): Promise<void> {
    if (loading.value || (loaded.value && !force)) {
      return
    }

    loading.value = true

    const [homeResponse, siteConfig, diyResponse, categoryResponse, productsResponse, cartResponse, couponsResponse, combinationResponse] = await Promise.all([
      safeFetch<Record<string, unknown>>(resolveApiPath(apiBase, CRMEB_HOME_ENDPOINTS.home)),
      safeFetch<Record<string, unknown>>(resolveApiPath(apiBase, CRMEB_HOME_ENDPOINTS.config)),
      safeFetch<Record<string, unknown>>(resolveApiPath(apiBase, resolveHomeDiyPath(homePageId))),
      safeFetch<unknown>(resolveApiPath(apiBase, CRMEB_HOME_ENDPOINTS.category)),
      safeFetch<unknown>(resolveApiPath(apiBase, CRMEB_HOME_ENDPOINTS.products)),
      safeFetch<Record<string, unknown>>(resolveApiPath(apiBase, CRMEB_HOME_ENDPOINTS.cartCount)),
      safeFetch<unknown>(resolveApiPath(apiBase, CRMEB_HOME_ENDPOINTS.coupons)),
      safeFetch<unknown>(resolveApiPath(apiBase, CRMEB_HOME_ENDPOINTS.combinationList)),
    ])

    const homePayload = (homeResponse?.data ?? homeResponse ?? {}) as Partial<HomePageData> & Record<string, unknown>

    const diyData = (diyResponse?.data ?? diyResponse ?? {}) as Record<string, unknown>
    const diyComponents = extractDiyComponents(diyData)
    const diyMenus = getDiyMenus(diyComponents)
    const diySwiper = getDiyBanners(diyComponents)
    const diyNotice = getDiyNotice(diyComponents)
    const categoryRoots = extractCategoryRoots(categoryResponse)
    const categoryTreeRoots = categoryRoots.map((item, index) => mapCategoryTree(item, index, crmebOrigin))
    const categoryLookup = new Map(
      flattenCategoryTree(categoryRoots)
        .map((item) => [toNumber(item.id, 0), item] as const)
        .filter(([id]) => id > 0),
    )
    const recommendedSource = (recommendedCategoryIds.length
      ? recommendedCategoryIds.map((id) => categoryLookup.get(id)).filter((item): item is CategoryResponseItem => Boolean(item))
      : categoryRoots)
      .slice(0, HOME_DISPLAY_LIMITS.categoryEntries)
    const categories = recommendedSource
      .map((item, index) => mapCategory(item, index, crmebOrigin))
      .slice(0, HOME_DISPLAY_LIMITS.categoryEntries)
    const productItems = normalizeArray<ProductResponseItem>(productsResponse).map((item, index) => mapProduct(item, index + 1, crmebOrigin)).filter((item) => item.id > 0)
    const coupons = normalizeArray<CouponResponseItem>(couponsResponse).map(mapCoupon).slice(0, 3)
    const combinations = normalizeArray<CombinationResponseItem>(combinationResponse).map((item, index) => {
      const mapped = mapProduct({
        id: item.id,
        title: item.title,
        image: item.image,
        price: item.price,
        ot_price: item.price,
        sales: item.sales,
        stock: item.stock,
      }, index + 1000, crmebOrigin, '拼团')
      return mapped
    }).slice(0, HOME_DISPLAY_LIMITS.seckillProducts)

    const nextFeatured = fillProducts(productItems, HOME_DISPLAY_LIMITS.featuredProducts)
    const nextDeals = fillProducts(productItems.slice(4), 5, '热卖')
    const nextSeckill = combinations.length ? combinations : fillProducts(productItems, 4, '秒杀')

    state.value = {
      siteName: toText(homePayload.siteName ?? siteConfig?.site_name ?? siteConfig?.title, state.value.siteName),
      topNotice: toText(homePayload.topNotice ?? diyNotice ?? diyData.notice ?? diyData.news ?? state.value.topNotice, state.value.topNotice),
      cartCount: toNumber(homePayload.cartCount ?? cartResponse?.data?.count ?? cartResponse?.data ?? cartResponse?.count, state.value.cartCount),
      navItems: Array.isArray(homePayload.navItems)
        ? (homePayload.navItems as HomeNavItem[]).slice(0, HOME_DISPLAY_LIMITS.navItems)
        : (diyMenus.length ? diyMenus : DEFAULT_SHORTCUTS.slice(0, HOME_DISPLAY_LIMITS.navItems)).slice(0, HOME_DISPLAY_LIMITS.navItems).map(mapNav),
      banners: Array.isArray(homePayload.banners)
        ? (homePayload.banners as HomeBannerItem[]).slice(0, HOME_DISPLAY_LIMITS.banners)
        : (diySwiper.length ? diySwiper.slice(0, HOME_DISPLAY_LIMITS.banners).map((item, index) => mapBanner(item, index, crmebOrigin)) : DEFAULT_BANNERS.slice(0, HOME_DISPLAY_LIMITS.banners)),
      shortcutItems: Array.isArray(homePayload.shortcutItems) ? (homePayload.shortcutItems as HomeShortcutItem[]).slice(0, HOME_DISPLAY_LIMITS.shortcutItems) : (diyMenus.length ? diyMenus : DEFAULT_SHORTCUTS).slice(0, HOME_DISPLAY_LIMITS.shortcutItems).map((item, index) => {
        if ('icon' in item && 'link' in item && 'name' in item) {
          return item as HomeShortcutItem
        }
        return mapShortcut(item as DiyMenuItem, index)
      }),
      categoryTreeRoots: categoryTreeRoots.length
        ? categoryTreeRoots
        : state.value.categoryTreeRoots,
      categoryEntries: categories.length
        ? categories
        : (Array.isArray(homePayload.categoryEntries) ? homePayload.categoryEntries as HomeCategoryItem[] : state.value.categoryEntries),
      couponList: Array.isArray(homePayload.couponList) ? homePayload.couponList as HomeCouponItem[] : coupons,
      featuredProducts: Array.isArray(homePayload.featuredProducts)
        ? (homePayload.featuredProducts as HomeProductItem[]).slice(0, HOME_DISPLAY_LIMITS.featuredProducts)
        : (nextFeatured.length ? nextFeatured : DEFAULT_PRODUCTS).slice(0, HOME_DISPLAY_LIMITS.featuredProducts),
      dealProducts: Array.isArray(homePayload.dealProducts)
        ? (homePayload.dealProducts as HomeProductItem[]).slice(0, HOME_DISPLAY_LIMITS.dealProducts)
        : (nextDeals.length ? nextDeals : DEFAULT_DEALS).slice(0, HOME_DISPLAY_LIMITS.dealProducts),
      seckillProducts: Array.isArray(homePayload.seckillProducts)
        ? (homePayload.seckillProducts as HomeProductItem[]).slice(0, HOME_DISPLAY_LIMITS.seckillProducts)
        : (nextSeckill.length ? nextSeckill : DEFAULT_SECKILL).slice(0, HOME_DISPLAY_LIMITS.seckillProducts),
      footerLinks: Array.isArray(homePayload.footerLinks) ? homePayload.footerLinks as Array<{ name: string; link: string }> : DEFAULT_FOOTER_LINKS,
    }

    loaded.value = true
    loading.value = false
  }

  return {
    homePage: state,
    loading,
    loaded,
    loadHomePage,
  }
}
