<template>
  <div class="b2c-category">
    <SiteHeader />

    <!-- 分类导航条 -->
    <div class="top-policy">
      <div class="policy-inner">
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12l5 5L20 7"/></svg>
          Free Shipping <em>*On orders $49+</em>
        </span>
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          Free Returns
        </span>
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
          Secure Payment
        </span>
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 3"/></svg>
          No Hidden Fees
        </span>
      </div>
    </div>

    <header class="search-header" :class="{ scrolled: isScrolled }">
      <div class="search-header-inner">
        <a href="/" class="search-logo">NFR</a>
        <a href="/b2b" class="b2b-btn-header">
          <span class="b2b-btn-icon">🏭</span>
          <span class="b2b-btn-text">B2B Wholesale</span>
          <span class="b2b-btn-tag">-15%</span>
        </a>
        <div class="search-bar-wrap">
          <div class="search-bar-inner">
            <input v-model="searchInput" class="search-input" placeholder="Search in this category..." @keyup.enter="doSearch" />
            <button class="search-btn" @click="doSearch">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
            </button>
          </div>
        </div>
        <div class="header-actions">
          <button class="header-icon-btn">
            <svg width="18" height="18" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" fill="none"/></svg>
          </button>
          <button class="header-icon-btn cart-btn">
            <svg width="18" height="18" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            <span class="cart-count" v-if="cartCount > 0">{{ cartCount }}</span>
          </button>
        </div>
      </div>
    </header>

    <!-- 分类页面主体 -->
    <div class="category-body">
      <!-- 面包屑 -->
      <div class="breadcrumb-bar">
        <div class="breadcrumb-inner">
          <a href="/" class="breadcrumb-item">Home</a>
          <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
          <span class="breadcrumb-item active">{{ categoryName || 'All Products' }}</span>
        </div>
      </div>

      <div class="search-layout">
        <!-- 左侧筛选 -->
        <aside class="filter-sidebar">
          <div class="filter-section">
            <div class="filter-section-title" @click="toggleSection('price')">
              <span>Price</span>
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" :class="{ rotated: openSections.price }"><path d="M6 9l6 6 6-6"/></svg>
            </div>
            <div class="filter-section-body" v-show="openSections.price">
              <div class="price-inputs">
                <input v-model="filters.priceMin" type="number" placeholder="Min" class="price-input" />
                <span class="price-sep">—</span>
                <input v-model="filters.priceMax" type="number" placeholder="Max" class="price-input" />
              </div>
              <button class="price-ok-btn" @click="applyFilters">Apply</button>
            </div>
          </div>

          <div class="filter-section">
            <div class="filter-section-title" @click="toggleSection('rating')">
              <span>Rating</span>
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" :class="{ rotated: openSections.rating }"><path d="M6 9l6 6 6-6"/></svg>
            </div>
            <div class="filter-section-body" v-show="openSections.rating">
              <div class="rating-filters">
                <button v-for="r in [4, 4.5, 5]" :key="r" class="rating-btn" :class="{ active: filters.minRating === r }" @click="filters.minRating = filters.minRating === r ? 0 : r; applyFilters()">
                  <span class="stars-disp">★★★★★</span>
                  <span class="rating-label">&amp; up ({{ r }}+)</span>
                </button>
              </div>
            </div>
          </div>

          <div class="filter-section">
            <div class="filter-section-title" @click="toggleSection('promo')">
              <span>Promotions</span>
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" :class="{ rotated: openSections.promo }"><path d="M6 9l6 6 6-6"/></svg>
            </div>
            <div class="filter-section-body" v-show="openSections.promo">
              <label class="toggle-filter"><input type="checkbox" v-model="filters.hasDiscount" @change="applyFilters" /><span class="toggle-label">On Sale</span></label>
              <label class="toggle-filter"><input type="checkbox" v-model="filters.hasBargain" @change="applyFilters" /><span class="toggle-label">Bargain Price</span></label>
              <label class="toggle-filter"><input type="checkbox" v-model="filters.hasFullReduction" @change="applyFilters" /><span class="toggle-label">Full Reduction</span></label>
            </div>
          </div>

          <div v-for="facet in dynamicFacets" :key="facet.name" class="filter-section">
            <div class="filter-section-title" @click="toggleSection(facet.name)">
              <span>{{ facet.name }}</span>
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" :class="{ rotated: openSections[facet.name] }"><path d="M6 9l6 6 6-6"/></svg>
            </div>
            <div class="filter-section-body" v-show="openSections[facet.name]">
              <div class="facet-values">
                <label v-for="v in facet.values" :key="v.value" class="facet-item">
                  <input type="checkbox" v-model="filters.dynamicFilters[facet.name]" :value="v.value" @change="applyFilters" />
                  <span class="facet-label">{{ v.value }}</span>
                  <span class="facet-count">{{ v.count }}</span>
                </label>
              </div>
            </div>
          </div>
        </aside>

        <!-- 主内容 -->
        <main class="search-main">
          <div class="sort-bar">
            <div class="results-summary">
              <strong>{{ totalCount }}</strong> products in <em>{{ categoryName }}</em>
            </div>
            <div class="sort-controls">
              <select v-model="sortBy" class="sort-select" @change="applySort">
                <option value="relevance">Relevance</option>
                <option value="sales">Top Selling</option>
                <option value="newest">New Arrivals</option>
                <option value="price-low">Price: Low to High</option>
                <option value="price-high">Price: High to Low</option>
                <option value="rating">Top Rated</option>
              </select>
              <div class="view-toggle">
                <button class="view-btn" :class="{ active: viewMode === 'grid' }" @click="viewMode = 'grid'">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
                </button>
                <button class="view-btn" :class="{ active: viewMode === 'list' }" @click="viewMode = 'list'">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                </button>
              </div>
              <div v-if="activeFilterCount > 0" class="active-filters">
                <span class="filter-count-badge">{{ activeFilterCount }}</span>
                <button class="clear-filters-btn" @click="clearFilters">Clear all</button>
              </div>
            </div>
          </div>

          <!-- 商品网格 -->
          <div class="product-grid" :class="{ 'list-view': viewMode === 'list' }">
            <div class="product-card" v-for="p in displayedProducts" :key="p.id" @mouseenter="hoveredId = p.id" @mouseleave="hoveredId = null">
              <div class="card-img-wrap">
                <a :href="`/b2c/product/${p.id}`" class="card-img-link">
                  <img :src="p.img || 'https://via.placeholder.com/400x480'" :alt="p.name" class="card-img" loading="lazy" />
                </a>
                <div class="card-tags">
                  <span v-for="tag in p.tags.slice(0, 3)" :key="tag.type" class="card-tag" :class="tag.type">
                    <span v-if="tag.type === 'hot'" class="tag-icon">🔥</span>
                    <span v-if="tag.type === 'new'" class="tag-icon">✨</span>
                    {{ tag.label }}
                  </span>
                </div>
                <a v-if="p.hasBargain" href="#" class="bargain-stamp-btn" :class="{ visible: hoveredId === p.id }" @click.prevent>
                  <span class="stamp-text">砍价!</span>
                  <span class="stamp-sub">Invite Friends</span>
                </a>
                <span v-if="p.discount > 0" class="discount-corner">-{{ p.discount }}%</span>
                <button class="card-wish" @click.prevent="toggleWish(p)">
                  <svg width="14" height="14" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                      :fill="p.wishlisted ? '#ff3e5a' : 'none'"/>
                  </svg>
                </button>
              </div>
              <div class="card-body">
                <a :href="`/b2c/product/${p.id}`" class="card-name">{{ p.name }}</a>
                <div class="card-price-row">
                  <span class="card-price">${{ p.price }}</span>
                  <span v-if="p.originalPrice" class="card-original-price">${{ p.originalPrice }}</span>
                  <span v-if="p.hasBargain" class="bargain-label">As low as {{ p.bargainMinDiscount }}折</span>
                  <span v-if="p.hasFullReduction" class="fullreduction-label">满{{ p.fullReductionThreshold }}减{{ p.fullReductionAmount }}</span>
                </div>
                <div class="card-meta-row">
                  <span class="stars-comp">
                    <span class="stars-fill" :style="{ width: (p.rating / 5 * 100) + '%' }">★★★★★</span>
                    <span class="stars-empty">★★★★★</span>
                  </span>
                  <span class="rating-txt">{{ p.rating }}</span>
                  <span class="sold-count">🔥 {{ p.sold.toLocaleString() }}</span>
                </div>
              </div>
              <div class="card-actions">
                <button class="card-inquiry-btn">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                  Ask Price
                </button>
                <button class="card-cart-btn" @click="addToCart(p)" :class="{ added: p.addedToCart }">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
                  {{ p.addedToCart ? 'Added!' : 'Add to Cart' }}
                </button>
              </div>
            </div>
          </div>

          <div ref="loadTrigger" class="load-trigger"></div>
          <div v-if="loading" class="loading-indicator">
            <div class="loading-spinner"></div>
            <span>Loading...</span>
          </div>
          <div v-if="!hasMore && displayedProducts.length > 0" class="no-more">— No more products —</div>
          <div v-if="displayedProducts.length === 0 && !loading" class="empty-state">
            <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#ddd" stroke-width="1.5"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
            <p class="empty-title">No products found</p>
            <p class="empty-sub">Try different filters</p>
            <button class="empty-btn" @click="clearFilters">Clear Filters</button>
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
const categoryId = computed(() => Number(route.query.id) || null)
const categoryName = computed(() => route.query.name as string || 'All Products')

// Scroll
const isScrolled = ref(false)
const onScroll = () => { isScrolled.value = window.scrollY > 60 }
onMounted(() => window.addEventListener('scroll', onScroll))
onUnmounted(() => window.removeEventListener('scroll', onScroll))

const cartCount = ref(0)
const searchInput = ref('')
const doSearch = () => {
  if (searchInput.value.trim()) {
    window.location.href = `/b2c/search?q=${encodeURIComponent(searchInput.value.trim())}`
  }
}

// Filters
const openSections = ref({ price: true, rating: false, promo: false })
const toggleSection = (name: string) => { openSections.value[name] = !openSections.value[name] }

const filters = ref({
  priceMin: null, priceMax: null, minRating: 0,
  hasDiscount: false, hasBargain: false, hasFullReduction: false,
  dynamicFilters: {} as Record<string, string[]>,
})
const applyFilters = async () => {
  currentPage.value = 1
  displayedProducts.value = []
  await loadMoreProducts()
}
const clearFilters = () => {
  filters.value = { priceMin: null, priceMax: null, minRating: 0, hasDiscount: false, hasBargain: false, hasFullReduction: false, dynamicFilters: {} }
  applyFilters()
}
const activeFilterCount = computed(() => {
  let c = 0
  if (filters.value.priceMin || filters.value.priceMax) c++
  if (filters.value.minRating > 0) c++
  if (filters.value.hasDiscount) c++
  if (filters.value.hasBargain) c++
  if (filters.value.hasFullReduction) c++
  return c
})

const dynamicFacets = ref<any[]>([])
const sortBy = ref('relevance')
const applySort = async () => { currentPage.value = 1; displayedProducts.value = []; await loadMoreProducts() }
const viewMode = ref('grid')
const hoveredId = ref<number | null>(null)

const toggleWish = (p: any) => { p.wishlisted = !p.wishlisted }

const addToCart = async (p: any) => {
  if (p.addedToCart) return
  const token = localStorage.getItem('token')
  if (!token) { alert('Please login first'); return }
  try {
    await cartApi.addItem({ product_id: p.id, quantity: 1 }, token)
    p.addedToCart = true; cartCount.value++
    setTimeout(() => { p.addedToCart = false }, 2000)
  } catch (e: any) { alert('Failed: ' + e.message) }
}

// Products
const displayedProducts = ref<any[]>([])
const totalCount = ref(0)
const PAGE_SIZE = 20
const currentPage = ref(1)
const loading = ref(false)
const hasMore = ref(true)

const loadMoreProducts = async () => {
  if (loading.value) return
  loading.value = true
  try {
    const result = await productsApi.search({
      category_id: categoryId.value || undefined,
      price_min: filters.value.priceMin || undefined,
      price_max: filters.value.priceMax || undefined,
      min_rating: filters.value.minRating || undefined,
      sort: sortBy.value,
      page: currentPage.value,
      page_size: PAGE_SIZE,
    })
    if (result.facets) dynamicFacets.value = result.facets
    if (currentPage.value === 1) {
      displayedProducts.value = result.products.map((p: any) => ({ ...p, wishlisted: false, addedToCart: false }))
    } else {
      displayedProducts.value.push(...result.products.map((p: any) => ({ ...p, wishlisted: false, addedToCart: false })))
    }
    totalCount.value = result.total
    hasMore.value = displayedProducts.value.length < result.total
    currentPage.value++
  } catch (e) {
    console.error(e)
    displayedProducts.value = []; totalCount.value = 0; hasMore.value = false
  } finally { loading.value = false }
}

const loadTrigger = ref<HTMLElement | null>(null)
let observer: IntersectionObserver | null = null
const setupObserver = () => {
  if (observer) observer.disconnect()
  observer = new IntersectionObserver((entries) => {
    if (entries[0].isIntersecting && !loading.value && hasMore.value) loadMoreProducts()
  }, { rootMargin: '200px' })
  if (loadTrigger.value) observer.observe(loadTrigger.value)
}

onMounted(async () => { await loadMoreProducts(); await nextTick(); setupObserver() })
watch(loadTrigger, () => { if (loadTrigger.value) setupObserver() })
watch([filters, sortBy], () => { currentPage.value = 1 }, { deep: true })
</script>

<style scoped>
* { box-sizing: border-box; }
.b2c-category { min-height: 100vh; background: #f7f7f7; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
.top-policy { background: #111; color: #fff; }
.policy-inner { max-width: 1446px; margin: 0 auto; padding: 7px 16px; display: flex; align-items: center; justify-content: center; gap: 28px; flex-wrap: wrap; }
.policy-item { display: flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 600; color: #e0e0e0; }
.policy-item em { color: #ff3e5a; font-style: normal; }
.policy-item svg { color: #ff3e5a; flex-shrink: 0; }
.search-header { position: sticky; top: 0; z-index: 100; background: #fff; border-bottom: 1px solid #eee; transition: box-shadow 0.3s; }
.search-header.scrolled { box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
.search-header-inner { max-width: 1446px; margin: 0 auto; padding: 10px 16px; display: flex; align-items: center; gap: 16px; }
.search-logo { font-size: 22px; font-weight: 900; color: #111; text-decoration: none; letter-spacing: -1px; }
.b2b-btn-header { display: flex; align-items: center; gap: 6px; padding: 6px 14px; background: linear-gradient(135deg, #fffef5, #f9f0d8); border: 1px solid #e8d89a; border-radius: 6px; text-decoration: none; flex-shrink: 0; }
.b2b-btn-icon { font-size: 14px; }
.b2b-btn-text { font-size: 12px; font-weight: 700; color: #555; }
.b2b-btn-tag { font-size: 11px; font-weight: 800; color: #c9a84c; background: #fff; padding: 1px 5px; border-radius: 3px; border: 1px solid #e8d89a; }
.search-bar-wrap { flex: 1; max-width: 560px; }
.search-bar-inner { display: flex; border: 2px solid #111; border-radius: 6px; overflow: hidden; background: #fff; }
.search-input { flex: 1; padding: 9px 14px; border: none; outline: none; font-size: 14px; background: transparent; }
.search-btn { padding: 9px 18px; background: #111; border: none; color: #fff; cursor: pointer; display: flex; align-items: center; }
.header-actions { display: flex; align-items: center; gap: 4px; margin-left: auto; }
.header-icon-btn { position: relative; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border: none; background: transparent; cursor: pointer; border-radius: 50%; }
.header-icon-btn:hover { background: #f0f0f0; }
.cart-count { position: absolute; top: 2px; right: 2px; background: #ff3e5a; color: #fff; font-size: 9px; font-weight: 800; width: 16px; height: 16px; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
.category-body { background: #f7f7f7; min-height: calc(100vh - 120px); }
.breadcrumb-bar { background: #fff; border-bottom: 1px solid #eee; }
.breadcrumb-inner { max-width: 1446px; margin: 0 auto; padding: 8px 16px; display: flex; align-items: center; gap: 6px; font-size: 12px; }
.breadcrumb-item { color: #999; text-decoration: none; }
.breadcrumb-item.active { color: #111; font-weight: 600; }
.search-layout { max-width: 1446px; margin: 0 auto; padding: 16px; display: grid; grid-template-columns: 240px 1fr; gap: 16px; align-items: start; }
.filter-sidebar { background: #fff; border: 1px solid #eee; border-radius: 8px; overflow: hidden; position: sticky; top: 82px; max-height: calc(100vh - 100px); overflow-y: auto; scrollbar-width: thin; }
.filter-section { border-bottom: 1px solid #f0f0f0; }
.filter-section:last-child { border-bottom: none; }
.filter-section-title { display: flex; align-items: center; gap: 6px; padding: 12px 16px; cursor: pointer; font-size: 12px; font-weight: 700; color: #111; text-transform: uppercase; letter-spacing: 0.5px; user-select: none; transition: background 0.15s; }
.filter-section-title:hover { background: #fafafa; }
.filter-section-title svg { margin-left: auto; transition: transform 0.2s; }
.filter-section-title svg.rotated { transform: rotate(180deg); }
.filter-section-body { padding: 0 16px 12px; }
.price-inputs { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
.price-input { width: 80px; padding: 6px 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 12px; outline: none; }
.price-input:focus { border-color: #111; }
.price-sep { color: #aaa; }
.price-ok-btn { width: 100%; padding: 6px; background: #111; color: #fff; border: none; border-radius: 4px; font-size: 12px; font-weight: 700; cursor: pointer; }
.price-ok-btn:hover { background: #333; }
.rating-filters { display: flex; flex-direction: column; gap: 4px; }
.rating-btn { display: flex; align-items: center; gap: 4px; padding: 5px 8px; border: 1px solid #eee; border-radius: 4px; background: #fff; cursor: pointer; font-size: 12px; transition: all 0.15s; }
.rating-btn:hover { border-color: #ff3e5a; }
.rating-btn.active { background: #fff0f2; border-color: #ff3e5a; }
.stars-disp { color: #ff3e5a; letter-spacing: -2px; font-size: 11px; }
.rating-label { color: #888; font-size: 11px; }
.toggle-filter { display: flex; align-items: center; gap: 8px; padding: 4px 0; cursor: pointer; }
.toggle-filter input { accent-color: #ff3e5a; }
.toggle-label { font-size: 12px; color: #444; }
.facet-values { display: flex; flex-direction: column; gap: 2px; }
.facet-item { display: flex; align-items: center; gap: 8px; padding: 4px 6px; border-radius: 4px; cursor: pointer; transition: background 0.15s; }
.facet-item:hover { background: #f5f5f5; }
.facet-item input { accent-color: #ff3e5a; }
.facet-label { flex: 1; font-size: 12px; color: #444; }
.facet-count { font-size: 10px; color: #aaa; background: #f5f5f5; padding: 1px 5px; border-radius: 10px; }
.search-main { min-width: 0; }
.sort-bar { background: #fff; border: 1px solid #eee; border-radius: 8px; padding: 12px 16px; display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; margin-bottom: 16px; }
.results-summary { font-size: 13px; color: #666; }
.results-summary strong { color: #111; font-weight: 800; }
.results-summary em { color: #111; font-style: normal; font-weight: 600; }
.sort-controls { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.sort-select { padding: 7px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 12px; background: #fff; cursor: pointer; outline: none; color: #333; font-weight: 500; }
.sort-select:focus { border-color: #111; }
.view-toggle { display: flex; border: 1px solid #eee; border-radius: 4px; overflow: hidden; }
.view-btn { padding: 7px 10px; background: #fff; border: none; cursor: pointer; color: #aaa; transition: all 0.15s; display: flex; align-items: center; }
.view-btn:hover { color: #111; }
.view-btn.active { background: #f0f0f0; color: #111; }
.active-filters { display: flex; align-items: center; gap: 8px; }
.filter-count-badge { background: #ff3e5a; color: #fff; padding: 3px 9px; border-radius: 20px; font-size: 11px; font-weight: 800; }
.clear-filters-btn { background: none; border: none; font-size: 11px; color: #ff3e5a; cursor: pointer; font-weight: 600; }
.product-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 12px; }
.product-grid.list-view { grid-template-columns: 1fr; }
.product-card { background: #fff; border-radius: 8px; overflow: hidden; display: flex; flex-direction: column; transition: box-shadow 0.25s, transform 0.2s; cursor: pointer; }
.product-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.1); transform: translateY(-2px); }
.card-img-wrap { position: relative; aspect-ratio: 4/5; overflow: hidden; background: #f9f9f9; }
.card-img-link { display: block; width: 100%; height: 100%; }
.card-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.35s ease; }
.product-card:hover .card-img { transform: scale(1.05); }
.card-tags { position: absolute; top: 8px; left: 8px; display: flex; flex-direction: column; gap: 3px; }
.card-tag { display: inline-flex; align-items: center; gap: 3px; padding: 2px 7px; border-radius: 3px; font-size: 10px; font-weight: 800; white-space: nowrap; }
.card-tag.hot { background: #ff3e5a; color: #fff; }
.card-tag.new { background: #ff8f00; color: #fff; }
.card-tag.bargain { background: #7b2ff7; color: #fff; }
.card-tag.full { background: #e60023; color: #fff; }
.card-tag.promo { background: #ff3e5a; color: #fff; }
.tag-icon { font-size: 9px; }
.bargain-stamp-btn { position: absolute; bottom: 10px; right: 10px; display: flex; flex-direction: column; align-items: center; justify-content: center; width: 52px; height: 52px; background: radial-gradient(circle, #7b2ff7, #5c1bb8); border-radius: 50%; text-decoration: none; opacity: 0; transform: scale(0.7) rotate(-12deg); transition: opacity 0.2s, transform 0.2s; box-shadow: 0 3px 10px rgba(123,47,247,0.5); cursor: pointer; border: 2px solid rgba(255,255,255,0.4); z-index: 5; }
.bargain-stamp-btn.visible { opacity: 1; transform: scale(1) rotate(-8deg); }
.stamp-text { font-size: 13px; font-weight: 900; color: #fff; line-height: 1.1; letter-spacing: -0.5px; }
.stamp-sub { font-size: 7px; color: rgba(255,255,255,0.85); font-weight: 600; }
.discount-corner { position: absolute; top: 0; right: 0; background: #ff3e5a; color: #fff; font-size: 11px; font-weight: 800; padding: 2px 7px; border-radius: 0 0 0 6px; }
.card-wish { position: absolute; bottom: 8px; left: 8px; background: rgba(255,255,255,0.9); border: none; border-radius: 50%; width: 30px; height: 30px; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s; z-index: 10; }
.card-wish:hover { background: #fff; transform: scale(1.1); }
.card-body { padding: 10px 12px 0; flex: 1; }
.card-name { font-size: 12px; color: #222; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; text-decoration: none; }
.card-name:hover { color: #ff3e5a; }
.card-price-row { display: flex; align-items: baseline; gap: 5px; margin-top: 6px; flex-wrap: wrap; }
.card-price { font-size: 16px; font-weight: 800; color: #ff3e5a; }
.card-original-price { font-size: 11px; color: #aaa; text-decoration: line-through; }
.bargain-label { font-size: 10px; font-weight: 700; color: #7b2ff7; background: #f3eeff; padding: 1px 5px; border-radius: 3px; }
.fullreduction-label { font-size: 10px; font-weight: 700; color: #e60023; background: #fff0f0; padding: 1px 5px; border-radius: 3px; }
.card-meta-row { display: flex; align-items: center; gap: 5px; margin-top: 5px; }
.stars-comp { position: relative; display: inline-block; font-size: 10px; letter-spacing: -1px; line-height: 1; }
.stars-fill { position: absolute; top: 0; left: 0; color: #ff3e5a; overflow: hidden; white-space: nowrap; }
.stars-empty { color: #e0e0e0; }
.rating-txt { font-size: 11px; color: #666; font-weight: 600; }
.sold-count { font-size: 10px; color: #999; margin-left: auto; }
.card-actions { display: flex; gap: 6px; padding: 8px 12px; border-top: 1px solid #f0f0f0; margin-top: 8px; }
.card-inquiry-btn { flex: 1; display: flex; align-items: center; justify-content: center; gap: 4px; padding: 7px 6px; background: #fff; border: 1.5px solid #ddd; border-radius: 5px; font-size: 11px; font-weight: 700; color: #555; cursor: pointer; transition: all 0.2s; }
.card-inquiry-btn:hover { border-color: #111; color: #111; }
.card-cart-btn { flex: 1; display: flex; align-items: center; justify-content: center; gap: 4px; padding: 7px 6px; background: #ff3e5a; border: 1.5px solid #ff3e5a; border-radius: 5px; font-size: 11px; font-weight: 800; color: #fff; cursor: pointer; transition: all 0.2s; }
.card-cart-btn:hover { background: #e60040; border-color: #e60040; }
.card-cart-btn.added { background: #22c55e; border-color: #22c55e; }
.load-trigger { height: 1px; }
.loading-indicator { display: flex; align-items: center; justify-content: center; gap: 10px; padding: 24px; color: #999; font-size: 13px; }
.loading-spinner { width: 20px; height: 20px; border: 2px solid #eee; border-top-color: #ff3e5a; border-radius: 50%; animation: spin 0.8s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
.no-more { text-align: center; padding: 24px; color: #bbb; font-size: 12px; }
.empty-state { text-align: center; padding: 60px 20px; }
.empty-title { font-size: 18px; font-weight: 700; color: #333; margin: 16px 0 6px; }
.empty-sub { font-size: 13px; color: #999; margin-bottom: 20px; }
.empty-btn { padding: 10px 24px; background: #ff3e5a; color: #fff; border: none; border-radius: 6px; font-size: 13px; font-weight: 700; cursor: pointer; }
@media (max-width: 1300px) { .product-grid { grid-template-columns: repeat(5, 1fr); } }
@media (max-width: 1100px) { .product-grid { grid-template-columns: repeat(4, 1fr); } }
@media (max-width: 900px) { .search-layout { grid-template-columns: 1fr; } .filter-sidebar { position: static; max-height: none; } .product-grid { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 600px) { .product-grid { grid-template-columns: repeat(2, 1fr); gap: 8px; } }
</style>
