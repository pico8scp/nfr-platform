<template>
  <div class="shein-home products-page">
    <div class="top-policy">
      <div class="policy-inner">
        <span class="policy-item">{{ homePage.topNotice }}</span>
        <span class="policy-item">全站类目实时更新</span>
        <span class="policy-item">精选货源稳定供给</span>
        <span class="policy-item">{{ homePage.siteName }}</span>
      </div>
    </div>

    <header class="main-header" :class="{ scrolled: isScrolled }">
      <div class="header-inner">
        <button class="logo-button" @click="goTo('/')">
          <span class="logo">NFR</span>
        </button>

        <button class="b2b-btn" @click="goTo('/b2b')" title="企业批发 - 企业账户">
          <span class="b2b-icon">🏭</span>
          <span class="b2b-text">
            <span class="b2b-main">企业批发</span>
            <span class="b2b-sub">企业账户</span>
          </span>
          <span class="b2b-vip">VIP</span>
        </button>

        <div class="header-search">
          <SiteSearchBox
            v-model="searchKeyword"
            placeholder="Search products, categories, activities..."
            button-text="Search"
            @submit="handleSearch"
          />
        </div>

        <div class="header-actions">
          <button class="action-btn" title="收藏" @click="openCollectPanel">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
            <span class="action-badge">{{ formatBadgeCount(headerCollectCount) }}</span>
          </button>
          <button class="action-btn" title="购物车" @click="openCartPanel">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            <span class="action-badge">{{ formatBadgeCount(headerCartCount) }}</span>
          </button>
          <button class="signin-btn" :class="{ 'is-authenticated': session.loggedIn }" :title="session.loggedIn ? '用户中心' : '登录'" @click="handleHeaderAccountAction">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            <span>{{ session.loggedIn ? '用户中心' : '登录' }}</span>
          </button>
        </div>
      </div>
    </header>

    <nav class="category-nav">
      <div class="category-nav-inner">
        <div
          class="all-category-entry"
          @mouseenter="openCategoryMenu()"
          @mouseleave="closeCategoryMenu()"
        >
          <button class="cat-item cat-item-all" @click="goTo('/products')">
            <span class="cat-item-all-icon">☰</span>
            <span>全部分类</span>
            <span class="cat-item-all-arrow">▾</span>
          </button>

          <div v-if="categoryMenuOpen && activeCategoryRoot" class="category-mega-menu">
            <div class="category-root-list">
              <div class="category-root-list-head">
                <span class="category-root-list-kicker">NFR Supply</span>
                <strong class="category-root-list-title">核心类目</strong>
              </div>
              <button
                v-for="root in categoryMenuRoots"
                :key="root.id"
                class="category-root-item"
                :class="{ active: root.id === activeCategoryRoot?.id }"
                @mouseenter="setActiveCategoryRoot(root.id)"
                @click="goToCategory(root)"
              >
                <span class="category-root-item-main">
                  <span class="category-root-name">{{ root.name }}</span>
                  <span class="category-root-meta">{{ root.children.length }} 个子分类</span>
                </span>
                <span class="category-root-arrow">›</span>
              </button>
            </div>

            <div class="category-panel-content">
              <div class="category-panel-header">
                <div class="category-panel-header-main">
                  <span class="category-panel-kicker">平台分类</span>
                  <button class="category-panel-title" @click="goToCategory(activeCategoryRoot)">
                    {{ activeCategoryRoot.name }}
                  </button>
                  <p class="category-panel-subtitle">
                    当前类目下共有 {{ activeCategoryRoot.children.length }} 组细分频道。
                  </p>
                </div>
                <button class="category-panel-all" @click="goToCategory(activeCategoryRoot)">查看类目</button>
              </div>

              <div class="category-panel-groups">
                <div
                  v-for="child in activeCategoryRoot.children.slice(0, 18)"
                  :key="child.id"
                  class="category-panel-group"
                >
                  <div class="category-panel-group-head">
                    <button class="category-panel-group-title" @click="goToCategory(child)">
                      {{ child.name }}
                    </button>
                    <span class="category-panel-group-count">{{ child.children.length || 0 }} items</span>
                  </div>
                  <div v-if="child.children.length" class="category-panel-links">
                    <button
                      v-for="grand in child.children.slice(0, 10)"
                      :key="grand.id"
                      class="category-panel-link"
                      @click="goToCategory(grand)"
                    >
                      {{ grand.name }}
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <button class="cat-item active" @click="goTo('/')">Home</button>
        <button
          v-for="item in primaryNavItems"
          :key="item.id"
          class="cat-item"
          @click="goToCategory(item)"
        >
          {{ item.name }}
        </button>
        <span class="nav-divider"></span>
        <button class="cat-item cat-special" @click="goTo('/activity')">活动中心</button>
        <button class="cat-item cat-distributor" @click="goTo('/distribution')">分销商</button>
        <button class="cat-item cat-item-sale" @click="goTo('/seckill')">限时特惠</button>
      </div>
    </nav>

    <main class="catalog-main">
      <section class="catalog-shell">
        <div class="catalog-intro">
          <div class="catalog-breadcrumb">
            <button type="button" @click="goTo('/')">首页</button>
            <template v-for="item in breadcrumbItems" :key="item.id">
              <span>/</span>
              <button type="button" @click="applyCategory(item.id)">{{ item.name }}</button>
            </template>
            <template v-if="catalog.keyword">
              <span>/</span>
              <span class="catalog-breadcrumb-current">搜索结果</span>
            </template>
          </div>

          <div class="catalog-intro-main">
            <div>
              <span class="catalog-kicker">{{ catalog.scene === 'hot' ? '热门榜单' : catalog.keyword ? '关键词搜索' : '分类浏览' }}</span>
              <h1 class="catalog-title">{{ catalogTitle }}</h1>
              <p class="catalog-subtitle">{{ catalogSubtitle }}</p>
            </div>
            <div class="catalog-summary-inline">
              <strong>{{ catalog.total }}</strong>
              <span>个匹配结果</span>
            </div>
          </div>
        </div>

        <div v-if="quickLinkItems.length" class="catalog-quick-row">
          <div class="catalog-quick-label">猜你想搜：</div>
          <div class="catalog-quick-links">
            <button
              v-for="item in quickLinkItems"
              :key="`${item.type}-${item.keyword || item.categoryId || item.label}`"
              type="button"
              class="catalog-quick-chip"
              @click="handleQuickLink(item)"
            >
              {{ item.label }}
            </button>
          </div>
        </div>

        <div class="catalog-layout">
          <aside class="catalog-sidebar-area">
            <div class="catalog-filter-panel">
              <div class="catalog-filter-row">
                <span class="catalog-filter-label">浏览方式</span>
                <div class="catalog-filter-options">
                  <button type="button" class="catalog-filter-chip" :class="{ active: !catalog.scene }" @click="applyScene('')">全部</button>
                  <button type="button" class="catalog-filter-chip" :class="{ active: catalog.scene === 'new' }" @click="applyScene('new')">新品</button>
                  <button type="button" class="catalog-filter-chip" :class="{ active: catalog.scene === 'hot' }" @click="applyScene('hot')">热卖</button>
                </div>
              </div>

              <div v-if="catalog.popularKeywords.length" class="catalog-filter-row">
                <span class="catalog-filter-label">关键词</span>
                <div class="catalog-filter-options">
                  <button
                    v-for="keyword in catalog.popularKeywords"
                    :key="keyword"
                    type="button"
                    class="catalog-filter-chip"
                    :class="{ active: catalog.keyword === keyword }"
                    @click="applyKeyword(keyword)"
                  >
                    {{ keyword }}
                  </button>
                </div>
              </div>

              <div
                v-for="group in catalogFilterGroups"
                :key="group.key"
                class="catalog-filter-row"
              >
                <span class="catalog-filter-label">{{ group.label }}</span>
                <div class="catalog-filter-options">
                  <button
                    type="button"
                    class="catalog-filter-chip"
                    :class="{ active: !isFacetActive(group.key) }"
                    @click="applyFacet(group.key, null)"
                  >
                    全部
                  </button>
                  <button
                    v-for="option in group.options"
                    :key="`${group.key}-${option.value}`"
                    type="button"
                    class="catalog-filter-chip"
                    :class="{ active: isFacetActive(group.key, option.value) }"
                    @click="applyFacet(group.key, option.value)"
                  >
                    <span>{{ option.label }}</span>
                    <small>{{ option.count }}</small>
                  </button>
                </div>
              </div>
            </div>

            <div class="catalog-result-meta catalog-result-meta-sidebar">
              <span v-if="activeFilterSummary.length" class="catalog-result-tags">
                <span
                  v-for="tag in activeFilterSummary"
                  :key="tag"
                  class="catalog-result-tag"
                >
                  {{ tag }}
                </span>
              </span>
              <button v-if="activeFilterSummary.length" type="button" class="catalog-clear-btn" @click="clearActiveFilters">
                清空筛选
              </button>
              <span class="catalog-result-total">当前共 {{ catalog.total }} 件商品</span>
            </div>
          </aside>

          <section class="catalog-content catalog-content-full">
            <section class="catalog-content-main">
            <div class="catalog-toolbar">
              <div class="catalog-sort-list">
                <button
                  v-for="item in sortOptions"
                  :key="item.value"
                  type="button"
                  class="catalog-sort-btn"
                  :class="{ active: catalog.sort === item.value }"
                  @click="applySort(item.value)"
                >
                  {{ item.label }}
                </button>
              </div>

              <div class="catalog-page-indicator">
                第 {{ catalog.page }} / {{ catalog.totalPages }} 页
              </div>
            </div>

            <div v-if="catalogLoading" class="catalog-state-card">
              正在加载商品数据...
            </div>

            <div v-else-if="catalog.items.length" class="catalog-grid">
              <article v-for="product in catalog.items" :key="product.id" class="product-card">
                <div class="product-img">
                  <img :src="product.image" :alt="product.name" @error="handleImageError($event, fallbackProductImage)" @click="goToProduct(product.id)" />
                  <span v-if="product.badge" class="product-tag">{{ product.badge }}</span>
                </div>
                <div class="product-info">
                  <p class="product-name" @click="goToProduct(product.id)">{{ product.name }}</p>
                  <div class="product-meta">
                    <span v-if="product.score > 0">评分 {{ product.score.toFixed(1) }}</span>
                    <span>销量 {{ product.sales }}</span>
                    <span>库存 {{ product.stock }}</span>
                    <span v-if="product.unitName">{{ product.unitName }}</span>
                  </div>
                  <div class="product-price-row">
                    <span class="product-price">¥{{ product.price }}</span>
                    <span v-if="product.originalPrice" class="product-old-price">¥{{ product.originalPrice }}</span>
                    <span class="product-off">{{ productDiscount(product) }}%</span>
                  </div>
                  <div class="product-actions">
                    <button class="product-detail-btn" type="button" @click="goToProduct(product.id)">查看详情</button>
                    <button class="b2b-price-btn" type="button" @click="goTo('/b2b')">
                      <span class="b2b-price-icon">🏭</span>
                      <span class="b2b-price-text">B端参考价 <strong>¥{{ b2bPrice(product) }}</strong></span>
                    </button>
                  </div>
                </div>
              </article>
            </div>

            <div v-else class="catalog-state-card empty">
              <strong>暂无匹配商品</strong>
              <p>你可以切换分类、修改关键词，或者直接使用下方热词继续筛选。</p>
              <div class="empty-keywords">
                <button
                  v-for="keyword in catalog.popularKeywords"
                  :key="keyword"
                  type="button"
                  class="catalog-quick-chip"
                  @click="applyKeyword(keyword)"
                >
                  {{ keyword }}
                </button>
              </div>
            </div>

            <div class="catalog-pagination">
              <button type="button" class="page-btn" :disabled="catalog.page <= 1" @click="changePage(catalog.page - 1)">上一页</button>
              <button type="button" class="page-btn" :disabled="catalog.page >= catalog.totalPages" @click="changePage(catalog.page + 1)">下一页</button>
            </div>
            </section>
          </section>
        </div>
      </section>
    </main>

    <footer class="main-footer">
      <div class="footer-inner">
        <div class="footer-grid">
          <div class="footer-col">
            <h4 class="footer-heading">Company Info</h4>
            <ul class="footer-links-list">
              <li><button type="button" @click="goTo('/about')">About Us</button></li>
              <li><button type="button" @click="goTo('/activity')">Activity Center</button></li>
              <li><button type="button" @click="goTo('/distribution')">Become a Distributor</button></li>
            </ul>
          </div>

          <div class="footer-col">
            <h4 class="footer-heading">Customer Service</h4>
            <ul class="footer-links-list">
              <li><button type="button" @click="goTo('/help')">Help Center</button></li>
              <li><button type="button" @click="goTo('/service')">Return Policy</button></li>
              <li><button type="button" @click="goTo('/privacy')">Privacy Policy</button></li>
            </ul>
          </div>

          <div class="footer-col">
            <h4 class="footer-heading">Browse</h4>
            <ul class="footer-links-list">
              <li><button type="button" @click="goTo('/products')">All Products</button></li>
              <li><button type="button" @click="applyScene('new')">New Arrivals</button></li>
              <li><button type="button" @click="applyScene('hot')">Hot Sellers</button></li>
            </ul>
          </div>

          <div class="footer-col">
            <h4 class="footer-heading">Stay Updated</h4>
            <p class="footer-sub-text">{{ footerDescription }}</p>
          </div>
        </div>

        <div class="footer-bottom">
          <p class="copyright">© 2026 {{ homePage.siteName }}. All rights reserved.</p>
          <p class="footer-note">搜索与分类现在统一承接到商品列表页，后续详情页再单独补齐。</p>
        </div>
      </div>
    </footer>

    <button class="floating-cart" type="button" @click="openCartPanel">
      <span>🛒</span>
      <span class="floating-cart-count">{{ formatBadgeCount(headerCartCount) }}</span>
    </button>

    <div v-if="activeQuickPanel" class="quick-panel-backdrop" @click="closeQuickPanel">
      <section class="quick-panel" @click.stop>
        <div class="quick-panel-head">
          <div>
            <span class="quick-panel-kicker">{{ activeQuickPanel === 'cart' ? '购物车' : '收藏' }}</span>
            <h3>{{ quickPanelTitle }}</h3>
            <p>{{ quickPanelSummary }}</p>
          </div>
          <button class="quick-panel-close" type="button" @click="closeQuickPanel">×</button>
        </div>

        <p v-if="session.syncStatus === 'degraded'" class="quick-panel-alert">
          已识别登录状态，当前购物车或收藏数据正在同步，请稍后刷新。
        </p>

        <div v-if="quickPanelItems.length" class="quick-panel-list">
          <article v-for="item in quickPanelItems" :key="`${activeQuickPanel}-${item.id}`" class="quick-panel-item">
            <div class="quick-panel-thumb">
              <img v-if="item.image" :src="item.image" :alt="item.name" @error="handleImageError($event, fallbackProductImage)" />
              <span v-else class="quick-panel-thumb-empty">NFR</span>
            </div>
            <div class="quick-panel-item-main">
              <strong>{{ item.name }}</strong>
              <span v-if="item.price">${{ item.price }}</span>
            </div>
          </article>
        </div>
        <p v-else class="quick-panel-empty">{{ quickPanelEmptyText }}</p>

        <div class="quick-panel-actions">
          <button class="quick-panel-secondary" type="button" @click="closeQuickPanel">Close</button>
          <button v-if="!session.loggedIn" class="quick-panel-primary" type="button" @click="goToLogin">登录</button>
          <button v-else class="quick-panel-primary" type="button" @click="handleLogoutAction">Sign Out</button>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { HOME_DISPLAY_LIMITS, HOME_FALLBACK_IMAGES } from '~/config/home'
import { PRODUCT_LIST_DEFAULT_LIMIT, PRODUCT_SORT_OPTIONS, type ProductSortValue } from '~/config/product'
import type { CatalogFacetKey, CatalogQuickLinkItem } from '~/server/utils/product-catalog'

definePageMeta({
  layout: 'home',
})

useHead({
  title: 'NFR 商品列表',
})

type QuickPanelType = 'cart' | 'collect' | null

const router = useRouter()
const route = useRoute()
const searchKeyword = ref('')
const isScrolled = ref(false)
const categoryMenuOpen = ref(false)
const activeCategoryRootId = ref<number | null>(null)
const activeQuickPanel = ref<QuickPanelType>(null)
const { homePage, loadHomePage } = useHomePage()
const { catalog, loading: catalogLoading, loadCatalog } = useProductCatalog()
const { session, refreshSession, logout } = useCrmebSession()

const fallbackProductImage = HOME_FALLBACK_IMAGES.product
const categoryMenuRoots = computed(() => homePage.value.categoryTreeRoots)
const activeCategoryRoot = computed(() => {
  return categoryMenuRoots.value.find((item) => item.id === activeCategoryRootId.value) ?? categoryMenuRoots.value[0] ?? null
})
const primaryNavItems = computed(() => {
  return homePage.value.navItems
    .filter((item) => !item.link.includes('category_id='))
    .slice(0, HOME_DISPLAY_LIMITS.categoryEntries)
})
const headerCartCount = computed(() => session.value.loggedIn ? session.value.cartCount : homePage.value.cartCount)
const headerCollectCount = computed(() => session.value.collectCount)
const quickPanelItems = computed(() => activeQuickPanel.value === 'cart' ? session.value.cartItems : session.value.collectItems)
const quickPanelTitle = computed(() => activeQuickPanel.value === 'cart' ? '购物车预览' : '收藏预览')
const quickPanelSummary = computed(() => {
  const count = activeQuickPanel.value === 'cart' ? headerCartCount.value : headerCollectCount.value
  const label = activeQuickPanel.value === 'cart' ? 'items in your cart' : 'items in your wishlist'
  return `${count} ${label}`
})
const quickPanelEmptyText = computed(() => activeQuickPanel.value === 'cart' ? 'Your cart is currently empty.' : 'Your wishlist is currently empty.')
const breadcrumbItems = computed(() => catalog.value.selectedCategory?.path ?? [])
const quickLinkItems = computed(() => catalog.value.quickLinks)
const catalogFilterGroups = computed(() => catalog.value.facets)
const sortOptions = PRODUCT_SORT_OPTIONS
const RESERVED_QUERY_KEYS = new Set(['keyword', 'category_id', 'sort', 'scene', 'page', 'limit'])

const catalogTitle = computed(() => {
  if (catalog.value.keyword && catalog.value.selectedCategory) {
    return `${catalog.value.selectedCategory.name} / ${catalog.value.keyword}`
  }

  if (catalog.value.keyword) {
    return `搜索 “${catalog.value.keyword}”`
  }

  if (catalog.value.selectedCategory) {
    return catalog.value.selectedCategory.name
  }

  return '全部商品'
})

const catalogSubtitle = computed(() => {
  if (catalog.value.keyword && catalog.value.selectedCategory) {
    return `当前展示 ${catalog.value.selectedCategory.name} 下与“${catalog.value.keyword}”相关的商品，可继续按规格参数筛选。`
  }

  if (catalog.value.keyword) {
    return `已为你匹配“${catalog.value.keyword}”相关结果，可继续按价格、评分与规格参数缩小范围。`
  }

  if (catalog.value.selectedCategory) {
    return `当前分类下共找到 ${catalog.value.total} 件商品，可继续按左侧属性快速筛选。`
  }

  return '搜索、分类与活动流量统一承接到同一结果页。'
})

const footerDescription = computed(() => `${homePage.value.siteName} / 搜索结果与分类结果已统一为同一商品目录页。`)

const activeFilterSummary = computed(() => {
  const summary: string[] = []

  for (const group of catalogFilterGroups.value) {
    const selectedValue = catalog.value.selectedFilters[group.key]
    if (!selectedValue) {
      continue
    }

    const matched = group.options.find((option) => option.value === selectedValue)
    if (matched) {
      summary.push(`${group.label}: ${matched.label}`)
    }
  }

  return summary
})

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

function buildFacetResetQuery(): Record<string, null> {
  const reset: Record<string, null> = {}

  for (const key of Object.keys(route.query)) {
    if (!RESERVED_QUERY_KEYS.has(key)) {
      reset[key] = null
    }
  }

  return reset
}

function syncSearchKeyword(): void {
  searchKeyword.value = typeof route.query.keyword === 'string' ? route.query.keyword : ''
}

async function syncCatalog(): Promise<void> {
  syncSearchKeyword()

  const query: Record<string, string | number | undefined> = {
    limit: PRODUCT_LIST_DEFAULT_LIMIT,
  }

  for (const [key, rawValue] of Object.entries(route.query)) {
    const value = Array.isArray(rawValue) ? rawValue[0] : rawValue
    if (typeof value === 'string' && value.trim()) {
      query[key] = value.trim()
    }
  }

  await loadCatalog(query)
}

function goTo(path: string): void {

  categoryMenuOpen.value = false
  activeQuickPanel.value = null
  router.push(path)
}

function goToProduct(productId: number): void {
  closeQuickPanel()
  router.push(`/product/${productId}`)
}

function goToLogin(): void {
  goTo(`/login?redirect=${encodeURIComponent(route.fullPath)}`)
}

function handleImageError(event: Event, fallbackSrc: string): void {
  const image = event.target as HTMLImageElement | null
  if (!image || !fallbackSrc || image.dataset.fallbackApplied === '1') {
    return
  }

  image.dataset.fallbackApplied = '1'
  image.src = fallbackSrc
}

function goToCategory(item: { link?: string; id?: number }): void {
  categoryMenuOpen.value = false
  if (item.link) {
    router.push(item.link)
    return
  }

  router.push(`/products?category_id=${item.id ?? ''}`)
}

function openCategoryMenu(rootId?: number): void {
  categoryMenuOpen.value = true
  if (rootId) {
    activeCategoryRootId.value = rootId
    return
  }

  if (!activeCategoryRootId.value && categoryMenuRoots.value.length) {
    activeCategoryRootId.value = categoryMenuRoots.value[0].id
  }
}

function closeCategoryMenu(): void {
  categoryMenuOpen.value = false
}

function setActiveCategoryRoot(rootId: number): void {
  activeCategoryRootId.value = rootId
}

function handleSearch(value?: string): void {
  const keyword = String(value ?? searchKeyword.value).trim()
  if (!keyword) {
    return
  }

  searchKeyword.value = keyword
  router.push({
    path: '/products',
    query: buildRouteQuery({
      keyword,
      ...buildFacetResetQuery(),
      page: 1,
    }),
  })
}

function applyKeyword(keyword: string): void {
  searchKeyword.value = keyword
  router.push({
    path: '/products',
    query: buildRouteQuery({
      keyword,
      ...buildFacetResetQuery(),
      page: 1,
    }),
  })
}

function applyCategory(categoryId: number | null): void {
  router.push({
    path: '/products',
    query: buildRouteQuery({
      category_id: categoryId,
      ...buildFacetResetQuery(),
      page: 1,
    }),
  })
}

function applySort(sort: ProductSortValue): void {

  router.push({
    path: '/products',
    query: buildRouteQuery({
      sort: sort === 'default' ? null : sort,
      page: 1,
    }),
  })
}

function applyScene(scene: string): void {
  router.push({
    path: '/products',
    query: buildRouteQuery({
      scene: scene || null,
      page: 1,
    }),
  })
}

function isFacetActive(key: CatalogFacetKey, value?: string): boolean {
  const currentValue = catalog.value.selectedFilters[key]
  if (!value) {
    return !currentValue
  }

  return currentValue === value
}

function applyFacet(key: CatalogFacetKey, value: string | null): void {
  router.push({
    path: '/products',
    query: buildRouteQuery({
      [key]: value,
      page: 1,
    }),
  })
}

function clearActiveFilters(): void {
  router.push({
    path: '/products',
    query: buildRouteQuery({
      ...buildFacetResetQuery(),
      page: 1,
    }),
  })
}

function changePage(page: number): void {
  router.push({
    path: '/products',
    query: buildRouteQuery({ page }),
  })
}

function handleQuickLink(item: CatalogQuickLinkItem): void {
  if (item.type === 'category' && item.categoryId) {
    applyCategory(item.categoryId)
    return
  }

  if (item.keyword) {
    applyKeyword(item.keyword)
  }
}

function formatBadgeCount(count: number): string {
  if (count > 99) {
    return '99+'
  }

  return String(Math.max(0, count))
}

function closeQuickPanel(): void {
  activeQuickPanel.value = null
}

async function openCollectPanel(): Promise<void> {
  if (!session.value.loggedIn) {
    goToLogin()
    return
  }

  activeQuickPanel.value = 'collect'
  await refreshSession(true)
}

async function openCartPanel(): Promise<void> {
  if (!session.value.loggedIn) {
    goToLogin()
    return
  }

  activeQuickPanel.value = 'cart'
  await refreshSession(true)
}

function handleHeaderAccountAction(): void {
  if (!session.value.loggedIn) {
    goToLogin()
    return
  }

  closeQuickPanel()
}

async function handleLogoutAction(): Promise<void> {
  closeQuickPanel()
  await logout()
}

function handleScroll(): void {
  isScrolled.value = window.scrollY > 20
}

function productDiscount(product: { price: string; originalPrice: string }): string {
  const price = Number(product.price)
  const originalPrice = Number(product.originalPrice)

  if (!originalPrice || !price || originalPrice <= price) {
    return '0'
  }

  return String(Math.round(((originalPrice - price) / originalPrice) * 100))
}

function b2bPrice(product: { price: string }): string {
  const price = Number(product.price)
  if (!price) {
    return '0.00'
  }

  return (price * 0.78).toFixed(2)
}

watch(categoryMenuRoots, (roots) => {
  if (!roots.length) {
    activeCategoryRootId.value = null
    return
  }

  if (!roots.some((item) => item.id === activeCategoryRootId.value)) {
    activeCategoryRootId.value = roots[0].id
  }
}, { immediate: true })

watch(() => route.fullPath, () => {
  void syncCatalog()
})

onMounted(async () => {
  await Promise.all([
    loadHomePage(true),
    refreshSession(true),
    syncCatalog(),
  ])

  window.addEventListener('scroll', handleScroll, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
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

.catalog-home {
  min-height: 100vh;
  background: #fff;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  color: #222;
}

.top-policy {
  background: #fff;
  border-bottom: 1px solid #eee;
}

.policy-inner,
.header-inner,
.category-nav-inner,
.catalog-shell,
.footer-inner {
  width: min(1446px, calc(100vw - 32px));
  margin: 0 auto;
}

.policy-inner {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 22px;
  min-height: 36px;
  font-size: 11px;
  color: #777;
  white-space: nowrap;
  overflow: hidden;
}

.policy-item::before {
  content: '•';
  color: #c7a44a;
  margin-right: 8px;
}

.policy-item:first-child::before {
  content: '';
  margin-right: 0;
}

.main-header {
  position: sticky;
  top: 0;
  z-index: 20;
  background: rgba(255, 255, 255, 0.96);
  border-bottom: 1px solid transparent;
  backdrop-filter: blur(12px);
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.main-header.scrolled {
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.header-inner {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 18px 0;
}

.logo-button {
  cursor: pointer;
  flex-shrink: 0;
}

.logo {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 48px;
  height: 34px;
  padding: 0 12px;
  background: #111;
  color: #fff;
  font-size: 24px;
  font-weight: 900;
  letter-spacing: 1px;
}

.b2b-btn {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 7px 12px;
  border: 1px solid #e7d8ac;
  background: linear-gradient(135deg, #fff9ec 0%, #f8efdb 100%);
  cursor: pointer;
  min-height: 34px;
}

.b2b-btn:hover {
  border-color: #d4b66e;
  box-shadow: 0 2px 8px rgba(212, 182, 110, 0.2);
}

.b2b-icon {
  font-size: 17px;
  line-height: 1;
}

.b2b-text {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  line-height: 1.1;
}

.b2b-main {
  font-size: 12px;
  font-weight: 700;
  color: #3b2d13;
}

.b2b-sub {
  font-size: 10px;
  color: #7d6b45;
}

.b2b-vip {
  font-size: 10px;
  font-weight: 800;
  color: #a37a17;
  background: #fff;
  padding: 2px 5px;
  border-radius: 3px;
  letter-spacing: 1px;
  border: 1px solid #e8d89a;
  align-self: flex-start;
  margin-top: -2px;
}

.header-search {
  flex: 1;
  max-width: 520px;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 2px;
  flex-shrink: 0;
  margin-left: auto;
}

.action-btn {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 38px;
  height: 38px;
  color: #444;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}

.action-btn:hover {
  background: #f5f5f5;
  color: #111;
}

.action-badge {
  position: absolute;
  top: 4px;
  right: 4px;
  background: #111;
  min-width: 16px;
  height: 16px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 3px;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
}

.signin-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background: #111;
  color: #fff;
  border: 1px solid transparent;
  border-radius: 3px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  margin-left: 6px;
  letter-spacing: 0.3px;
  height: 38px;
}

.signin-btn:hover { background: #333; }

.signin-btn.is-authenticated {
  background: #fff;
  color: #111;
  border-color: #111;
}

.signin-btn.is-authenticated:hover {
  background: #f5f5f5;
}

.category-nav {
  background: #fff;
  border-bottom: 2px solid #111;
  overflow: visible;
}

.category-nav-inner {
  display: flex;
  align-items: center;
  position: relative;
}

.all-category-entry {
  position: relative;
  flex-shrink: 0;
  margin-right: 10px;
}

.cat-item {
  padding: 12px 22px;
  font-size: 13px;
  font-weight: 500;
  color: #555;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
  white-space: nowrap;
  letter-spacing: 0.2px;
}

.cat-item:hover { color: #111; }
.cat-item.active { color: #111; border-bottom-color: #111; font-weight: 600; }

.cat-item-all {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 18px;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  color: #fff;
  font-weight: 700;
  border-bottom: none !important;
  margin-bottom: 0;
  border-radius: 0 0 10px 10px;
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.08);
}

.cat-item-all:hover {
  color: #fff;
  background: linear-gradient(135deg, #111827 0%, #1f2937 100%);
}

.cat-item-all-icon,
.cat-item-all-arrow {
  font-size: 12px;
  opacity: 0.9;
}

.nav-divider {
  width: 1px;
  height: 18px;
  background: #ddd;
  margin: 0 6px;
  flex-shrink: 0;
}

.cat-item-sale { color: #e60023; font-weight: 600; }

.category-mega-menu {
  position: absolute;
  top: calc(100% + 2px);
  left: 0;
  width: min(1120px, calc(100vw - 32px));
  min-height: 500px;
  display: grid;
  grid-template-columns: 240px 1fr;
  background:
    radial-gradient(circle at top right, rgba(255, 244, 230, 0.85), transparent 34%),
    linear-gradient(180deg, #ffffff 0%, #fffdfa 100%);
  border: 1px solid rgba(148, 163, 184, 0.22);
  border-radius: 0 22px 22px 22px;
  box-shadow: 0 28px 70px rgba(15, 23, 42, 0.22);
  overflow: hidden;
  z-index: 40;
}

.category-root-list,
.category-panel-content {
  overflow-y: auto;
}

.category-root-list {
  padding: 14px 0 10px;
  background:
    radial-gradient(circle at top left, rgba(251, 191, 36, 0.12), transparent 30%),
    linear-gradient(180deg, #111827 0%, #172033 52%, #1f2937 100%);
  border-right: 1px solid rgba(255, 255, 255, 0.08);
  max-height: 560px;
}

.category-root-list-head {
  padding: 0 16px 14px;
  margin: 0 14px 10px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.category-root-list-kicker {
  display: block;
  margin-bottom: 6px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1.4px;
  text-transform: uppercase;
  color: #fbbf24;
}

.category-root-list-title {
  display: block;
  font-size: 18px;
  font-weight: 800;
  letter-spacing: 0.2px;
  color: #f8fafc;
}

.category-panel-kicker,
.catalog-kicker {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: #a57b18;
}

.catalog-title {
  font-size: 22px;
  font-weight: 900;
  color: #111;
}

.category-root-item {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 13px 16px;
  margin: 0 10px;
  border-radius: 14px;
  color: rgba(226, 232, 240, 0.94);
  cursor: pointer;
  text-align: left;
  transition: background 0.18s ease, transform 0.18s ease, color 0.18s ease, box-shadow 0.18s ease;
}

.category-root-item:hover,
.category-root-item.active {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.12), rgba(251, 191, 36, 0.1));
  color: #fff;
  transform: translateX(3px);
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.08);
}

.category-root-item.active {
  font-weight: 700;
}

.category-root-item-main {
  display: flex;
  flex: 1;
  min-width: 0;
  flex-direction: column;
  gap: 4px;
}

.category-root-name {
  min-width: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.category-root-meta {
  font-size: 10px;
  letter-spacing: 0.3px;
  color: rgba(148, 163, 184, 0.92);
}

.category-root-arrow {
  color: rgba(251, 191, 36, 0.92);
  font-size: 15px;
}

.category-panel-content {
  padding: 26px 28px 28px;
  max-height: 560px;
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.96), rgba(248, 250, 252, 0.9));
}

.category-panel-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 22px;
}

.category-panel-header-main {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.category-panel-title {
  font-size: 26px;
  font-weight: 800;
  color: #111827;
  cursor: pointer;
  line-height: 1.1;
}

.category-panel-subtitle {
  margin: 0;
  font-size: 13px;
  line-height: 1.6;
  color: #64748b;
}

.category-panel-all {
  flex-shrink: 0;
  padding: 10px 16px;
  border-radius: 999px;
  background: #111827;
  color: #fff;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.2px;
  cursor: pointer;
  box-shadow: 0 10px 24px rgba(15, 23, 42, 0.14);
}

.category-panel-groups {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px 18px;
}

.category-panel-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px 16px 14px;
  border: 1px solid #e5e7eb;
  border-radius: 18px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.95), rgba(248, 250, 252, 0.92));
  box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05);
}

.category-panel-group-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.category-panel-group-title {
  font-size: 15px;
  font-weight: 700;
  color: #111827;
  cursor: pointer;
  text-align: left;
  line-height: 1.35;
}

.category-panel-group-count {
  flex-shrink: 0;
  padding: 4px 8px;
  border-radius: 999px;
  background: #fff7ed;
  color: #b45309;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.2px;
}

.category-panel-title,
.category-panel-group-title {
  cursor: pointer;
}

.category-panel-title:hover,
.category-panel-group-title:hover,
.category-panel-link:hover {
  color: #c11b2d;
}

.category-panel-links {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.category-panel-link {
  display: inline-flex;
  align-items: center;
  min-height: 34px;
  padding: 0 12px;
  background: #fff;
  border: 1px solid rgba(17, 17, 17, 0.06);
  font-size: 12px;
  font-weight: 700;
  color: #444;
  cursor: pointer;
}

.products-page .policy-inner {
  max-width: 1446px;
  width: auto;
  margin: 0 auto;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 38px;
  min-height: 0;
  gap: 0;
}

.products-page .policy-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 0 32px;
  font-size: 12px;
  color: #555;
  white-space: nowrap;
  border-right: 1px solid #eee;
  letter-spacing: 0.2px;
}

.products-page .policy-item::before {
  content: none;
}

.products-page .policy-item:last-child {
  border-right: none;
}

.products-page .main-header {
  background: #fff;
  border-bottom: 1px solid #eee;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
  backdrop-filter: none;
  transition: none;
}

.products-page .main-header.scrolled {
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.products-page .header-inner {
  max-width: 1446px;
  width: auto;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 12px 0;
}

.products-page .logo {
  display: inline;
  min-width: 0;
  height: auto;
  padding: 0;
  background: transparent;
  font-size: 28px;
  font-weight: 900;
  color: #111;
  letter-spacing: -2px;
  flex-shrink: 0;
  font-style: italic;
}

.products-page .b2b-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 7px 16px;
  background: #fff;
  border: 1.5px solid #c9a84c;
  border-radius: 4px;
  text-decoration: none;
  flex-shrink: 0;
  transition: all 0.2s;
  box-shadow: 0 1px 3px rgba(201, 168, 76, 0.15);
  cursor: pointer;
  min-height: 0;
}

.products-page .b2b-btn:hover {
  background: #fffdf5;
  box-shadow: 0 2px 8px rgba(201, 168, 76, 0.25);
  transform: translateY(-1px);
}

.products-page .b2b-icon { font-size: 18px; }
.products-page .b2b-text { display: flex; flex-direction: column; line-height: 1.2; }
.products-page .b2b-main { font-size: 12px; font-weight: 800; color: #111; letter-spacing: 0.3px; }
.products-page .b2b-sub { font-size: 9px; color: #777; font-weight: 500; }

.products-page .b2b-vip {
  font-size: 8px;
  font-weight: 900;
  color: #c9a84c;
  background: #f9f7f0;
  padding: 2px 5px;
  border-radius: 3px;
  letter-spacing: 1px;
  border: 1px solid #e8d89a;
  align-self: flex-start;
  margin-top: -2px;
}

.products-page .category-nav {
  background: #fff;
  border-bottom: 2px solid #111;
  overflow: visible;
}

.products-page .category-nav::-webkit-scrollbar { display: none; }

.products-page .category-nav-inner {
  max-width: 1446px;
  width: auto;
  margin: 0 auto;
  display: flex;
  align-items: center;
  position: relative;
}

.products-page .cat-special,
.products-page .cat-distributor {
  color: #fff !important;
  border-radius: 3px;
  padding: 5px 14px;
  margin: 0 4px;
  font-size: 12px;
  font-weight: 600;
  border-bottom: none !important;
  letter-spacing: 0.3px;
}

.products-page .cat-special { background: #e60023; }
.products-page .cat-special:hover { background: #c5001e; }
.products-page .cat-distributor { background: #2a2a6a; }
.products-page .cat-distributor:hover { background: #1a1a50; }

.products-page .category-root-list::-webkit-scrollbar,
.products-page .category-panel-content::-webkit-scrollbar {
  width: 10px;
}

.products-page .category-root-list::-webkit-scrollbar-thumb,
.products-page .category-panel-content::-webkit-scrollbar-thumb {
  background: rgba(148, 163, 184, 0.35);
  border-radius: 999px;
  border: 2px solid transparent;
  background-clip: padding-box;
}

.products-page .category-panel-link {
  padding: 7px 10px;
  border-radius: 999px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  font-size: 12px;
  color: #475569;
  line-height: 1.2;
  cursor: pointer;
  transition: border-color 0.18s ease, background 0.18s ease, color 0.18s ease, transform 0.18s ease;
}

.products-page .category-panel-all:hover {
  background: #e60023;
}

.products-page .category-panel-link:hover,
.products-page .category-panel-group-title:hover,
.products-page .category-panel-title:hover {
  color: #e60023;
}

.products-page .category-panel-link:hover {
  background: #fff1f2;
  border-color: #fecdd3;
  transform: translateY(-1px);
}

.catalog-main {
  background: linear-gradient(180deg, #faf7f2 0%, #fff 18%, #fff 100%);
  padding: 28px 0 48px;
}

.catalog-shell {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.catalog-intro,
.catalog-quick-row,
.catalog-sidebar-area,
.catalog-content,
.sidebar-card,
.catalog-toolbar,
.catalog-state-card,
.quick-panel {
  background: #fff;
  border: 1px solid #ece7df;
}

.catalog-intro {
  padding: 14px 18px;
}

.catalog-breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
  font-size: 12px;
  color: #666;
  margin-bottom: 8px;
}

.catalog-breadcrumb button {
  color: #666;
  cursor: pointer;
}

.catalog-breadcrumb-current {
  color: #111;
  font-weight: 700;
}

.catalog-intro-main {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
}

.catalog-title {
  margin: 4px 0 4px;
  font-size: 24px;
  line-height: 1.2;
}

.catalog-subtitle {
  margin: 0;
  font-size: 12px;
  line-height: 1.5;
  color: #666;
}

.catalog-summary-inline {
  flex-shrink: 0;
  display: inline-flex;
  align-items: baseline;
  gap: 6px;
  padding: 6px 10px;
  border: 1px solid #e5e7eb;
  background: #fff;
  color: #111;
}

.catalog-summary-inline strong {
  font-size: 16px;
  line-height: 1;
}

.catalog-summary-inline span {
  font-size: 12px;
  color: #8a7d6b;
  font-weight: 700;
}

.catalog-quick-row {
  display: grid;
  grid-template-columns: 120px 1fr;
  gap: 18px;
  align-items: start;
  padding: 18px 22px;
}

.catalog-quick-label {
  font-size: 13px;
  font-weight: 800;
  color: #111;
  line-height: 38px;
}

.catalog-quick-links,
.empty-keywords {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.catalog-quick-chip,
.catalog-filter-chip {
  min-height: 38px;
  padding: 0 14px;
  border: 1px solid #e7e1d8;
  background: #fff;
  font-size: 12px;
  font-weight: 700;
  color: #333;
  cursor: pointer;
}

.catalog-quick-chip:hover,
.catalog-filter-chip:hover {
  border-color: #111;
}

.catalog-layout {
  display: grid;
  grid-template-columns: 286px minmax(0, 1fr);
  gap: 18px;
  align-items: start;
}

.catalog-sidebar-area {
  position: sticky;
  top: 118px;
  padding: 0;
}

.catalog-content {
  padding: 18px;
}

.catalog-content-full {
  padding: 0;
}

.catalog-filter-panel {
  padding: 16px;
  background: linear-gradient(180deg, #fffdfa 0%, #fff 100%);
}

.catalog-filter-row + .catalog-filter-row {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #f0ebe4;
}

.catalog-filter-row {
  display: block;
  align-items: start;
}

.catalog-filter-label {
  display: block;
  padding-top: 0;
  margin-bottom: 10px;
  font-size: 13px;
  font-weight: 800;
  color: #111;
}

.catalog-filter-options {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.catalog-filter-chip {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  min-height: 34px;
  padding: 0 11px;
}

.catalog-filter-chip small {
  color: #8d7e6b;
  font-size: 11px;
  font-weight: 700;
}

.catalog-filter-chip.active {
  border-color: #111;
  background: #111;
  color: #fff;
}

.catalog-filter-chip.active small {
  color: rgba(255, 255, 255, 0.74);
}

.catalog-result-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 16px;
  border-top: 1px solid #efe9e1;
}

.catalog-result-meta-sidebar {
  display: block;
}

.catalog-result-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 10px;
}

.catalog-result-tag {
  display: inline-flex;
  align-items: center;
  min-height: 30px;
  padding: 0 12px;
  border: 1px solid #111;
  background: transparent;
  color: #111;
  font-size: 11px;
  font-weight: 800;
}

.catalog-clear-btn {
  display: inline-flex;
  align-items: center;
  min-height: 32px;
  padding: 0;
  margin-bottom: 12px;
  border-bottom: 1px solid #111;
  color: #111;
  font-size: 12px;
  font-weight: 800;
  cursor: pointer;
}

.catalog-result-total {
  font-size: 12px;
  font-weight: 700;
  color: #666;
}

.catalog-content-main {
  padding: 0;
}

.catalog-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 14px 16px;
  margin-bottom: 18px;
}

.catalog-sort-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.catalog-sort-btn {
  min-height: 38px;
  padding: 0 16px;
  border: 1px solid #e7e1d8;
  background: #fff;
  font-size: 12px;
  font-weight: 800;
  cursor: pointer;
}

.catalog-sort-btn.active {
  background: #111;
  color: #fff;
  border-color: #111;
}

.catalog-page-indicator {
  font-size: 12px;
  color: #666;
  font-weight: 700;
}

.catalog-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 18px;
}

.product-card {
  display: flex;
  flex-direction: column;
  background: #fff;
  border: 1px solid #ece7df;
  overflow: hidden;
}

.product-img {
  position: relative;
  aspect-ratio: 3 / 4;
  background: #f5f5f5;
  overflow: hidden;
}

.product-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  cursor: pointer;
}

.product-tag {
  position: absolute;
  top: 12px;
  left: 12px;
  padding: 6px 10px;
  background: rgba(17, 17, 17, 0.92);
  color: #fff;
  font-size: 11px;
  font-weight: 700;
}

.product-info {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px;
}

.product-name {
  margin: 0;
  font-size: 14px;
  line-height: 1.6;
  color: #111;
  min-height: 44px;
  cursor: pointer;
}

.product-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  font-size: 11px;
  color: #7a7a7a;
}

.product-price-row {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.product-price {
  font-size: 20px;
  font-weight: 800;
  color: #111;
}

.product-old-price {
  font-size: 12px;
  color: #999;
  text-decoration: line-through;
}

.product-off {
  font-size: 10px;
  color: #e60023;
  font-weight: 700;
}

.product-actions {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.product-detail-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 40px;
  padding: 0 12px;
  border: 1px solid #111;
  border-radius: 999px;
  background: #fff;
  color: #111;
  font-size: 12px;
  font-weight: 700;
  cursor: pointer;
}

.product-hint {
  display: none;
  font-size: 11px;
  line-height: 1.6;
  color: #8a8a8a;
}

.b2b-price-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  min-height: 40px;
  padding: 0 12px;
  background: #111;
  color: #fff;
  cursor: pointer;
}

.b2b-price-icon {
  font-size: 14px;
}

.b2b-price-text {
  font-size: 12px;
  font-weight: 700;
}

.catalog-state-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10px;
  min-height: 240px;
  padding: 32px;
  text-align: center;
}

.catalog-state-card.empty strong {
  font-size: 24px;
  color: #111;
}

.catalog-state-card p {
  margin: 0;
  max-width: 420px;
  color: #777;
  line-height: 1.7;
}

.catalog-pagination {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 20px;
}

.page-btn {
  min-width: 108px;
  min-height: 42px;
  border: 1px solid #111;
  background: #fff;
  color: #111;
  font-size: 13px;
  font-weight: 800;
  cursor: pointer;
}

.page-btn:disabled {
  border-color: #ddd;
  color: #aaa;
  cursor: not-allowed;
}

.main-footer {
  border-top: 1px solid #eee;
  background: #fff;
}

.footer-inner {
  padding: 36px 0 24px;
}

.footer-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 28px;
}

.footer-heading {
  margin: 0 0 14px;
  font-size: 14px;
  font-weight: 800;
  color: #111;
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
  color: #666;
  cursor: pointer;
}

.footer-sub-text {
  margin: 0;
  color: #666;
  line-height: 1.8;
  font-size: 13px;
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  gap: 18px;
  margin-top: 28px;
  padding-top: 20px;
  border-top: 1px solid #eee;
  font-size: 12px;
  color: #888;
}

.floating-cart {
  position: fixed;
  right: 24px;
  bottom: 24px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  min-height: 48px;
  padding: 0 16px;
  background: #111;
  color: #fff;
  box-shadow: 0 18px 36px rgba(17, 17, 17, 0.24);
  cursor: pointer;
  z-index: 12;
}

.floating-cart-count {
  min-width: 22px;
  height: 22px;
  border-radius: 999px;
  padding: 0 6px;
  background: #e60023;
  color: #fff;
  font-size: 11px;
  line-height: 22px;
  text-align: center;
  font-weight: 700;
}

.quick-panel-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(17, 17, 17, 0.44);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 40;
}

.quick-panel {
  width: min(520px, calc(100vw - 32px));
  padding: 22px;
}

.quick-panel-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 14px;
  margin-bottom: 18px;
}

.quick-panel-kicker {
  display: inline-block;
  margin-bottom: 6px;
  font-size: 11px;
  font-weight: 800;
  color: #a57b18;
  letter-spacing: 0.16em;
  text-transform: uppercase;
}

.quick-panel-head h3 {
  margin: 0 0 6px;
  font-size: 22px;
  color: #111;
}

.quick-panel-head p {
  margin: 0;
  font-size: 13px;
  color: #6f6f6f;
}

.quick-panel-close {
  width: 34px;
  height: 34px;
  font-size: 24px;
  line-height: 1;
  color: #666;
  cursor: pointer;
}

.quick-panel-alert {
  margin: 0 0 16px;
  padding: 11px 14px;
  background: #fff7ea;
  color: #8a5d12;
  font-size: 12px;
  line-height: 1.6;
}

.quick-panel-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  max-height: 320px;
  overflow-y: auto;
}

.quick-panel-item {
  display: flex;
  gap: 12px;
  align-items: center;
}

.quick-panel-thumb {
  width: 64px;
  height: 64px;
  background: #f4f4f4;
  overflow: hidden;
}

.quick-panel-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.quick-panel-thumb-empty {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  font-size: 12px;
  font-weight: 800;
  color: #777;
}

.quick-panel-item-main {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.quick-panel-item-main strong {
  font-size: 14px;
  line-height: 1.6;
  color: #111;
}

.quick-panel-item-main span {
  font-size: 12px;
  color: #666;
}

.quick-panel-empty {
  margin: 0;
  padding: 18px 0;
  color: #888;
  font-size: 13px;
  text-align: center;
}

.quick-panel-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 20px;
}

.quick-panel-secondary,
.quick-panel-primary {
  min-width: 104px;
  min-height: 40px;
  padding: 0 16px;
  font-size: 12px;
  font-weight: 800;
  cursor: pointer;
}

.quick-panel-secondary {
  border: 1px solid #ddd;
  background: #fff;
  color: #333;
}

.quick-panel-primary {
  background: #111;
  color: #fff;
}

@media (max-width: 1100px) {
  .catalog-layout {
    grid-template-columns: 1fr;
  }

  .catalog-sidebar-area {
    position: static;
  }

  .catalog-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .footer-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 767px) {
  .policy-inner,
  .header-inner,
  .category-nav-inner,
  .catalog-shell,
  .footer-inner {
    width: min(100vw - 20px, 1280px);
  }

  .header-inner {
    flex-wrap: wrap;
    gap: 12px;
  }

  .header-search {
    order: 3;
    width: 100%;
    max-width: none;
  }

  .header-actions {
    width: 100%;
    justify-content: space-between;
  }

  .b2b-btn {
    width: 100%;
    justify-content: space-between;
  }

  .category-nav {
    overflow-x: auto;
    scrollbar-width: none;
  }

  .category-nav-inner {
    width: max-content;
    min-width: 100%;
    padding-right: 12px;
  }

  .category-mega-menu {
    display: none;
  }

  .catalog-intro-main,
  .footer-bottom,
  .catalog-quick-row,
  .catalog-filter-row {
    grid-template-columns: 1fr;
    display: grid;
  }

  .catalog-sidebar-area {
    order: 2;
  }

  .catalog-title {
    font-size: 28px;
  }

  .catalog-result-meta {
    flex-direction: column;
    align-items: flex-start;
  }

  .catalog-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .catalog-toolbar {
    flex-direction: column;
    align-items: flex-start;
  }
}

@media (max-width: 520px) {
  .catalog-grid,
  .footer-grid {
    grid-template-columns: 1fr;
  }

  .floating-cart {
    right: 12px;
    bottom: 12px;
  }
}
</style>
