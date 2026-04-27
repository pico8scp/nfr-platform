<template>
  <div class="detail-page">
    <StorefrontHeaderShell />

    <main class="detail-main">
      <div class="detail-shell">
        <div class="detail-breadcrumb">
          <button type="button" @click="goTo('/')">首页</button>
          <span>/</span>
          <button type="button" @click="goTo('/products')">商品</button>
          <template v-for="item in detailBreadcrumbs" :key="item.id">
            <span>/</span>
            <button type="button" @click="applyCategory(item.id)">{{ item.name }}</button>
          </template>
          <template v-if="detail.name">
            <span>/</span>
            <span class="detail-breadcrumb-current">{{ detail.name }}</span>
          </template>
        </div>

        <section v-if="detailLoading" class="detail-state-card">
          正在加载商品详情...
        </section>

        <template v-else-if="detail.id">
          <section class="detail-atf">
            <div class="detail-left-column">
              <section class="detail-gallery-panel">
                <div class="detail-thumb-rail">
                  <button
                    v-for="(image, index) in displayGallery"
                    :key="`${detail.id}-thumb-${index}`"
                    type="button"
                    class="detail-thumb"
                    :class="{ active: index === activeImageIndex }"
                    @click="activeImageIndex = index"
                  >
                    <img :src="image" :alt="`${detail.name} ${index + 1}`" @error="handleImageError($event, fallbackProductImage)" />
                  </button>
                </div>

                <div class="detail-stage">
                  <div class="detail-stage-media">
                    <img :src="activeImage" :alt="detail.name" @error="handleImageError($event, fallbackProductImage)" />
                    <span v-if="detail.badge" class="detail-stage-badge">{{ detail.badge }}</span>
                  </div>
                </div>
              </section>

            </div>

            <div class="detail-right-column">
              <section class="detail-info-panel">
                <h1 class="detail-title">{{ detail.name }}</h1>
                <section v-if="hasMarketingPanel" class="detail-marketing-panel" aria-label="营销内容">
                  <div class="detail-marketing-head">
                    <span>营销内容</span>
                    <button type="button" class="detail-marketing-link" @click="goTo('/activity')">查看全部活动</button>
                  </div>
                  <div class="detail-marketing-summary">
                    <strong>{{ marketingHeadline }}</strong>
                    <p>{{ marketingDescription }}</p>
                  </div>
                  <div v-if="marketingTags.length" class="detail-marketing-tags">
                    <span v-for="tag in marketingTags" :key="tag" class="detail-marketing-tag">{{ tag }}</span>
                  </div>
                  <div v-if="marketingCoupons.length" class="detail-coupon-list">
                    <button
                      v-for="coupon in marketingCoupons"
                      :key="`detail-coupon-${coupon.id}`"
                      type="button"
                      class="detail-coupon-card"
                      :class="{ 'is-member': coupon.receiveType === 4 }"
                      :disabled="couponPendingId === coupon.id"
                      @click="receiveCoupon(coupon)"
                    >
                      <div class="detail-coupon-main">
                        <strong>${{ coupon.amount }}</strong>
                        <div class="detail-coupon-meta">
                          <span>{{ coupon.title }}</span>
                          <div class="detail-coupon-badges">
                            <small>{{ coupon.scopeText }}</small>
                            <small>{{ coupon.expireText }}</small>
                          </div>
                          <small>满 ${{ coupon.minPrice }} 可用</small>
                        </div>
                      </div>
                      <em class="detail-coupon-cta">
                        {{ couponPendingId === coupon.id ? '领取中...' : coupon.receiveTypeText }}
                      </em>
                    </button>
                  </div>
                  <div v-if="marketingQuickActions.length" class="detail-marketing-actions">
                    <button
                      v-for="item in marketingQuickActions"
                      :key="item.key"
                      type="button"
                      class="detail-marketing-action"
                      @click="goTo(item.link)"
                    >
                      <strong>{{ item.label }}</strong>
                      <span>{{ item.note }}</span>
                    </button>
                  </div>
                </section>

                <div class="detail-price-panel">
                  <div>
                    <span class="detail-price-label">售价</span>
                    <strong class="detail-price-current">${{ displayPrice }}</strong>
                    <span v-if="displayOriginalPrice && displayOriginalPrice !== displayPrice" class="detail-price-old">${{ displayOriginalPrice }}</span>
                  </div>
                </div>

                <div v-if="colorSpecGroup" class="detail-option-block">
                  <div class="detail-option-head">
                    <span>颜色</span>
                    <strong>{{ selectedSpecs[colorSpecGroup.name] || colorSpecGroup.options[0] }}</strong>
                  </div>
                  <div class="detail-color-grid">
                    <button
                      v-for="option in colorSpecGroup.options"
                      :key="`${colorSpecGroup.name}-${option}`"
                      type="button"
                      class="detail-color-chip"
                      :class="{ active: selectedSpecs[colorSpecGroup.name] === option }"
                      @click="selectSpec(colorSpecGroup.name, option)"
                    >
                      {{ option }}
                    </button>
                  </div>
                </div>

                <div v-for="group in optionSpecGroups" :key="group.name" class="detail-option-block">
                  <div class="detail-option-head">
                    <span>{{ group.name }}</span>
                    <strong>{{ selectedSpecs[group.name] || group.options[0] }}</strong>
                  </div>
                  <div class="detail-size-grid">
                    <button
                      v-for="option in group.options"
                      :key="`${group.name}-${option}`"
                      type="button"
                      class="detail-size-chip"
                      :class="{ active: selectedSpecs[group.name] === option }"
                      @click="selectSpec(group.name, option)"
                    >
                      {{ option }}
                    </button>
                  </div>
                </div>

                <div class="detail-quantity-row">
                  <span class="detail-quantity-label">数量</span>
                  <div class="detail-quantity-box">
                    <button type="button" @click="changeQuantity(-1)">-</button>
                    <strong>{{ quantity }}</strong>
                    <button type="button" @click="changeQuantity(1)">+</button>
                  </div>
                </div>

                <p class="detail-selection-note">{{ selectedSpecSummary }}</p>

                <div class="detail-action-row detail-action-row-main">
                  <button
                    type="button"
                    class="detail-primary-btn"
                    :disabled="cartPending || !detail.cartButton"
                    @click="addToCart"
                  >
                    {{ cartPending ? '加入中...' : '加入购物车' }}
                  </button>
                  <button
                    type="button"
                    class="detail-secondary-btn"
                    :class="{ 'is-active': detail.userCollect }"
                    :disabled="collectPending"
                    @click="toggleCollect"
                  >
                    {{ collectPending ? '处理中...' : (detail.userCollect ? '已收藏' : '收藏商品') }}
                  </button>
                </div>

                <div class="detail-action-links">
                  <button
                    v-if="marketingCoupons.length"
                    type="button"
                    class="detail-inline-link"
                    @click="goTo('/coupons')"
                  >
                    查看可领优惠
                  </button>
                  <span v-if="marketingCoupons.length" class="detail-inline-divider">|</span>
                  <button type="button" class="detail-inline-link" @click="browseSimilarProducts">查看同类商品</button>
                </div>

                <p v-if="actionFeedback" class="detail-action-feedback" :class="`is-${actionFeedbackType}`">
                  {{ actionFeedback }}
                </p>

                <div class="detail-mini-meta">
                  <span>销量 {{ formatCompactNumber(detail.sales) }}</span>
                  <span>库存 {{ formatCompactNumber(displayStock) }}</span>
                  <span>单位 {{ detail.unitName }}</span>
                </div>
              </section>

              <article class="detail-side-card">
                <div class="detail-side-head">
                  <span class="detail-section-kicker">服务承诺</span>
                  <h3>服务保障</h3>
                </div>
                <div v-if="detail.services.length" class="detail-service-list">
                  <article v-for="service in detail.services" :key="service" class="detail-service-item">
                    <span class="detail-highlight-dot" />
                    <span>{{ service }}</span>
                  </article>
                </div>
                <p v-else class="detail-side-empty">当前商品暂无服务保障说明。</p>
              </article>
            </div>
          </section>

          <section class="detail-param-section">
            <article class="detail-rich-card detail-param-surface">
              <div class="detail-section-head">
                <div>
                  <span class="detail-section-kicker">参数速览</span>
                  <h2>规格参数</h2>
                </div>
              </div>
              <div class="detail-param-grid">
                <article v-for="item in detailFacts" :key="`${item.label}-${item.value}`" class="detail-param-card">
                  <span>{{ item.label }}</span>
                  <strong>{{ item.value }}</strong>
                </article>
              </div>
            </article>
          </section>

          <section v-if="reviewStats || visibleReviews.length" class="detail-review-panel">
            <div class="detail-section-head">
              <div>
                <span class="detail-section-kicker">评价概览</span>
                <h2>商品评价</h2>
              </div>
            </div>

            <div class="detail-review-score-card">
              <article class="detail-review-score-main">
                <strong>{{ reviewStats?.star ?? 5 }}</strong>
                <span>综合评分</span>
              </article>

              <div class="detail-review-metrics">
                <article class="detail-review-metric">
                  <strong>{{ reviewStats?.goodRate ?? 100 }}%</strong>
                  <span>好评率</span>
                </article>
                <article class="detail-review-metric">
                  <strong>{{ reviewStats?.total ?? visibleReviews.length }}</strong>
                  <span>累计评价</span>
                </article>
                <article class="detail-review-metric">
                  <strong>{{ reviewStats?.goodCount ?? 0 }}</strong>
                  <span>好评数量</span>
                </article>
              </div>
            </div>

            <div v-if="reviewTags.length" class="detail-review-tags">
              <span v-for="tag in reviewTags" :key="tag" class="detail-review-tag">{{ tag }}</span>
            </div>

            <div v-if="visibleReviews.length" class="detail-review-list">
              <article v-for="item in visibleReviews" :key="item.id" class="detail-review-card">
                <div class="detail-review-card-head">
                  <strong>{{ item.nickname }}</strong>
                  <span>{{ item.time || '最近评价' }}</span>
                </div>
                <p>{{ item.comment }}</p>
                <p v-if="item.sku">规格：{{ item.sku }}</p>
                <p v-if="item.merchantReply">商家回复：{{ item.merchantReply }}</p>
              </article>
            </div>
          </section>

          <section v-if="hasRichDescription" class="detail-rich-section">
            <article class="detail-rich-card">
              <div class="detail-section-head">
                <div>
                  <span class="detail-section-kicker">详情正文</span>
                  <h2>商品详情</h2>
                </div>
              </div>
              <div class="detail-rich-copy-body" v-html="detail.descriptionHtml" />
            </article>
          </section>

          <section class="detail-related-section">
            <div class="detail-section-head">
              <div>
                <span class="detail-section-kicker">同类推荐</span>
                <h2>相关推荐</h2>
              </div>
              <button type="button" class="detail-link-btn" @click="browseSimilarProducts">浏览更多</button>
            </div>

            <div v-if="detail.relatedProducts.length" class="detail-related-grid">
              <article
                v-for="item in detail.relatedProducts"
                :key="item.id"
                class="detail-related-card"
                @click="goToProduct(item.id)"
              >
                <div class="detail-related-image">
                  <img :src="item.image" :alt="item.name" @error="handleImageError($event, fallbackProductImage)" />
                  <span v-if="item.badge" class="detail-related-badge">{{ item.badge }}</span>
                </div>
                <div class="detail-related-body">
                  <strong>{{ item.name }}</strong>
                  <div class="detail-related-price-row">
                    <span class="detail-related-price">${{ item.price }}</span>
                    <span v-if="item.originalPrice && item.originalPrice !== item.price" class="detail-related-old-price">${{ item.originalPrice }}</span>
                  </div>
                </div>
              </article>
            </div>
            <div v-else class="detail-related-empty">当前商品暂无推荐商品。</div>
          </section>
        </template>

        <section v-else class="detail-state-card">
          未获取到商品详情数据。
        </section>
      </div>
    </main>

    <footer class="main-footer">
      <div class="footer-inner">
        <div class="footer-grid">
          <div class="footer-col">
            <h4 class="footer-heading">平台信息</h4>
            <ul class="footer-links-list">
              <li><button type="button" @click="goTo('/about')">关于我们</button></li>
              <li><button type="button" @click="goTo('/activity')">活动中心</button></li>
              <li><button type="button" @click="goTo('/distribution')">合作伙伴计划</button></li>
            </ul>
          </div>

          <div class="footer-col">
            <h4 class="footer-heading">客户服务</h4>
            <ul class="footer-links-list">
              <li><button type="button" @click="goTo('/help')">帮助中心</button></li>
              <li><button type="button" @click="goTo('/service')">售后政策</button></li>
              <li><button type="button" @click="goTo('/privacy')">隐私政策</button></li>
            </ul>
          </div>

          <div class="footer-col">
            <h4 class="footer-heading">采购导航</h4>
            <ul class="footer-links-list">
              <li><button type="button" @click="goTo('/products')">全部商品</button></li>
              <li><button type="button" @click="goTo('/products?scene=new')">新品上架</button></li>
              <li><button type="button" @click="goTo('/products?scene=hot')">热销推荐</button></li>
            </ul>
          </div>

          <div class="footer-col">
            <h4 class="footer-heading">页面说明</h4>
            <p class="footer-sub-text">{{ footerDescription }}</p>
          </div>
        </div>

        <div class="footer-bottom">
          <p class="copyright">© 2026 {{ homePage.siteName }}. 保留所有权利。</p>
          <p class="footer-note">当前详情页已按 PC 商城成交链路整理，后续继续承接平台原生营销能力。</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { CRMEB_MARKETING_ENDPOINTS, CRMEB_PROXY_BASE, CRMEB_USER_ENDPOINTS, resolveApiPath } from '~/config/crmeb-api'
import { HOME_FALLBACK_IMAGES } from '~/config/home'
import type { ProductDetailCouponItem, ProductDetailParamItem, ProductDetailSpecGroup } from '~/server/utils/product-detail'

definePageMeta({
  layout: 'home',
})

const router = useRouter()
const route = useRoute()
const activeImageIndex = ref(0)
const quantity = ref(1)
const selectedSpecs = ref<Record<string, string>>({})
const collectPending = ref(false)
const cartPending = ref(false)
const couponPendingId = ref(0)
const receivedCouponIds = ref<number[]>([])
const actionFeedback = ref('')
const actionFeedbackType = ref<'success' | 'error' | 'info'>('info')
const { homePage, loadHomePage } = useHomePage()
const { detail, loading: detailLoading, loadDetail } = useProductDetail()
const { session, refreshSession } = useCrmebSession()

const fallbackProductImage = HOME_FALLBACK_IMAGES.product

const detailBreadcrumbs = computed(() => detail.value.breadcrumbs ?? [])
const displayGallery = computed(() => {
  const images = detail.value.gallery.filter((item) => item && item.trim())
  return images.length ? Array.from(new Set(images)) : [fallbackProductImage]
})
const activeImage = computed(() => displayGallery.value[activeImageIndex.value] || displayGallery.value[0] || fallbackProductImage)
const colorSpecGroup = computed<ProductDetailSpecGroup | null>(() => {
  return detail.value.specGroups.find((group) => /color|颜色/i.test(group.name)) ?? null
})
const optionSpecGroups = computed(() => {
  return detail.value.specGroups.filter((group) => group !== colorSpecGroup.value)
})
const detailFacts = computed<ProductDetailParamItem[]>(() => detail.value.params)
const selectedSkuKey = computed(() => {
  if (!detail.value.specGroups.length) {
    return ''
  }

  return detail.value.specGroups
    .map((group) => selectedSpecs.value[group.name] || group.options[0] || '')
    .filter((value) => Boolean(value))
    .join('|')
})
const selectedSkuOption = computed(() => {
  if (!detail.value.skuOptions.length) {
    return null
  }

  const matched = detail.value.skuOptions.find((item) => item.key === selectedSkuKey.value || item.sku === selectedSkuKey.value)
  return matched ?? detail.value.skuOptions[0] ?? null
})
const displayPrice = computed(() => selectedSkuOption.value?.price || detail.value.price)
const displayOriginalPrice = computed(() => selectedSkuOption.value?.originalPrice || detail.value.originalPrice)
const displayStock = computed(() => selectedSkuOption.value?.stock ?? detail.value.stock)
const displayPriceNumber = computed(() => toFiniteNumber(displayPrice.value))
const displayOriginalPriceNumber = computed(() => toFiniteNumber(displayOriginalPrice.value))
const discountAmount = computed(() => {
  const amount = displayOriginalPriceNumber.value - displayPriceNumber.value
  return amount > 0 ? amount : 0
})
const reviewStats = computed(() => detail.value.reviewStats)
const visibleReviews = computed(() => detail.value.reviews.slice(0, 4))
const reviewTags = computed(() => {
  const stats = reviewStats.value
  if (!stats) {
    return []
  }

  return uniqueStrings([
    stats.total ? `累计 ${stats.total} 条评价` : '',
    stats.goodCount ? `好评 ${stats.goodCount}` : '',
    stats.neutralCount ? `中评 ${stats.neutralCount}` : '',
    stats.poorCount ? `差评 ${stats.poorCount}` : '',
  ]).slice(0, 4)
})
const marketingCoupons = computed<ProductDetailCouponItem[]>(() => detail.value.marketingCoupons
  .filter((item) => !receivedCouponIds.value.includes(item.id))
  .slice(0, 2))
const marketingActivities = computed(() => detail.value.marketingActivities.slice(0, 3))
const marketingQuickActions = computed(() => {
  const actions: Array<{ key: string; label: string; note: string; link: string }> = []

  if (marketingCoupons.value.length) {
    actions.push({
      key: 'coupon-center',
      label: '领券中心',
      note: '查看全部优惠券',
      link: '/coupons',
    })
  }

  if (marketingActivities.value.includes('秒杀活动')) {
    actions.push({
      key: 'seckill',
      label: '秒杀会场',
      note: '查看限时活动商品',
      link: '/seckill',
    })
  }

  if (marketingActivities.value.includes('砍价活动')) {
    actions.push({
      key: 'bargain',
      label: '砍价活动',
      note: '发起或参与砍价',
      link: '/activity?scene=bargain',
    })
  }

  if (marketingActivities.value.includes('拼团活动')) {
    actions.push({
      key: 'combination',
      label: '拼团专区',
      note: '查看正在进行的拼团',
      link: '/combination',
    })
  }

  return actions.slice(0, 3)
})
const preferredCoupon = computed<ProductDetailCouponItem | null>(() => {
  return marketingCoupons.value.find((item) => item.receiveType !== 4) ?? marketingCoupons.value[0] ?? null
})
const marketingTags = computed(() => uniqueStrings([
  ...marketingActivities.value,
  detail.value.badge ? `当前活动：${detail.value.badge}` : '',
  discountAmount.value > 0 ? `当前直降 $${discountAmount.value.toFixed(2)}` : '',
  marketingCoupons.value.length ? `${marketingCoupons.value.length} 张优惠券可领` : '',
  reviewStats.value && reviewStats.value.total > 0 ? `好评率 ${reviewStats.value.goodRate}%` : '',
]).slice(0, 4))
const marketingHeadline = computed(() => {
  if (preferredCoupon.value) {
    return preferredCoupon.value.receiveType === 4
      ? `当前最高优惠券 $${preferredCoupon.value.amount}`
      : `当前可领 $${preferredCoupon.value.amount} 优惠券`
  }

  if (marketingActivities.value.includes('秒杀活动')) {
    return '当前商品正在参与秒杀活动'
  }

  if (marketingActivities.value.includes('砍价活动')) {
    return '当前商品支持砍价活动'
  }

  if (detail.value.badge) {
    return `${detail.value.badge}活动已上线`
  }

  if (discountAmount.value > 0) {
    return `当前售价已优惠 $${discountAmount.value.toFixed(2)}`
  }

  return '当前商品活动以结算页为准'
})
const marketingDescription = computed(() => {
  if (preferredCoupon.value) {
    const bestCoupon = preferredCoupon.value
    return `${bestCoupon.scopeText}，${bestCoupon.receiveTypeText}，${bestCoupon.expireText}。满足门槛后可在结算时直接抵扣。`
  }

  if (marketingActivities.value.includes('秒杀活动')) {
    return '该商品已命中限时特惠活动，具体价格与生效时间以活动会场和结算页为准。'
  }

  if (marketingActivities.value.includes('砍价活动')) {
    return '该商品已命中互动优惠活动，发起与参与进度以后续活动页承接为准。'
  }

  if (detail.value.badge) {
    return `该商品当前带有“${detail.value.badge}”活动标识，具体优惠方式以下单结算页展示为准。`
  }

  if (discountAmount.value > 0) {
    return '当前展示价已低于划线价，可直接按现价下单。'
  }

  return '该商品暂无额外活动信息，价格、规格与服务保障以当前详情为准。'
})
const hasMarketingPanel = computed(() => (
  marketingCoupons.value.length > 0
  || marketingTags.value.length > 0
  || marketingQuickActions.value.length > 0
  || Boolean(detail.value.badge)
))
const hasRichDescription = computed(() => Boolean(detail.value.descriptionHtml.trim()))
const selectedSpecSummary = computed(() => {
  const entries = Object.entries(selectedSpecs.value)
    .filter(([, value]) => Boolean(value))
    .map(([name, value]) => `${name}: ${value}`)

  if (!entries.length) {
    return '请选择规格后继续加入购物车。'
  }

  return `当前选择 ${entries.join(' / ')}`
})
const footerDescription = computed(() => `${homePage.value.siteName} / 当前详情页已适配采购型详情结构。`)

useHead(() => ({
  title: detail.value.name ? `${detail.value.name} | NFR` : '商品详情 | NFR',
}))

function uniqueStrings(items: Array<string | undefined | null>): string[] {
  const seen = new Set<string>()
  const result: string[] = []

  for (const item of items) {
    const value = String(item ?? '').trim()
    if (!value) {
      continue
    }

    const key = value.toLowerCase()
    if (seen.has(key)) {
      continue
    }

    seen.add(key)
    result.push(value)
  }

  return result
}

function buildRouteQuery(overrides: Record<string, string | number | null | undefined>): Record<string, string | number> {
  const merged: Record<string, string | number> = {}

  for (const [key, rawValue] of Object.entries(route.query)) {
    const value = Array.isArray(rawValue) ? rawValue[0] : rawValue
    if (typeof value === 'string' && value.trim()) {
      merged[key] = value.trim()
    }
  }

  for (const [key, value] of Object.entries(overrides)) {
    if (value === null || value === undefined || value === '') {
      delete merged[key]
      continue
    }

    merged[key] = value
  }

  return merged
}

function formatCompactNumber(value: number): string {
  if (!Number.isFinite(value) || value <= 0) {
    return '0'
  }

  if (value >= 10000) {
    return `${(value / 10000).toFixed(1)}w`
  }

  return String(value)
}

function toFiniteNumber(value: string | number): number {
  const amount = Number(value)
  return Number.isFinite(amount) ? amount : 0
}

async function syncProductDetail(): Promise<void> {
  const productId = Number(route.params.id)
  await loadDetail(productId)
}

function goToLogin(): void {
  router.push(`/login?redirect=${encodeURIComponent(route.fullPath)}`)
}

function goTo(path: string): void {
  router.push(path)
}

function goToProduct(productId: number): void {
  router.push(`/product/${productId}`)
}

function applyCategory(categoryId: number | null): void {
  router.push({
    path: '/products',
    query: buildRouteQuery({
      category_id: categoryId,
      page: 1,
    }),
  })
}

function handleImageError(event: Event, fallbackSrc: string): void {
  const image = event.target as HTMLImageElement | null
  if (!image || !fallbackSrc || image.dataset.fallbackApplied === '1') {
    return
  }

  image.dataset.fallbackApplied = '1'
  image.src = fallbackSrc
}

function selectSpec(groupName: string, option: string): void {
  selectedSpecs.value = {
    ...selectedSpecs.value,
    [groupName]: option,
  }
  actionFeedback.value = ''
}

function changeQuantity(delta: number): void {
  quantity.value = Math.min(99, Math.max(1, quantity.value + delta))
}

function browseSimilarProducts(): void {
  const lastCategory = detailBreadcrumbs.value[detailBreadcrumbs.value.length - 1]
  if (lastCategory) {
    applyCategory(lastCategory.id)
    return
  }

  goTo('/products')
}

function setActionFeedback(type: 'success' | 'error' | 'info', message: string): void {
  actionFeedbackType.value = type
  actionFeedback.value = message.trim()
}

async function receiveCoupon(coupon: ProductDetailCouponItem): Promise<void> {
  if (couponPendingId.value === coupon.id) {
    return
  }

  if (!session.value.loggedIn) {
    goToLogin()
    return
  }

  couponPendingId.value = coupon.id

  try {
    const response = await $fetch<{ status?: number; msg?: string }>(resolveApiPath(CRMEB_PROXY_BASE, CRMEB_MARKETING_ENDPOINTS.couponReceive), {
      method: 'POST',
      body: {
        couponId: coupon.id,
      },
    })

    const message = String(response?.msg ?? '').trim()
    const status = Number(response?.status ?? 400)

    if (status !== 200) {
      if (message.includes('已领取')) {
        receivedCouponIds.value = Array.from(new Set([...receivedCouponIds.value, coupon.id]))
        setActionFeedback('success', message)
        return
      }

      throw new Error(message || '领取优惠券失败，请稍后再试。')
    }

    receivedCouponIds.value = Array.from(new Set([...receivedCouponIds.value, coupon.id]))
    setActionFeedback('success', message || '优惠券领取成功。')
  } catch (error) {
    const message = error instanceof Error ? error.message : '领取优惠券失败，请稍后再试。'
    setActionFeedback('error', message)
  } finally {
    couponPendingId.value = 0
  }
}

async function toggleCollect(): Promise<void> {
  if (collectPending.value) {
    return
  }

  if (!session.value.loggedIn) {
    goToLogin()
    return
  }

  collectPending.value = true

  try {
    const isCollected = detail.value.userCollect
    const endpoint = isCollected ? CRMEB_USER_ENDPOINTS.collectDel : CRMEB_USER_ENDPOINTS.collectAdd
    const body = isCollected
      ? { id: [detail.value.id], category: 'product' }
      : { id: detail.value.id, category: 'product' }

    const response = await $fetch<{ status?: number; msg?: string }>(resolveApiPath(CRMEB_PROXY_BASE, endpoint), {
      method: 'POST',
      body,
    })

    if (Number(response?.status ?? 400) !== 200) {
      throw new Error(response?.msg || (isCollected ? '取消收藏失败。' : '收藏失败。'))
    }

    detail.value.userCollect = !isCollected
    setActionFeedback('success', detail.value.userCollect ? '已加入收藏。' : '已取消收藏。')
    await refreshSession(true)
  } catch (error) {
    const message = error instanceof Error ? error.message : '收藏操作失败，请稍后再试。'
    setActionFeedback('error', message)
  } finally {
    collectPending.value = false
  }
}

async function addToCart(): Promise<void> {
  if (cartPending.value) {
    return
  }

  if (!session.value.loggedIn) {
    goToLogin()
    return
  }

  if (!detail.value.cartButton) {
    setActionFeedback('error', '当前商品暂不支持加入购物车。')
    return
  }

  if (detail.value.specGroups.length && !selectedSkuOption.value) {
    setActionFeedback('error', '当前规格组合暂不可下单，请重新选择规格。')
    return
  }

  if (displayStock.value > 0 && quantity.value > displayStock.value) {
    setActionFeedback('error', '购买数量超过当前规格库存。')
    return
  }

  cartPending.value = true

  try {
    const response = await $fetch<{ status?: number; msg?: string }>(resolveApiPath(CRMEB_PROXY_BASE, CRMEB_USER_ENDPOINTS.cartAdd), {
      method: 'POST',
      body: {
        productId: detail.value.id,
        cartNum: quantity.value,
        uniqueId: selectedSkuOption.value?.uniqueId || '',
        new: 0,
        is_new: 0,
        combinationId: 0,
        secKillId: 0,
        bargainId: 0,
        advanceId: 0,
        pinkId: 0,
      },
    })

    if (Number(response?.status ?? 400) !== 200) {
      throw new Error(response?.msg || '加入购物车失败。')
    }

    setActionFeedback('success', '已加入购物车。')
    await refreshSession(true)
  } catch (error) {
    const message = error instanceof Error ? error.message : '加入购物车失败，请稍后再试。'
    setActionFeedback('error', message)
  } finally {
    cartPending.value = false
  }
}

watch(() => route.params.id, () => {
  void syncProductDetail()
})

watch(displayGallery, (gallery) => {
  if (activeImageIndex.value >= gallery.length) {
    activeImageIndex.value = 0
  }
}, { immediate: true })

watch(() => detail.value.id, () => {
  activeImageIndex.value = 0
  quantity.value = 1
  actionFeedback.value = ''
  receivedCouponIds.value = []
  couponPendingId.value = 0

  const nextSelections: Record<string, string> = {}
  for (const group of detail.value.specGroups) {
    if (group.options.length) {
      nextSelections[group.name] = group.options[0]
    }
  }

  selectedSpecs.value = nextSelections
})

onMounted(async () => {
  await Promise.all([
    loadHomePage(),
    syncProductDetail(),
  ])
})
</script>

<style scoped>
* { box-sizing: border-box; }

button,
input {
  font: inherit;
}

button {
  border: none;
  background: none;
  padding: 0;
}

.detail-page {
  min-height: 100vh;
  background: #fff;
  color: #111;
}

.detail-main {
  padding: 22px 0 64px;
  background: #fff;
}

.detail-shell {
  width: min(1400px, calc(100vw - 32px));
  margin: 0 auto;
}

.detail-breadcrumb,
.detail-atf,
.detail-param-section,
.detail-rich-section,
.detail-related-section,
.footer-inner {
  width: min(1320px, 100%);
  margin-left: auto;
  margin-right: auto;
}

.detail-breadcrumb {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 22px;
  color: #6b7280;
  font-size: 12px;
}

.detail-breadcrumb button {
  color: #4b5563;
  cursor: pointer;
}

.detail-breadcrumb-current {
  color: #111;
}

.detail-state-card {
  width: min(1200px, 100%);
  margin: 0 auto;
  padding: 48px 24px;
  border: 1px solid #e5e7eb;
  border-radius: 24px;
  background: #fff;
  text-align: center;
  font-size: 15px;
  color: #4b5563;
}

.detail-atf {
  display: grid;
  grid-template-columns: minmax(0, 780px) minmax(0, 460px);
  gap: 64px;
  align-items: start;
  justify-content: space-between;
}

.detail-left-column,
.detail-right-column {
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.detail-gallery-panel {
  width: 100%;
  min-width: 0;
  display: grid;
  grid-template-columns: 56px minmax(0, 704px);
  gap: 18px;
  align-items: start;
}

.detail-thumb-rail {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.detail-thumb {
  width: 56px;
  height: 74px;
  border: 1px solid #d1d5db;
  border-radius: 10px;
  overflow: hidden;
  cursor: pointer;
  transition: border-color 0.2s ease, transform 0.2s ease;
}

.detail-thumb.active {
  border-color: #111;
  transform: translateX(2px);
}

.detail-thumb img,
.detail-stage-media img,
.detail-match-image img,
.detail-related-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.detail-stage {
  min-width: 0;
  position: relative;
  width: 100%;
  max-width: 704px;
}

.detail-stage-media {
  position: relative;
  width: 100%;
  margin: 0 auto;
  max-width: 100%;
  aspect-ratio: 675 / 898;
  overflow: hidden;
  border-radius: 22px;
  background: #f5f5f5;
}

.detail-stage-badge {
  position: absolute;
  top: 16px;
  left: 16px;
  padding: 6px 10px;
  border-radius: 999px;
  background: rgba(17, 17, 17, 0.82);
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.3px;
}

.detail-section-head,
.detail-side-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.detail-section-head h2,
.detail-side-head h3 {
  margin: 6px 0 0;
  font-size: 24px;
  line-height: 1.15;
  font-weight: 700;
}

.detail-side-head h3 {
  font-size: 18px;
}

.detail-section-kicker {
  display: inline-flex;
  align-items: center;
  min-height: 22px;
  padding: 0 10px;
  border-radius: 999px;
  background: #f3f4f6;
  color: #4b5563;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}

.detail-link-btn {
  min-height: 36px;
  padding: 0 16px;
  border: 1px solid #d1d5db;
  border-radius: 999px;
  color: #111;
  cursor: pointer;
}

.detail-review-panel,
.detail-info-panel,
.detail-side-card,
.detail-rich-card {
  width: 100%;
  min-width: 0;
  max-width: 100%;
  border: 1px solid #e5e7eb;
  background: #fff;
}

.detail-param-section {
  margin-top: 32px;
}

.detail-review-panel {
  padding: 28px;
  margin-top: 32px;
  border-radius: 24px;
}

.detail-review-score-card {
  display: grid;
  grid-template-columns: 180px 1fr;
  gap: 16px;
  align-items: stretch;
  margin-top: 18px;
}

.detail-review-score-main {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 6px;
  min-height: 132px;
  padding: 20px;
  background: #fafafa;
  border-radius: 18px;
}

.detail-review-score-main strong {
  font-size: 38px;
  line-height: 1;
  font-weight: 800;
}

.detail-review-score-main span,
.detail-review-metric span,
.detail-store-stat span,
.detail-mini-meta span {
  color: #6b7280;
  font-size: 11px;
}

.detail-review-metrics {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
}

.detail-review-metric {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 8px;
  min-height: 132px;
  padding: 18px 16px;
  background: #fafafa;
  border-radius: 18px;
}

.detail-review-metric strong,
.detail-store-stat strong {
  font-size: 20px;
  line-height: 1.3;
}

.detail-review-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 18px;
}

.detail-review-tag,
.detail-description-tag {
  min-height: 32px;
  padding: 0 14px;
  border-radius: 999px;
  background: #f3f4f6;
  color: #374151;
  font-size: 12px;
  display: inline-flex;
  align-items: center;
}

.detail-review-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
  margin-top: 18px;
}

.detail-review-card {
  padding: 18px 20px;
  background: #fafafa;
  border-radius: 18px;
}

.detail-review-card-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.detail-review-card-head strong {
  font-size: 14px;
}

.detail-review-card-head span,
.detail-review-card p,
.detail-subtitle,
.detail-selection-note,
.detail-side-list-item span,
.detail-match-body strong,
.detail-rich-copy-body :deep(p),
.detail-rich-copy-body :deep(li),
.footer-sub-text,
.footer-note,
.copyright {
  color: #4b5563;
  line-height: 1.75;
}

.detail-review-card p {
  margin: 0;
  font-size: 13px;
}

.detail-info-panel {
  padding: 28px;
  border-radius: 24px;
}

.detail-brand-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.detail-brand-chip,
.detail-rating-chip {
  min-height: 28px;
  padding: 0 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 700;
  display: inline-flex;
  align-items: center;
}

.detail-brand-chip {
  background: #111;
  color: #fff;
}

.detail-rating-chip {
  background: #f3f4f6;
  color: #111;
}

.detail-title {
  margin: 8px 0 8px;
  font-size: 24px;
  line-height: 1.42;
  font-weight: 700;
  letter-spacing: 0.01em;
}

.detail-marketing-panel {
  margin-top: 12px;
  padding: 18px 20px;
  border: 1px solid #e5e7eb;
  border-radius: 20px;
  background: linear-gradient(180deg, #fafafa 0%, #f5f5f5 100%);
}

.detail-marketing-summary {
  margin-top: 12px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.detail-marketing-summary strong {
  color: #111;
  font-size: 16px;
  line-height: 1.45;
}

.detail-marketing-summary p {
  margin: 0;
  color: #4b5563;
  font-size: 12px;
  line-height: 1.75;
}

.detail-marketing-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.detail-marketing-head span {
  color: #111;
  font-size: 13px;
  font-weight: 700;
}

.detail-marketing-link {
  padding: 0;
  border: 0;
  background: transparent;
  color: #4b5563;
  font-size: 11px;
  cursor: pointer;
  transition: color 0.2s ease;
}

.detail-marketing-link:hover {
  color: #111;
}

.detail-marketing-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 12px;
}

.detail-marketing-tag {
  min-height: 28px;
  padding: 0 10px;
  border: 1px solid #d1d5db;
  border-radius: 999px;
  background: #fff;
  color: #374151;
  font-size: 11px;
  display: inline-flex;
  align-items: center;
}

.detail-coupon-list {
  display: grid;
  gap: 10px;
  margin-top: 12px;
}

.detail-coupon-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  width: 100%;
  padding: 14px 16px;
  border: 1px solid #d1d5db;
  border-radius: 18px;
  background: #fff;
  color: #111;
  cursor: pointer;
  transition: border-color 0.2s ease, transform 0.2s ease;
}

.detail-coupon-card.is-member {
  border-color: #d6d3d1;
  background: linear-gradient(180deg, #fff 0%, #faf7f2 100%);
}

.detail-coupon-card:disabled {
  opacity: 0.68;
  cursor: not-allowed;
}

.detail-coupon-card:hover {
  border-color: #111;
  transform: translateY(-1px);
}

.detail-coupon-card:disabled:hover {
  border-color: #d1d5db;
  transform: none;
}

.detail-coupon-main {
  display: flex;
  align-items: center;
  gap: 14px;
  min-width: 0;
}

.detail-coupon-main strong {
  flex: 0 0 auto;
  font-size: 22px;
  line-height: 1;
  font-weight: 800;
}

.detail-coupon-meta {
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.detail-coupon-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.detail-coupon-meta span,
.detail-coupon-meta small,
.detail-coupon-cta {
  display: block;
}

.detail-coupon-meta span {
  color: #111;
  font-size: 12px;
  font-weight: 600;
  line-height: 1.5;
}

.detail-coupon-meta small {
  color: #6b7280;
  font-size: 11px;
  line-height: 1.5;
}

.detail-coupon-badges small {
  min-height: 24px;
  padding: 0 8px;
  border: 1px solid #e5e7eb;
  background: #f9fafb;
  color: #4b5563;
  display: inline-flex;
  align-items: center;
}

.detail-coupon-cta {
  flex: 0 0 auto;
  color: #111;
  font-size: 11px;
  font-style: normal;
  font-weight: 700;
}

.detail-marketing-actions {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
  margin-top: 12px;
}

.detail-marketing-action {
  min-width: 0;
  padding: 12px;
  border: 1px solid #d1d5db;
  border-radius: 16px;
  background: #fff;
  color: #111;
  text-align: left;
  cursor: pointer;
  transition: border-color 0.2s ease, transform 0.2s ease;
}

.detail-marketing-action:hover {
  border-color: #111;
  transform: translateY(-1px);
}

.detail-marketing-action strong,
.detail-marketing-action span {
  display: block;
}

.detail-marketing-action strong {
  font-size: 12px;
  line-height: 1.5;
}

.detail-marketing-action span {
  margin-top: 4px;
  color: #6b7280;
  font-size: 10px;
  line-height: 1.5;
}

.detail-price-panel {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 16px;
  align-items: end;
  padding: 20px 0 18px;
  border-bottom: 1px solid #e5e7eb;
}

.detail-price-label,
.detail-price-side span {
  display: block;
  margin-bottom: 6px;
  color: #6b7280;
  font-size: 11px;
}

.detail-price-current {
  font-size: 30px;
  line-height: 1.05;
  font-weight: 800;
}

.detail-price-old {
  margin-left: 8px;
  color: #9ca3af;
  text-decoration: line-through;
  font-size: 13px;
}

.detail-price-side {
  text-align: right;
}

.detail-price-side strong {
  font-size: 20px;
}

.detail-highlight-list,
.detail-side-list,
.detail-service-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.detail-highlight-list {
  margin-top: 18px;
}

.detail-service-list {
  margin-top: 18px;
}

.detail-side-empty,
.detail-related-empty {
  margin: 18px 0 0;
  padding: 18px;
  background: #fafafa;
  color: #6b7280;
  font-size: 13px;
  line-height: 1.7;
  border-radius: 18px;
}

.detail-highlight-item,
.detail-side-list-item,
.detail-service-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  font-size: 13px;
}

.detail-highlight-dot {
  width: 8px;
  height: 8px;
  margin-top: 8px;
  border-radius: 999px;
  background: #111;
  flex: 0 0 auto;
}

.detail-option-block {
  padding-top: 16px;
  border-top: 1px solid #e5e7eb;
  margin-top: 16px;
}

.detail-option-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 10px;
  font-size: 13px;
}

.detail-option-head strong {
  font-size: 12px;
}

.detail-color-grid,
.detail-size-grid,
.detail-description-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.detail-color-chip,
.detail-size-chip {
  min-height: 38px;
  padding: 0 12px;
  border: 1px solid #d1d5db;
  border-radius: 10px;
  background: #fff;
  color: #111;
  cursor: pointer;
  transition: border-color 0.2s ease, background 0.2s ease, color 0.2s ease;
  font-size: 12px;
}

.detail-color-chip.active,
.detail-size-chip.active {
  border-color: #111;
  background: #111;
  color: #fff;
}

.detail-quantity-row {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-top: 18px;
}

.detail-quantity-label {
  min-width: 42px;
  font-size: 13px;
}

.detail-quantity-box {
  display: inline-flex;
  align-items: center;
  border: 1px solid #d1d5db;
  border-radius: 10px;
  overflow: hidden;
}

.detail-quantity-box button,
.detail-quantity-box strong {
  width: 40px;
  height: 40px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.detail-quantity-box button {
  cursor: pointer;
}

.detail-selection-note {
  margin: 16px 0 0;
  font-size: 12px;
}

.detail-action-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  margin-top: 18px;
}

.detail-primary-btn,
.detail-secondary-btn {
  min-height: 44px;
  border-radius: 12px;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
  transition: background 0.2s ease, color 0.2s ease, border-color 0.2s ease, opacity 0.2s ease;
}

.detail-primary-btn {
  background: #111;
  color: #fff;
}

.detail-secondary-btn {
  border: 1px solid #111;
  color: #111;
}

.detail-secondary-btn.is-active {
  background: #111;
  color: #fff;
}

.detail-primary-btn:disabled,
.detail-secondary-btn:disabled {
  opacity: 0.56;
  cursor: not-allowed;
}

.detail-action-links {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 12px;
}

.detail-inline-link {
  padding: 0;
  border: 0;
  background: transparent;
  color: #4b5563;
  font-size: 12px;
  line-height: 1;
  cursor: pointer;
  transition: color 0.2s ease;
}

.detail-inline-link:hover {
  color: #111;
}

.detail-inline-divider {
  color: #d1d5db;
  font-size: 12px;
  line-height: 1;
}

.detail-action-feedback {
  margin: 12px 0 0;
  font-size: 12px;
  line-height: 1.7;
}

.detail-action-feedback.is-success {
  color: #166534;
}

.detail-action-feedback.is-error {
  color: #b91c1c;
}

.detail-action-feedback.is-info {
  color: #4b5563;
}

.detail-mini-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  padding-top: 16px;
  margin-top: 16px;
  border-top: 1px solid #e5e7eb;
}

.detail-side-card {
  padding: 24px;
  border-radius: 24px;
}

.detail-store-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
}

.detail-param-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 0 28px;
  margin-top: 20px;
}

.detail-store-stat,
.detail-param-card {
  padding: 16px 18px;
  background: #fafafa;
  border-radius: 16px;
}

.detail-param-card {
  display: grid;
  grid-template-columns: minmax(76px, 0.42fr) minmax(0, 1fr);
  align-items: start;
  gap: 14px;
  padding: 16px 0 15px;
  border: 0;
  border-bottom: 1px solid #e5e7eb;
  background: transparent;
  border-radius: 0;
}

.detail-rich-card.detail-param-surface {
  padding: 30px;
  border-top: 1px solid #111;
  border-left: 0;
  border-right: 0;
  border-bottom: 1px solid #e5e7eb;
  border-radius: 0;
}

.detail-param-card span {
  position: relative;
  padding-right: 14px;
  color: #6b7280;
  font-size: 11px;
  font-weight: 700;
  line-height: 1.65;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.detail-param-card strong {
  color: #111;
  font-size: 14px;
  font-weight: 500;
  line-height: 1.75;
  word-break: break-word;
}

.detail-param-card span::after {
  content: '';
  position: absolute;
  top: 3px;
  right: 0;
  width: 1px;
  height: calc(100% - 6px);
  background: #d1d5db;
}

.detail-param-surface .detail-section-kicker {
  min-height: auto;
  padding: 0 0 8px;
  border-radius: 0;
  border-bottom: 1px solid #111;
  background: transparent;
  color: #111;
  letter-spacing: 0.16em;
}

.detail-match-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
}

.detail-match-card {
  cursor: pointer;
}

.detail-match-image {
  aspect-ratio: 1 / 1.2;
  overflow: hidden;
  background: #f5f5f5;
}

.detail-match-body {
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding-top: 8px;
}

.detail-match-body strong {
  font-size: 12px;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.detail-match-body span {
  font-size: 13px;
  font-weight: 700;
}

.detail-rich-card {
  padding: 28px;
  border-radius: 24px;
}

.detail-rich-copy-body {
  margin-top: 20px;
  overflow: hidden;
}

.detail-rich-copy-body :deep(*) {
  max-width: 100%;
}

.detail-rich-copy-body :deep(img) {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 0 auto;
  border-radius: 18px;
}

.detail-rich-copy-body :deep(.detail-rich-image-stack) {
  display: grid;
  gap: 20px;
}

.detail-rich-copy-body :deep(.detail-rich-image-item) {
  margin: 0;
}

.detail-rich-copy-body :deep(table),
.detail-rich-copy-body :deep(div) {
  max-width: 100%;
}

.detail-rich-copy-body :deep(table) {
  width: 100% !important;
  border-collapse: collapse;
  margin: 0 auto 18px;
}

.detail-rich-copy-body :deep(td),
.detail-rich-copy-body :deep(th) {
  vertical-align: top;
}

.detail-rich-copy-body :deep(a) {
  color: #111;
  text-decoration: none;
}

.detail-rich-copy-body :deep(a:hover) {
  text-decoration: underline;
}

.detail-rich-copy-body :deep(h1),
.detail-rich-copy-body :deep(h2),
.detail-rich-copy-body :deep(h3),
.detail-rich-copy-body :deep(h4) {
  color: #111;
  line-height: 1.4;
}

.detail-rich-copy-body :deep(p) {
  margin: 0 0 10px;
  font-size: 13px;
}

.detail-rich-copy-body :deep(ul),
.detail-rich-copy-body :deep(ol) {
  margin: 0 0 16px;
  padding-left: 20px;
}

.detail-related-section {
  margin-top: 32px;
}

.detail-rich-section {
  margin-top: 32px;
}

.detail-related-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 18px;
  margin-top: 18px;
}

.detail-related-card {
  cursor: pointer;
}

.detail-related-image {
  position: relative;
  aspect-ratio: 1 / 1.28;
  overflow: hidden;
  border-radius: 18px;
  background: #f5f5f5;
}

.detail-related-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  min-height: 24px;
  padding: 0 8px;
  border-radius: 999px;
  background: rgba(17, 17, 17, 0.8);
  color: #fff;
  font-size: 11px;
  display: inline-flex;
  align-items: center;
}

.detail-related-body {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding-top: 12px;
}

.detail-related-body strong {
  font-size: 12px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.detail-related-price-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.detail-related-price {
  font-size: 16px;
  font-weight: 800;
}

.detail-related-old-price {
  color: #9ca3af;
  text-decoration: line-through;
  font-size: 12px;
}

.main-footer {
  padding: 40px 0 28px;
  background: #111;
  color: #fff;
}

.footer-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 24px;
}

.footer-heading {
  margin: 0 0 16px;
  font-size: 16px;
}

.footer-links-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.footer-links-list button {
  color: rgba(255, 255, 255, 0.72);
  cursor: pointer;
}

.footer-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-top: 28px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.14);
}

.footer-sub-text,
.footer-note,
.copyright {
  margin: 0;
  color: rgba(255, 255, 255, 0.7);
  font-size: 13px;
}

@media (max-width: 1260px) {
  .detail-shell {
    width: calc(100vw - 24px);
  }

  .detail-atf {
    grid-template-columns: minmax(0, 680px) minmax(0, 400px);
    gap: 40px;
  }

  .detail-related-grid {
    grid-template-columns: repeat(4, minmax(0, 1fr));
  }

  .detail-param-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}

@media (max-width: 1180px) {
  .detail-atf {
    grid-template-columns: 1fr;
  }

  .detail-left-column,
  .detail-right-column,
  .detail-gallery-panel,
  .detail-stage,
  .detail-stage-media,
  .detail-review-panel,
  .detail-info-panel,
  .detail-side-card,
  .detail-rich-card {
    width: 100%;
    max-width: 100%;
  }

  .detail-related-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .detail-param-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 860px) {
  .detail-gallery-panel {
    grid-template-columns: 1fr;
    gap: 14px;
  }

  .detail-thumb-rail {
    width: 100%;
    max-width: 100%;
    flex-direction: row;
    overflow-x: auto;
    overflow-y: hidden;
    padding-bottom: 2px;
  }

  .detail-thumb {
    flex: 0 0 auto;
  }

  .detail-stage,
  .detail-stage-media,
  .detail-review-score-card,
  .detail-review-metrics,
  .detail-price-panel,
  .detail-match-grid,
  .detail-related-grid {
    width: 100%;
    max-width: 100%;
    min-width: 0;
  }

  .detail-review-score-card,
  .detail-store-grid,
  .detail-param-grid,
  .detail-action-row,
  .detail-marketing-actions,
  .footer-grid,
  .footer-bottom {
    grid-template-columns: 1fr;
  }

  .detail-review-metrics,
  .detail-related-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .detail-param-grid {
    grid-template-columns: 1fr;
  }

  .detail-param-card {
    grid-template-columns: 76px minmax(0, 1fr);
    gap: 12px;
    padding: 14px 0;
  }

  .detail-param-card span {
    font-size: 11px;
  }

  .detail-param-card strong {
    font-size: 13px;
    line-height: 1.6;
  }

  .detail-match-grid {
    grid-template-columns: 1fr 1fr;
  }

  .footer-bottom {
    display: grid;
  }
}
</style>

