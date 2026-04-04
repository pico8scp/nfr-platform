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

<script setup>
import { ref, computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

// ===== 侧边栏分类 =====
const sideCategories = [
  { name: 'All Categories', count: '12,500+' },
  { name: "Women's Fashion", count: '3,200+' },
  { name: "Men's Fashion", count: '2,100+' },
  { name: 'Kids & Baby', count: '1,500+' },
  { name: 'Beauty & Personal Care', count: '1,800+' },
  { name: 'Electronics', count: '2,400+' },
  { name: 'Home & Garden', count: '1,900+' },
  { name: 'Sports & Outdoors', count: '1,200+' },
  { name: 'Jewelry & Accessories', count: '900+' },
]
const selectedCategory = ref('All Categories')

// ===== 筛选数据 =====
const supplierTypes = ['Manufacturer', 'Trading Company', 'Wholesaler']
const deliveryDates = [
  { label: '7 days', days: 7 },
  { label: '15 days', days: 15 },
  { label: '30 days', days: 30 },
]
const countries = [
  { code: 'CN', name: 'China', flag: '🇨🇳', count: '8.5k' },
  { code: 'TR', name: 'Turkey', flag: '🇹🇷', count: '1.2k' },
  { code: 'IN', name: 'India', flag: '🇮🇳', count: '900' },
  { code: 'VN', name: 'Vietnam', flag: '🇻🇳', count: '650' },
  { code: 'US', name: 'USA', flag: '🇺🇸', count: '400' },
]
const certifications = ['CE', 'FCC', 'RoHS', 'ISO9001', 'REACH']

const filters = ref({
  tradeAssurance: false,
  supplierTypes: [],
  delivery: '',
  minRating: 0,
  priceMin: null,
  priceMax: null,
  moq: null,
  countries: [],
  certs: [],
})

const applyPriceFilter = () => { /* noop - reactive via v-model */ }
const clearFilters = () => {
  filters.value = { tradeAssurance: false, supplierTypes: [], delivery: '', minRating: 0, priceMin: null, priceMax: null, moq: null, countries: [], certs: [] }
  selectedCategory.value = 'All Categories'
}
const activeFilterCount = computed(() => {
  let c = 0
  if (filters.value.tradeAssurance) c++
  c += filters.value.supplierTypes.length
  if (filters.value.delivery) c++
  if (filters.value.minRating > 0) c++
  if (filters.value.priceMin || filters.value.priceMax) c++
  if (filters.value.moq) c++
  c += filters.value.countries.length
  c += filters.value.certs.length
  return c
})

// ===== Tab / Sort / View =====
const activeTab = ref('products')
const sortBy = ref('relevance')
const viewMode = ref('grid')
const currentPage = ref(1)
const perPage = 24

// ===== 商品数据 (阿里风格) =====
const products = [
  { id: 1, name: 'Women Boho Floral Maxi Dress — Summer Beach Casual', img: 'https://picsum.photos/seed/ali-p1/400/400', priceMin: '4.50', priceMax: '5.80', moq: 20, off: 35, ad: true, verified: true, easyReturn: true, supplier: 'Guangzhou Yimei Trading Co.', yrs: 8, flag: '🇨🇳', country: 'CN', rating: 4.8, reviews: 234, sold: 1250, views: 3250, delivery: 'May 04', inStock: true, b2bPrice: '3.20', wishlisted: false },
  { id: 2, name: "Men's Athletic Joggers — Quick-Dry Sports Running Pants", img: 'https://picsum.photos/seed/ali-p2/400/400', priceMin: '6.20', priceMax: '7.50', moq: 50, off: 28, verified: true, supplier: 'Fujian Anta Sports Co.', yrs: 12, flag: '🇨🇳', country: 'CN', rating: 4.6, reviews: 189, sold: 890, views: 2100, delivery: 'Apr 28', inStock: true, b2bPrice: '4.10', wishlisted: false },
  { id: 3, name: 'Kids Unisex Pajama Set — Soft Cotton Sleepwear 2pc', img: 'https://picsum.photos/seed/ali-p3/400/400', priceMin: '3.80', priceMax: '4.50', moq: 100, off: 42, ad: false, verified: true, easyReturn: true, supplier: 'Hangzhou Kiddo Garment', yrs: 6, flag: '🇨🇳', country: 'CN', rating: 4.9, reviews: 456, sold: 2100, views: 5600, delivery: 'May 04', inStock: true, b2bPrice: '2.50', wishlisted: false },
  { id: 4, name: 'TWS Bluetooth Earbuds — Active Noise Cancelling 5.3', img: 'https://picsum.photos/seed/ali-p4/400/400', priceMin: '8.90', priceMax: '12.00', moq: 10, off: 52, ad: true, verified: true, supplier: 'Shenzhen Tech Electronics', yrs: 11, flag: '🇨🇳', country: 'CN', rating: 4.7, reviews: 892, sold: 5600, views: 14200, delivery: 'Apr 22', inStock: true, b2bPrice: '5.80', wishlisted: false },
  { id: 5, name: 'Women Platform Sneakers — Comfort Walking Shoes Casual', img: 'https://picsum.photos/seed/ali-p5/400/400', priceMin: '7.50', priceMax: '9.20', moq: 30, off: 49, verified: false, supplier: 'Wenzhou Fashion Co.', yrs: 5, flag: '🇨🇳', country: 'CN', rating: 4.3, reviews: 67, sold: 340, views: 890, delivery: 'May 04', inStock: true, b2bPrice: '5.20', wishlisted: false },
  { id: 6, name: 'Gold Plated Jewelry Set — Necklace + Earrings + Bracelet', img: 'https://picsum.photos/seed/ali-p6/400/400', priceMin: '2.10', priceMax: '3.40', moq: 50, off: 55, ad: false, verified: true, easyReturn: true, supplier: 'Yiwu Jiali Accessories', yrs: 9, flag: '🇨🇳', country: 'CN', rating: 4.5, reviews: 321, sold: 4800, views: 9800, delivery: 'Apr 28', inStock: true, b2bPrice: '1.40', wishlisted: false },
  { id: 7, name: 'Home Decor LED String Lights — Warm White 10m Waterproof', img: 'https://picsum.photos/seed/ali-p7/400/400', priceMin: '1.80', priceMax: '2.50', moq: 200, off: 38, ad: false, verified: true, supplier: 'Ningbo Homelink Lighting', yrs: 7, flag: '🇨🇳', country: 'CN', rating: 4.4, reviews: 178, sold: 8900, views: 22000, delivery: 'May 04', inStock: true, b2bPrice: '1.10', wishlisted: false },
  { id: 8, name: 'Sports Yoga Mat — Non-Slip Exercise Mat 6mm Thick', img: 'https://picsum.photos/seed/ali-p8/400/400', priceMin: '3.20', priceMax: '4.80', moq: 50, off: 44, ad: false, verified: true, easyReturn: true, supplier: 'Fujian Anta Sports Co.', yrs: 12, flag: '🇨🇳', country: 'CN', rating: 4.7, reviews: 543, sold: 3200, views: 7800, delivery: 'Apr 28', inStock: true, b2bPrice: '2.00', wishlisted: false },
  { id: 9, name: 'Wireless Charging Pad — Fast Charge 15W Qi Compatible', img: 'https://picsum.photos/seed/ali-p9/400/400', priceMin: '5.50', priceMax: '7.20', moq: 20, off: 33, ad: true, verified: true, supplier: 'Shenzhen Tech Electronics', yrs: 11, flag: '🇨🇳', country: 'CN', rating: 4.6, reviews: 290, sold: 1800, views: 4500, delivery: 'Apr 22', inStock: true, b2bPrice: '3.50', wishlisted: false },
  { id: 10, name: 'Organic Cotton Baby Onesies — 5 Pack Newborn Romper', img: 'https://picsum.photos/seed/ali-p10/400/400', priceMin: '4.20', priceMax: '5.60', moq: 100, off: 29, ad: false, verified: true, easyReturn: true, supplier: "Hangzhou Kiddo Garment", yrs: 6, flag: '🇨🇳', country: 'CN', rating: 4.8, reviews: 612, sold: 4500, views: 11200, delivery: 'May 04', inStock: true, b2bPrice: '2.80', wishlisted: false },
  { id: 11, name: 'Silk Hair Scrunchies — 12 Pack Mulberry Silk Scrunchie Set', img: 'https://picsum.photos/seed/ali-p11/400/400', priceMin: '2.80', priceMax: '3.90', moq: 50, off: 41, ad: false, verified: false, supplier: 'Istanbul Moda Tekstil', yrs: 7, flag: '🇹🇷', country: 'TR', rating: 4.4, reviews: 98, sold: 670, views: 1800, delivery: 'Apr 28', inStock: true, b2bPrice: '1.80', wishlisted: false },
  { id: 12, name: 'Portable Blender USB Rechargeable — 380ml Travel Blender', img: 'https://picsum.photos/seed/ali-p12/400/400', priceMin: '6.80', priceMax: '9.50', moq: 30, off: 47, ad: false, verified: true, easyReturn: true, supplier: 'Shenzhen Tech Electronics', yrs: 11, flag: '🇨🇳', country: 'CN', rating: 4.5, reviews: 445, sold: 2100, views: 6200, delivery: 'Apr 22', inStock: true, b2bPrice: '4.20', wishlisted: false },
]

// ===== 供应商数据 =====
const suppliers = [
  { name: 'Guangzhou Yimei Trading Co., Ltd.', logo: 'https://picsum.photos/seed/supp1/80/80', banner: 'https://picsum.photos/seed/supp1b/400/120', verified: true, yrs: 8, flag: '🇨🇳', country: 'China', category: "Women's Fashion", rating: 4.8, reviews: 234, products: 156, response: '<24h', orders: '1.2k' },
  { name: 'Shenzhen Tech Electronics Co.', logo: 'https://picsum.photos/seed/supp2/80/80', banner: 'https://picsum.photos/seed/supp2b/400/120', verified: true, yrs: 11, flag: '🇨🇳', country: 'China', category: 'Consumer Electronics', rating: 4.7, reviews: 892, products: 89, response: '<12h', orders: '5.6k' },
  { name: 'Fujian Anta Sports Co., Ltd.', logo: 'https://picsum.photos/seed/supp3/80/80', banner: 'https://picsum.photos/seed/supp3b/400/120', verified: true, yrs: 12, flag: '🇨🇳', country: 'China', category: 'Sports & Outdoors', rating: 4.6, reviews: 189, products: 234, response: '<8h', orders: '890' },
  { name: 'Istanbul Moda Tekstil', logo: 'https://picsum.photos/seed/supp4/80/80', banner: 'https://picsum.photos/seed/supp4b/400/120', verified: false, yrs: 7, flag: '🇹🇷', country: 'Turkey', category: "Women's Fashion", rating: 4.4, reviews: 67, products: 78, response: '<48h', orders: '450' },
]

// ===== 过滤 & 排序 & 分页 =====
const filteredProducts = computed(() => {
  let list = [...products]
  if (route.query.q) {
    const q = route.query.q.toLowerCase()
    list = list.filter(p => p.name.toLowerCase().includes(q) || p.supplier.toLowerCase().includes(q))
  }
  if (sortBy.value === 'sales') list.sort((a, b) => b.sold - a.sold)
  else if (sortBy.value === 'price-low') list.sort((a, b) => parseFloat(a.priceMin) - parseFloat(b.priceMin))
  else if (sortBy.value === 'price-high') list.sort((a, b) => parseFloat(b.priceMax) - parseFloat(a.priceMax))
  else if (sortBy.value === 'rating') list.sort((a, b) => b.rating - a.rating)
  return list
})

const totalPages = computed(() => Math.ceil(filteredProducts.value.length / perPage))
const paginatedProducts = computed(() => {
  const start = (currentPage.value - 1) * perPage
  return filteredProducts.value.slice(start, start + perPage)
})

// reset page when filter changes
watch([() => route.query, sortBy, selectedCategory], () => { currentPage.value = 1 })
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
