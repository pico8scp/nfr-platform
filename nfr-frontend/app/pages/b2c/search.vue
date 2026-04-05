<template>
  <div class="b2c-search">
    <SiteHeader />

    <!-- ========== 主体：左侧筛选 + 主内容 ========== -->
    <div class="search-body">

      <!-- 面包屑 -->
      <div class="breadcrumb-bar">
        <div class="breadcrumb-inner">
          <span class="breadcrumb-item">Products</span>
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
          <span class="breadcrumb-item active">{{ route.query.cat || 'All Products' }}</span>
          <span v-if="route.query.q" class="breadcrumb-sep">|</span>
          <span v-if="route.query.q" class="breadcrumb-item active">"{{ route.query.q }}"</span>
        </div>
      </div>

      <div class="search-layout">

        <!-- ===== 左侧筛选栏 (阿里风格) ===== -->
        <aside class="filter-sidebar">
          <!-- 分类筛选 -->
          <div class="filter-section">
            <div class="filter-title">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M7 12h10M10 18h4"/></svg>
              Categories
            </div>
            <div class="category-list">
              <label v-for="cat in sideCategories" :key="cat.name" class="cat-filter-item">
                <input type="radio" name="cat-filter" :value="cat.name" v-model="selectedCategory" class="cat-radio" />
                <span class="cat-label">{{ cat.name }}</span>
                <span class="cat-count">{{ cat.count }}</span>
              </label>
            </div>
          </div>

          <!-- Trade Assurance -->
          <div class="filter-section">
            <div class="filter-title">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
              Trade Assurance
            </div>
            <label class="toggle-filter">
              <input type="checkbox" v-model="filters.tradeAssurance" />
              <span class="toggle-label">Protects your orders on NFR</span>
            </label>
          </div>

          <!-- Supplier Type -->
          <div class="filter-section">
            <div class="filter-title">Supplier Type</div>
            <label class="toggle-filter" v-for="s in supplierTypes" :key="s">
              <input type="checkbox" v-model="filters.supplierTypes" :value="s" />
              <span class="toggle-label">{{ s }}</span>
            </label>
          </div>

          <!-- Delivery Date -->
          <div class="filter-section">
            <div class="filter-title">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
              Delivery by
            </div>
            <div class="delivery-btns">
              <button v-for="d in deliveryDates" :key="d.label" class="delivery-btn" :class="{ active: filters.delivery === d.label }" @click="filters.delivery = filters.delivery === d.label ? '' : d.label">
                {{ d.label }}
              </button>
            </div>
          </div>

          <!-- Rating -->
          <div class="filter-section">
            <div class="filter-title">Supplier Rating</div>
            <div class="rating-filters">
              <button v-for="r in [4, 4.5, 5]" :key="r" class="rating-btn" :class="{ active: filters.minRating === r }" @click="filters.minRating = filters.minRating === r ? 0 : r">
                <span class="stars">{{ '★'.repeat(Math.round(r)) }}</span>
                <span class="rating-label">&amp; up</span>
              </button>
            </div>
          </div>

          <!-- Price Range -->
          <div class="filter-section">
            <div class="filter-title">Price Range</div>
            <div class="price-inputs">
              <input v-model="filters.priceMin" type="number" placeholder="Min" class="price-input" min="0" />
              <span class="price-sep">—</span>
              <input v-model="filters.priceMax" type="number" placeholder="Max" class="price-input" min="0" />
            </div>
            <button class="price-ok-btn" @click="applyPriceFilter">OK</button>
          </div>

          <!-- MOQ -->
          <div class="filter-section">
            <div class="filter-title">Min. Order</div>
            <div class="price-inputs">
              <input v-model="filters.moq" type="number" placeholder="MOQ (pieces)" class="price-input" min="1" style="width:100%" />
            </div>
            <button class="price-ok-btn" @click="applyPriceFilter">OK</button>
          </div>

          <!-- Supplier Country -->
          <div class="filter-section">
            <div class="filter-title">Country / Region</div>
            <div class="country-list">
              <label v-for="c in countries" :key="c.code" class="country-item">
                <input type="checkbox" v-model="filters.countries" :value="c.code" />
                <span class="country-flag">{{ c.flag }}</span>
                <span class="country-name">{{ c.name }}</span>
                <span class="cat-count">{{ c.count }}</span>
              </label>
            </div>
          </div>

          <!-- Product Certifications -->
          <div class="filter-section">
            <div class="filter-title">Product Certifications</div>
            <div class="cert-list">
              <label v-for="cert in certifications" :key="cert" class="cert-item">
                <input type="checkbox" v-model="filters.certs" :value="cert" />
                <span>{{ cert }}</span>
              </label>
            </div>
          </div>

          <!-- 分销商入口卡片 (侧边栏) -->
          <div class="filter-section dist-sidebar-card">
            <div class="dist-card-icon">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6c5ce7" stroke-width="2">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
              </svg>
            </div>
            <div class="dist-card-title">Earn Commission</div>
            <div class="dist-card-sub">Become a Distributor &amp; earn up to 15% commission on every sale</div>
            <a href="/distributor" class="dist-card-btn" @click.prevent>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
              Join Distributor Program
            </a>
          </div>

        </aside>

        <!-- ===== 主内容区 ===== -->
        <main class="search-main">

          <!-- 排序栏 + 结果统计 -->
          <div class="sort-bar">
            <div class="results-summary">
              <strong>{{ filteredProducts.length }}+</strong> results
              <span v-if="route.query.q"> for "<em>{{ route.query.q }}</em>"</span>
              <span v-if="route.query.cat"> in <em>{{ route.query.cat }}</em></span>
              <span> from global suppliers</span>
            </div>

            <div class="sort-controls">
              <!-- Products / Suppliers tabs -->
              <div class="tab-switcher">
                <button class="tab-btn" :class="{ active: activeTab === 'products' }" @click="activeTab = 'products'">Products</button>
                <button class="tab-btn" :class="{ active: activeTab === 'suppliers' }" @click="activeTab = 'suppliers'">Suppliers</button>
              </div>

              <!-- Sort dropdown -->
              <div class="sort-dropdown-wrap">
                <select v-model="sortBy" class="sort-select">
                  <option value="relevance">Sort by relevance</option>
                  <option value="sales">Sort by sales volume</option>
                  <option value="price-low">Price: Low to High</option>
                  <option value="price-high">Price: High to Low</option>
                  <option value="rating">Supplier rating</option>
                  <option value="newest">Newest</option>
                </select>
              </div>

              <!-- View toggle -->
              <div class="view-toggle">
                <button class="view-btn" :class="{ active: viewMode === 'grid' }" @click="viewMode = 'grid'" title="Grid view">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
                </button>
                <button class="view-btn" :class="{ active: viewMode === 'list' }" @click="viewMode = 'list'" title="List view">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                </button>
              </div>

              <!-- Active filters -->
              <div v-if="activeFilterCount > 0" class="active-filters">
                <span class="filter-count-badge">{{ activeFilterCount }} filters active</span>
                <button class="clear-filters-btn" @click="clearFilters">Clear all</button>
              </div>
            </div>
          </div>

          <!-- ===== Products Tab ===== -->
          <div v-if="activeTab === 'products'" class="products-content">

            <!-- B2B Banner (C→B引流) -->
            <div class="b2b-promo-banner">
              <div class="b2b-promo-left">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#c9a84c" stroke-width="2">
                  <path d="M2 20a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8l-7 5V8l-7 5V8l-7 5V8l-7 5V8l-7 5v12z"/>
                </svg>
                <div>
                  <div class="b2b-promo-title">B2B Wholesale — Business Buyers</div>
                  <div class="b2b-promo-sub">Lower wholesale prices, dedicated account manager, and bulk order benefits</div>
                </div>
              </div>
              <a href="/b2b" class="b2b-promo-btn">
                Switch to B2B
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
              </a>
            </div>

            <!-- 商品网格 (阿里风格卡片) -->
            <div class="product-grid" :class="{ 'list-view': viewMode === 'list' }">
              <div class="product-card" v-for="p in paginatedProducts" :key="p.id">

                <!-- 图片区 -->
                <div class="card-img-wrap">
                  <a href="#" @click.prevent>
                    <img :src="p.img" :alt="p.name" class="card-img" loading="lazy" />
                  </a>
                  <span v-if="p.ad" class="card-badge ad-badge">Ad</span>
                  <span v-if="p.verified" class="card-badge verified-badge">
                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.5"><path d="M20 6L9 17l-5-5"/></svg>
                    Verified
                  </span>
                  <span v-if="p.easyReturn" class="card-badge return-badge">Easy Return</span>
                  <button class="card-wish" @click.prevent="p.wishlisted = !p.wishlisted">
                    <svg width="14" height="14" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                        :fill="p.wishlisted ? '#e60023' : 'none'"/>
                    </svg>
                  </button>
                  <div v-if="p.sold > 0" class="card-sold">{{ p.sold }} sold</div>
                </div>

                <!-- 商品信息 -->
                <div class="card-body">
                  <a href="#" class="card-name" @click.prevent>{{ p.name }}</a>

                  <div class="card-price-row">
                    <span class="card-price">${{ p.priceMin }} — ${{ p.priceMax }}</span>
                  </div>

                  <div class="card-moq">Min. order: <strong>{{ p.moq }} pieces</strong></div>

                  <div v-if="p.off" class="card-off-tag">-{{ p.off }}%</div>

                  <div class="card-supplier">
                    <span class="supplier-name">{{ p.supplier }}</span>
                    <span class="supplier-meta">
                      <span class="supplier-yrs">{{ p.yrs }} yrs</span>
                      <span class="supplier-flag">{{ p.flag }}</span>
                      <span class="supplier-country">{{ p.country }}</span>
                    </span>
                  </div>

                  <div class="card-rating">
                    <span class="stars-comp">
                      <span class="stars-fill" :style="{ width: (p.rating / 5 * 100) + '%' }">★★★★★</span>
                      <span class="stars-empty">★★★★★</span>
                    </span>
                    <span class="rating-text">{{ p.rating }}/5.0 <span class="rating-count">({{ p.reviews }})</span></span>
                  </div>

                  <div class="card-meta-row">
                    <span v-if="p.delivery" class="delivery-tag">
                      <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
                      Delivery by {{ p.delivery }}
                    </span>
                    <span class="views-count">{{ p.views }} views</span>
                  </div>
                </div>

                <!-- 操作按钮 -->
                <div class="card-actions">
                  <button class="card-chat-btn">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                    Chat now
                  </button>
                  <button class="card-cart-btn" v-if="p.inStock">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
                    Add to cart
                  </button>
                  <button class="card-inquiry-btn">Inquire</button>
                </div>

                <!-- B端批发价引流按钮 (C→B引流) -->
                <a href="/b2b" class="b2b-price-btn" @click.prevent>
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#c9a84c" stroke-width="2">
                    <path d="M2 20a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8l-7 5V8l-7 5V8l-7 5V8l-7 5V8l-7 5v12z"/>
                  </svg>
                  <span class="b2b-price-text">B端批发价 <strong>${{ p.b2bPrice }}</strong> 起</span>
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#c9a84c" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                </a>

              </div>
            </div>

            <!-- 分页 -->
            <div class="pagination">
              <button class="page-btn page-prev" :disabled="currentPage === 1" @click="currentPage--">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 18l-6-6 6-6"/></svg>
              </button>
              <button v-for="p in totalPages" :key="p" class="page-btn" :class="{ active: p === currentPage }" @click="currentPage = p">{{ p }}</button>
              <button class="page-btn page-next" :disabled="currentPage >= totalPages" @click="currentPage++">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
              </button>
            </div>
          </div>

          <!-- ===== Suppliers Tab ===== -->
          <div v-if="activeTab === 'suppliers'" class="suppliers-content">
            <div class="supplier-card" v-for="s in suppliers" :key="s.name">
              <div class="supplier-card-img">
                <img :src="s.banner" :alt="s.name" />
              </div>
              <div class="supplier-card-body">
                <div class="supplier-logo-wrap">
                  <img :src="s.logo" :alt="s.name" class="supplier-logo" />
                  <span v-if="s.verified" class="supplier-verified-badge">
                    <svg width="10" height="10" viewBox="0 0 24 24" fill="#fff" stroke="none"><path d="M20 6L9 17l-5-5 1.41-1.41L9 14.17 18.59 4.59 20 6z"/></svg>
                  </span>
                </div>
                <div class="supplier-info">
                  <div class="supplier-card-name">{{ s.name }}</div>
                  <div class="supplier-card-meta">
                    <span>{{ s.yrs }} yrs</span>
                    <span class="sup-flag">{{ s.flag }}</span>
                    <span>{{ s.country }}</span>
                    <span>{{ s.category }}</span>
                  </div>
                  <div class="supplier-card-rating">
                    <span class="stars-comp">
                      <span class="stars-fill" :style="{ width: (s.rating / 5 * 100) + '%' }">★★★★★</span>
                      <span class="stars-empty">★★★★★</span>
                    </span>
                    <span>{{ s.rating }}/5.0 ({{ s.reviews }} reviews)</span>
                  </div>
                  <div class="supplier-card-stats">
                    <div class="stat-item">
                      <span class="stat-val">{{ s.products }}</span>
                      <span class="stat-label">Products</span>
                    </div>
                    <div class="stat-item">
                      <span class="stat-val">{{ s.response }}</span>
                      <span class="stat-label">Response</span>
                    </div>
                    <div class="stat-item">
                      <span class="stat-val">{{ s.orders }}</span>
                      <span class="stat-label">Orders</span>
                    </div>
                  </div>
                </div>
                <div class="supplier-card-actions">
                  <button class="sup-chat-btn">Chat now</button>
                  <button class="sup-contact-btn">Contact Supplier</button>
                </div>
              </div>
            </div>
          </div>

        </main>
      </div>
    </div>

    <SiteFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted, nextTick } from 'vue'
import { useRoute } from 'vue-router'
import { productsApi, cartApi } from '~/utils/api'

const route = useRoute()

// ===== 导航分类 =====
const navCategories = ref(['All', 'Women', 'Men', 'Kids', 'Beauty', 'Electronics', 'Home', 'Sports', 'Jewellery', 'Shoes', 'Bags'])
const selectedCat = ref(route.query.cat || 'All')
const selectCat = async (cat) => {
  selectedCat.value = cat
  currentPage.value = 1
  displayedProducts.value = []
  await loadMoreProducts()
}

// ===== 搜索 =====
const searchInput = ref(route.query.q || '')
const doSearch = () => {
  if (searchInput.value.trim()) {
    window.location.href = `/b2c/search?q=${encodeURIComponent(searchInput.value.trim())}`
  }
}

// ===== 滚动状态 =====
const isScrolled = ref(false)
const onScroll = () => { isScrolled.value = window.scrollY > 60 }
onMounted(() => window.addEventListener('scroll', onScroll))
onUnmounted(() => window.removeEventListener('scroll', onScroll))

// ===== 头部购物车 =====
const cartCount = ref(0)
const cartOpen = ref(false)

// ===== 左侧折叠面板 =====
const openSections = ref({
  price: true,
  rating: false,
  shipping: false,
  promo: false,
})
const toggleSection = (name) => {
  openSections.value[name] = !openSections.value[name]
}

// ===== 筛选条件 =====
const filters = ref({
  priceMin: null,
  priceMax: null,
  minRating: 0,
  freeShipping: false,
  fastShipping: false,
  hasDiscount: false,
  hasBargain: false,
  hasGroupBuy: false,
  hasFullReduction: false,
  dynamicFilters: {},
})
const applyFilters = async () => {
  currentPage.value = 1
  displayedProducts.value = []
  await loadMoreProducts()
}
const clearFilters = () => {
  filters.value = {
    priceMin: null, priceMax: null, minRating: 0,
    freeShipping: false, fastShipping: false,
    hasDiscount: false, hasBargain: false, hasGroupBuy: false, hasFullReduction: false,
    dynamicFilters: {},
  }
  applyFilters()
}
const activeFilterCount = computed(() => {
  let c = 0
  if (filters.value.priceMin || filters.value.priceMax) c++
  if (filters.value.minRating > 0) c++
  if (filters.value.freeShipping) c++
  if (filters.value.fastShipping) c++
  if (filters.value.hasDiscount) c++
  if (filters.value.hasBargain) c++
  if (filters.value.hasGroupBuy) c++
  if (filters.value.hasFullReduction) c++
  Object.values(filters.value.dynamicFilters).forEach((v: any) => { if (v && v.length > 0) c += v.length })
  return c
})

// ===== 动态分面 (从API获取) =====
const dynamicFacets = ref<any[]>([])

// ===== 排序 =====
const sortBy = ref('relevance')
const applySort = async () => {
  currentPage.value = 1
  displayedProducts.value = []
  await loadMoreProducts()
}

// ===== 视图模式 =====
const viewMode = ref('grid')

// ===== 悬停卡片ID =====
const hoveredId = ref<number | null>(null)

// ===== 询价弹窗 =====
const inquiryProduct = ref<any>(null)
const inquiryMsg = ref('')
const openInquiry = (p: any) => { inquiryProduct.value = p; inquiryMsg.value = '' }
const submitInquiry = () => {
  alert('Inquiry sent! (Demo — connect to inquiry API)')
  inquiryProduct.value = null
}

// ===== 收藏 =====
const toggleWish = (p: any) => { p.wishlisted = !p.wishlisted }

// ===== 购物车 =====
const addToCart = async (p: any) => {
  if (p.addedToCart) return
  const token = localStorage.getItem('token')
  if (!token) {
    alert('Please login first')
    return
  }
  try {
    await cartApi.addItem({ product_id: p.id, quantity: 1 }, token)
    p.addedToCart = true
    cartCount.value++
    setTimeout(() => { p.addedToCart = false }, 2000)
  } catch (e: any) {
    alert('Failed to add to cart: ' + e.message)
  }
}

// ===== 商品数据 =====
const displayedProducts = ref<any[]>([])
const totalCount = ref(0)

// ===== 懒加载分页 =====
const PAGE_SIZE = 20
const currentPage = ref(1)
const loading = ref(false)
const hasMore = ref(true)

// 加载更多商品
const loadMoreProducts = async () => {
  if (loading.value) return
  loading.value = true
  try {
    const catId = selectedCat.value !== 'All' ? selectedCat.value : undefined
    const result = await productsApi.search({
      q: route.query.q as string || undefined,
      category_id: catId as any,
      price_min: filters.value.priceMin || undefined,
      price_max: filters.value.priceMax || undefined,
      min_rating: filters.value.minRating || undefined,
      sort: sortBy.value,
      page: currentPage.value,
      page_size: PAGE_SIZE,
    })
    // 更新分面
    if (result.facets) {
      dynamicFacets.value = result.facets
    }
    // 追加或替换
    if (currentPage.value === 1) {
      displayedProducts.value = result.products.map((p: any) => ({ ...p, wishlisted: false, addedToCart: false }))
    } else {
      displayedProducts.value.push(...result.products.map((p: any) => ({ ...p, wishlisted: false, addedToCart: false })))
    }
    totalCount.value = result.total
    hasMore.value = displayedProducts.value.length < result.total
    currentPage.value++
  } catch (e: any) {
    console.error('Search failed:', e)
    // API not available yet — show empty state
    displayedProducts.value = []
    totalCount.value = 0
    hasMore.value = false
  } finally {
    loading.value = false
  }
}

// ===== 懒加载触发器 =====
const loadTrigger = ref<HTMLElement | null>(null)
let observer: IntersectionObserver | null = null

const setupObserver = () => {
  if (observer) observer.disconnect()
  observer = new IntersectionObserver((entries) => {
    if (entries[0].isIntersecting && !loading.value && hasMore.value) {
      loadMoreProducts()
    }
  }, { rootMargin: '200px' })
  if (loadTrigger.value) observer.observe(loadTrigger.value)
}

onMounted(async () => {
  await loadMoreProducts()
  await nextTick()
  setupObserver()
})

watch(loadTrigger, () => {
  if (loadTrigger.value) setupObserver()
})

// watch filter / sort changes
watch([filters, sortBy, selectedCat], () => {
  currentPage.value = 1
}, { deep: true })
</script>

<style scoped>
* { box-sizing: border-box; }

.b2c-search {
  min-height: 100vh;
  background: #f4f4f4;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  color: #222;
}

/* ========== 主体布局 ========== */
.search-body { background: #f4f4f4; min-height: calc(100vh - 120px); }

/* 面包屑 */
.breadcrumb-bar { background: #fff; border-bottom: 1px solid #eee; }
.breadcrumb-inner { max-width: 1446px; margin: 0 auto; padding: 8px 16px; display: flex; align-items: center; gap: 6px; font-size: 12px; }
.breadcrumb-item { color: #999; }
.breadcrumb-item.active { color: #111; font-weight: 600; }
.breadcrumb-sep { color: #ddd; }

.search-layout { max-width: 1446px; margin: 0 auto; padding: 16px; display: grid; grid-template-columns: 260px 1fr; gap: 16px; align-items: start; }

/* ========== 左侧筛选栏 ========== */
.filter-sidebar { background: #fff; border: 1px solid #eee; border-radius: 6px; overflow: hidden; position: sticky; top: 82px; max-height: calc(100vh - 100px); overflow-y: auto; scrollbar-width: thin; }

.filter-section { padding: 14px 16px; border-bottom: 1px solid #f0f0f0; }
.filter-section:last-child { border-bottom: none; }
.filter-title { display: flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 700; color: #111; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 10px; }

.category-list { display: flex; flex-direction: column; gap: 2px; }
.cat-filter-item { display: flex; align-items: center; padding: 5px 8px; border-radius: 4px; cursor: pointer; transition: background 0.15s; }
.cat-filter-item:hover { background: #f5f5f5; }
.cat-radio { margin-right: 8px; accent-color: #111; }
.cat-label { flex: 1; font-size: 12px; color: #444; }
.cat-count { font-size: 11px; color: #aaa; }

.toggle-filter { display: flex; align-items: center; gap: 8px; padding: 4px 0; cursor: pointer; }
.toggle-filter input { accent-color: #111; }
.toggle-label { font-size: 12px; color: #555; }

.delivery-btns { display: flex; flex-wrap: wrap; gap: 6px; }
.delivery-btn { padding: 4px 10px; font-size: 11px; border: 1px solid #ddd; border-radius: 3px; background: #fff; cursor: pointer; color: #555; transition: all 0.15s; }
.delivery-btn:hover { border-color: #111; color: #111; }
.delivery-btn.active { background: #111; color: #fff; border-color: #111; }

.rating-filters { display: flex; flex-direction: column; gap: 4px; }
.rating-btn { display: flex; align-items: center; gap: 4px; padding: 5px 8px; border: 1px solid #eee; border-radius: 4px; background: #fff; cursor: pointer; font-size: 12px; transition: all 0.15s; }
.rating-btn:hover { border-color: #c9a84c; }
.rating-btn.active { background: #fffef5; border-color: #c9a84c; }
.stars { color: #c9a84c; letter-spacing: -1px; }
.rating-label { color: #888; font-size: 11px; }

.price-inputs { display: flex; align-items: center; gap: 8px; }
.price-input { width: 80px; padding: 6px 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 12px; outline: none; }
.price-input:focus { border-color: #111; }
.price-sep { color: #aaa; font-size: 12px; }
.price-ok-btn { margin-top: 6px; padding: 5px 16px; background: #111; color: #fff; border: none; border-radius: 4px; font-size: 12px; font-weight: 600; cursor: pointer; }
.price-ok-btn:hover { background: #333; }

.country-list { display: flex; flex-direction: column; gap: 4px; }
.country-item { display: flex; align-items: center; gap: 6px; padding: 4px 6px; border-radius: 4px; cursor: pointer; font-size: 12px; }
.country-item:hover { background: #f5f5f5; }
.country-item input { accent-color: #111; }
.country-flag { font-size: 14px; }
.country-name { flex: 1; color: #555; }

.cert-list { display: flex; flex-wrap: wrap; gap: 6px; }
.cert-item { display: flex; align-items: center; gap: 4px; font-size: 11px; color: #666; cursor: pointer; }
.cert-item input { accent-color: #111; }

/* 分销商侧边栏卡片 */
.dist-sidebar-card { background: linear-gradient(135deg, #f5f3ff, #ede9fe); border-radius: 0; border: none; padding: 18px 16px; }
.dist-card-icon { width: 40px; height: 40px; background: #fff; border-radius: 10px; display: flex; align-items: center; justify-content: center; margin-bottom: 10px; box-shadow: 0 2px 8px rgba(108,92,231,0.15); }
.dist-card-title { font-size: 14px; font-weight: 800; color: #6c5ce7; margin-bottom: 6px; }
.dist-card-sub { font-size: 11px; color: #888; line-height: 1.5; margin-bottom: 12px; }
.dist-card-btn { display: flex; align-items: center; gap: 6px; padding: 8px 14px; background: #6c5ce7; color: #fff; border-radius: 6px; font-size: 12px; font-weight: 700; text-decoration: none; justify-content: center; transition: background 0.2s; }
.dist-card-btn:hover { background: #5b4cdb; }

/* ========== 主内容区 ========== */
.search-main { min-width: 0; }

/* 排序栏 */
.sort-bar { background: #fff; border: 1px solid #eee; border-radius: 6px; padding: 12px 16px; display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; margin-bottom: 16px; }
.results-summary { font-size: 13px; color: #555; flex-shrink: 0; }
.results-summary strong { color: #111; font-weight: 800; }
.results-summary em { color: #111; font-style: normal; font-weight: 600; }

.sort-controls { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }

.tab-switcher { display: flex; border: 1px solid #eee; border-radius: 4px; overflow: hidden; }
.tab-btn { padding: 6px 14px; font-size: 12px; font-weight: 600; background: #fff; border: none; cursor: pointer; color: #777; transition: all 0.15s; }
.tab-btn.active { background: #111; color: #fff; }

.sort-select { padding: 7px 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 12px; background: #fff; cursor: pointer; outline: none; color: #333; }
.sort-select:focus { border-color: #111; }

.view-toggle { display: flex; border: 1px solid #eee; border-radius: 4px; overflow: hidden; }
.view-btn { padding: 7px 10px; background: #fff; border: none; cursor: pointer; color: #aaa; transition: all 0.15s; }
.view-btn:hover { color: #111; }
.view-btn.active { background: #f0f0f0; color: #111; }

.active-filters { display: flex; align-items: center; gap: 8px; }
.filter-count-badge { background: #111; color: #fff; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
.clear-filters-btn { background: none; border: none; font-size: 11px; color: #e60023; cursor: pointer; text-decoration: underline; }

/* B2B Promo Banner */
.b2b-promo-banner { background: linear-gradient(135deg, #fffef5, #f9f7f0); border: 1.5px solid #e8d89a; border-radius: 8px; padding: 14px 18px; display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-bottom: 16px; }
.b2b-promo-left { display: flex; align-items: center; gap: 12px; }
.b2b-promo-title { font-size: 14px; font-weight: 800; color: #111; margin-bottom: 2px; }
.b2b-promo-sub { font-size: 12px; color: #777; }
.b2b-promo-btn { display: flex; align-items: center; gap: 6px; padding: 9px 18px; background: #c9a84c; color: #fff; border-radius: 6px; font-size: 12px; font-weight: 700; text-decoration: none; white-space: nowrap; transition: background 0.2s; flex-shrink: 0; }
.b2b-promo-btn:hover { background: #b8973b; }

/* 商品网格 */
.product-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; }
.product-card { background: #fff; border: 1px solid #eee; border-radius: 6px; overflow: hidden; display: flex; flex-direction: column; transition: box-shadow 0.2s; }
.product-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }

/* 图片区 */
.card-img-wrap { position: relative; aspect-ratio: 1; overflow: hidden; background: #f9f9f9; }
.card-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
.product-card:hover .card-img { transform: scale(1.03); }
.card-badge { position: absolute; top: 8px; left: 8px; padding: 2px 7px; border-radius: 3px; font-size: 10px; font-weight: 800; }
.ad-badge { background: #ff9800; color: #fff; }
.verified-badge { background: #2a2a6a; color: #fff; display: flex; align-items: center; gap: 3px; }
.return-badge { top: auto; bottom: 8px; left: 8px; background: #e8f5e9; color: #2e7d32; font-size: 10px; font-weight: 600; }
.card-wish { position: absolute; top: 8px; right: 8px; background: rgba(255,255,255,0.9); border: none; border-radius: 50%; width: 28px; height: 28px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: background 0.2s; }
.card-wish:hover { background: #fff; }
.card-sold { position: absolute; bottom: 8px; right: 8px; background: rgba(0,0,0,0.6); color: #fff; padding: 2px 7px; border-radius: 3px; font-size: 10px; font-weight: 600; }

/* 商品信息 */
.card-body { padding: 10px 12px 0; }
.card-name { font-size: 12px; color: #222; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; text-decoration: none; }
.card-name:hover { color: #111; text-decoration: underline; }

.card-price-row { display: flex; align-items: baseline; gap: 6px; margin-top: 6px; }
.card-price { font-size: 15px; font-weight: 800; color: #111; }
.card-off-tag { display: inline-block; background: #e60023; color: #fff; font-size: 10px; font-weight: 700; padding: 1px 5px; border-radius: 3px; margin-top: 4px; }

.card-moq { font-size: 11px; color: #888; margin-top: 4px; }
.card-moq strong { color: #555; }

.card-supplier { margin-top: 6px; display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.supplier-name { font-size: 11px; color: #1a6aff; font-weight: 600; max-width: 120px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.supplier-meta { display: flex; align-items: center; gap: 4px; }
.supplier-yrs { font-size: 10px; color: #888; }
.supplier-flag { font-size: 12px; }
.supplier-country { font-size: 10px; color: #888; }

.card-rating { display: flex; align-items: center; gap: 5px; margin-top: 5px; }
.stars-comp { position: relative; display: inline-block; font-size: 11px; letter-spacing: -1px; line-height: 1; }
.stars-fill { position: absolute; top: 0; left: 0; color: #c9a84c; overflow: hidden; white-space: nowrap; }
.stars-empty { color: #ddd; }
.rating-text { font-size: 11px; color: #666; }
.rating-count { color: #aaa; }

.card-meta-row { display: flex; align-items: center; justify-content: space-between; margin-top: 6px; }
.delivery-tag { display: flex; align-items: center; gap: 3px; font-size: 10px; color: #888; }
.views-count { font-size: 10px; color: #aaa; }

/* 操作按钮 */
.card-actions { display: flex; gap: 6px; padding: 8px 12px; border-top: 1px solid #f0f0f0; margin-top: 8px; }
.card-chat-btn { flex: 1; display: flex; align-items: center; justify-content: center; gap: 5px; padding: 6px 8px; background: #fff; border: 1px solid #111; border-radius: 4px; font-size: 11px; font-weight: 700; color: #111; cursor: pointer; transition: background 0.15s; }
.card-chat-btn:hover { background: #f5f5f5; }
.card-cart-btn { flex: 1; display: flex; align-items: center; justify-content: center; gap: 5px; padding: 6px 8px; background: #111; border: 1px solid #111; border-radius: 4px; font-size: 11px; font-weight: 700; color: #fff; cursor: pointer; transition: background 0.15s; }
.card-cart-btn:hover { background: #333; }
.card-inquiry-btn { padding: 6px 10px; background: #fff; border: 1px solid #ddd; border-radius: 4px; font-size: 11px; font-weight: 600; color: #666; cursor: pointer; transition: all 0.15s; }
.card-inquiry-btn:hover { border-color: #111; color: #111; }

/* B2B 批发价按钮 */
.b2b-price-btn { display: flex; align-items: center; justify-content: center; gap: 6px; padding: 7px 12px; background: linear-gradient(135deg, #fffef5, #f9f7f0); border-top: 1px solid #f0e8c8; font-size: 12px; font-weight: 700; color: #111; text-decoration: none; transition: all 0.2s; }
.b2b-price-btn:hover { background: linear-gradient(135deg, #fffbf0, #f5edd5); }
.b2b-price-text { color: #555; }
.b2b-price-text strong { color: #c9a84c; font-size: 13px; }

/* ========== 分页 ========== */
.pagination { display: flex; align-items: center; justify-content: center; gap: 4px; margin-top: 24px; padding: 16px 0; }
.page-btn { min-width: 36px; height: 36px; padding: 0 10px; border: 1px solid #eee; border-radius: 4px; background: #fff; font-size: 13px; color: #555; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
.page-btn:hover:not(:disabled) { border-color: #111; color: #111; }
.page-btn.active { background: #111; color: #fff; border-color: #111; }
.page-btn:disabled { opacity: 0.4; cursor: not-allowed; }

/* ========== Suppliers ========== */
.suppliers-content { display: flex; flex-direction: column; gap: 16px; }
.supplier-card { background: #fff; border: 1px solid #eee; border-radius: 8px; overflow: hidden; }
.supplier-card-img { height: 100px; overflow: hidden; }
.supplier-card-img img { width: 100%; height: 100%; object-fit: cover; }
.supplier-card-body { padding: 16px; display: flex; gap: 16px; align-items: flex-start; }
.supplier-logo-wrap { position: relative; flex-shrink: 0; }
.supplier-logo { width: 60px; height: 60px; border-radius: 8px; object-fit: cover; border: 1px solid #eee; }
.supplier-verified-badge { position: absolute; bottom: -3px; right: -3px; background: #2a2a6a; border-radius: 50%; width: 18px; height: 18px; display: flex; align-items: center; justify-content: center; }
.supplier-info { flex: 1; min-width: 0; }
.supplier-card-name { font-size: 14px; font-weight: 700; color: #111; margin-bottom: 4px; }
.supplier-card-meta { display: flex; align-items: center; gap: 6px; font-size: 11px; color: #888; margin-bottom: 6px; }
.sup-flag { font-size: 13px; }
.supplier-card-rating { display: flex; align-items: center; gap: 5px; font-size: 11px; color: #666; margin-bottom: 8px; }
.supplier-card-stats { display: flex; gap: 20px; }
.stat-item { display: flex; flex-direction: column; }
.stat-val { font-size: 14px; font-weight: 800; color: #111; }
.stat-label { font-size: 10px; color: #aaa; text-transform: uppercase; }
.supplier-card-actions { display: flex; flex-direction: column; gap: 6px; flex-shrink: 0; }
.sup-chat-btn { padding: 7px 16px; background: #111; color: #fff; border: none; border-radius: 4px; font-size: 12px; font-weight: 700; cursor: pointer; }
.sup-contact-btn { padding: 7px 16px; background: #fff; color: #111; border: 1px solid #ddd; border-radius: 4px; font-size: 12px; font-weight: 600; cursor: pointer; }

/* ========== 响应式 ========== */
@media (max-width: 1200px) {
  .product-grid { grid-template-columns: repeat(3, 1fr); }
}
@media (max-width: 900px) {
  .search-layout { grid-template-columns: 1fr; }
  .filter-sidebar { position: static; max-height: none; }
  .product-grid { grid-template-columns: repeat(2, 1fr); }
  .b2b-promo-banner { flex-direction: column; align-items: flex-start; }
}
@media (max-width: 600px) {
  .sort-bar { flex-direction: column; align-items: flex-start; }
  .sort-controls { width: 100%; }
  .product-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
  .card-price { font-size: 13px; }
  .card-actions { flex-wrap: wrap; }
  .card-inquiry-btn { display: none; }
}
</style>
