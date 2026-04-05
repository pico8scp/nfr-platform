<template>
  <div class="b2b-category">
    <SiteHeader />

    <header class="b2b-header" :class="{ scrolled: isScrolled }">
      <div class="b2b-header-inner">
        <a href="/b2b" class="b2b-logo">NFR B2B</a>
        <div class="header-center">
          <a href="/b2c" class="c2c-link">C端 shopping</a>
        </div>
        <div class="header-actions">
          <button class="header-icon-btn cart-btn">
            <svg width="18" height="18" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            <span class="cart-count" v-if="cartCount > 0">{{ cartCount }}</span>
          </button>
        </div>
      </div>
    </header>

    <div class="category-body">
      <div class="breadcrumb-bar">
        <div class="breadcrumb-inner">
          <a href="/" class="breadcrumb-item">Home</a>
          <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
          <span class="breadcrumb-item active">B2B Wholesale</span>
          <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
          <span class="breadcrumb-item active">{{ categoryName || 'All Products' }}</span>
        </div>
      </div>

      <div class="category-layout">
        <!-- 左侧 -->
        <aside class="b2b-sidebar">
          <div class="sidebar-section">
            <div class="sidebar-title">Categories</div>
            <div class="cat-list">
              <button v-for="cat in navCategories" :key="cat.id" class="cat-btn" :class="{ active: selectedCatId === cat.id }" @click="selectCat(cat)">
                {{ cat.name }}
              </button>
            </div>
          </div>

          <div class="sidebar-section">
            <div class="sidebar-title">Price Range</div>
            <div class="price-inputs">
              <input v-model="filters.priceMin" type="number" placeholder="Min $" class="price-input" />
              <span>—</span>
              <input v-model="filters.priceMax" type="number" placeholder="Max $" class="price-input" />
            </div>
            <button class="apply-btn" @click="applyFilters">Apply</button>
          </div>

          <div class="sidebar-section">
            <div class="sidebar-title">Min Order Qty</div>
            <input v-model="filters.moq" type="number" placeholder="MOQ" class="price-input" style="width:100%" />
          </div>

          <div class="sidebar-section">
            <div class="sidebar-title">Verified Supplier</div>
            <label class="toggle-filter"><input type="checkbox" v-model="filters.verifiedOnly" @change="applyFilters" /><span class="toggle-label">Verified only</span></label>
          </div>
        </aside>

        <!-- 主内容 -->
        <main class="b2b-main">
          <div class="b2b-sort-bar">
            <div class="results-summary">
              <strong>{{ totalCount }}</strong> wholesale products
              <span v-if="categoryName"> in <em>{{ categoryName }}</em></span>
            </div>
            <div class="sort-controls">
              <select v-model="sortBy" class="sort-select" @change="applySort">
                <option value="relevance">Relevance</option>
                <option value="price-low">Price: Low to High</option>
                <option value="price-high">Price: High to Low</option>
                <option value="moq">MOQ: Low to High</option>
                <option value="rating">Top Rated</option>
              </select>
              <div v-if="activeFilterCount > 0" class="active-filters">
                <span class="filter-count-badge">{{ activeFilterCount }}</span>
                <button class="clear-filters-btn" @click="clearFilters">Clear all</button>
              </div>
            </div>
          </div>

          <!-- B2B商品网格 -->
          <div class="b2b-product-grid">
            <div class="b2b-product-card" v-for="p in displayedProducts" :key="p.id">
              <div class="b2b-img-wrap">
                <a :href="`/b2b/product/${p.id}`">
                  <img :src="p.img || 'https://via.placeholder.com/300x300'" :alt="p.name" class="b2b-img" loading="lazy" />
                </a>
                <div class="b2b-img-tags">
                  <span v-for="tag in p.tags.slice(0, 2)" :key="tag.type" class="b2b-tag" :class="tag.type">{{ tag.label }}</span>
                </div>
              </div>
              <div class="b2b-card-body">
                <a :href="`/b2b/product/${p.id}`" class="b2b-product-name">{{ p.name }}</a>
                <div class="b2b-price-row">
                  <span class="b2b-price">${{ p.price }}</span>
                  <span class="b2b-moq">MOQ: {{ p.moq || 10 }}+</span>
                </div>
                <div class="b2b-meta-row">
                  <span class="stars-comp">
                    <span class="stars-fill" :style="{ width: (p.rating / 5 * 100) + '%' }">★★★★★</span>
                    <span class="stars-empty">★★★★★</span>
                  </span>
                  <span class="b2b-sold">{{ p.sold?.toLocaleString() || 0 }} sold</span>
                </div>
                <div class="b2b-actions">
                  <button class="b2b-inquiry-btn" @click="openInquiry(p)">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                    Inquire
                  </button>
                  <button class="b2b-cart-btn" @click="addToCart(p)">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
                    Add to Cart
                  </button>
                </div>
              </div>
            </div>
          </div>

          <div ref="loadTrigger" class="load-trigger"></div>
          <div v-if="loading" class="loading-indicator">
            <div class="loading-spinner"></div>
            <span>Loading...</span>
          </div>
          <div v-if="!hasMore && displayedProducts.length > 0" class="no-more">— No more —</div>
          <div v-if="displayedProducts.length === 0 && !loading" class="empty-state">
            <p>No products found</p>
            <button @click="clearFilters" class="empty-btn">Clear Filters</button>
          </div>
        </main>
      </div>
    </div>

    <!-- 询价弹窗 -->
    <div v-if="inquiryProduct" class="inquiry-overlay" @click.self="inquiryProduct = null">
      <div class="inquiry-modal">
        <div class="inquiry-header">
          <h3>Inquire: {{ inquiryProduct.name?.slice(0, 40) }}...</h3>
          <button class="inquiry-close" @click="inquiryProduct = null">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6L6 18M6 6l12 12"/></svg>
          </button>
        </div>
        <div class="inquiry-body">
          <div class="inquiry-product">
            <img :src="inquiryProduct.img" class="inquiry-img" />
            <div>
              <div class="inquiry-name">{{ inquiryProduct.name }}</div>
              <div class="inquiry-price">${{ inquiryProduct.price }}</div>
            </div>
          </div>
          <textarea v-model="inquiryMsg" class="inquiry-textarea" placeholder="Hi, I'm interested in wholesale pricing for this product. What's the best MOQ and price?"></textarea>
          <div class="inquiry-actions">
            <button class="inquiry-submit" @click="submitInquiry">Send Inquiry</button>
            <button class="inquiry-cancel" @click="inquiryProduct = null">Cancel</button>
          </div>
        </div>
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
const categoryName = computed(() => route.query.name as string || '')

const isScrolled = ref(false)
const onScroll = () => { isScrolled.value = window.scrollY > 60 }
onMounted(() => window.addEventListener('scroll', onScroll))
onUnmounted(() => window.removeEventListener('scroll', onScroll))

const cartCount = ref(0)

const navCategories = ref<any[]>([])
const selectedCatId = ref<number | null>(null)

const selectCat = async (cat: any) => {
  selectedCatId.value = cat.id === selectedCatId.value ? null : cat.id
  currentPage.value = 1
  displayedProducts.value = []
  await loadMoreProducts()
}

// Filters
const filters = ref({
  priceMin: null as number | null,
  priceMax: null as number | null,
  moq: null as number | null,
  verifiedOnly: false,
})
const applyFilters = async () => {
  currentPage.value = 1; displayedProducts.value = []; await loadMoreProducts()
}
const clearFilters = () => {
  filters.value = { priceMin: null, priceMax: null, moq: null, verifiedOnly: false }
  selectedCatId.value = null
  applyFilters()
}
const activeFilterCount = computed(() => {
  let c = 0
  if (filters.value.priceMin || filters.value.priceMax) c++
  if (filters.value.moq) c++
  if (filters.value.verifiedOnly) c++
  if (selectedCatId.value) c++
  return c
})

const sortBy = ref('relevance')
const applySort = async () => { currentPage.value = 1; displayedProducts.value = []; await loadMoreProducts() }

// Inquiry
const inquiryProduct = ref<any>(null)
const inquiryMsg = ref('')
const openInquiry = (p: any) => { inquiryProduct.value = p; inquiryMsg.value = '' }
const submitInquiry = () => { alert('Inquiry sent!'); inquiryProduct.value = null }

// Cart
const addToCart = async (p: any) => {
  const token = localStorage.getItem('token')
  if (!token) { alert('Please login first'); return }
  try {
    await cartApi.addItem({ product_id: p.id, quantity: 1 }, token)
    cartCount.value++
    alert('Added to cart!')
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
      category_id: selectedCatId.value || categoryId.value || undefined,
      price_min: filters.value.priceMin || undefined,
      price_max: filters.value.priceMax || undefined,
      sort: sortBy.value,
      page: currentPage.value,
      page_size: PAGE_SIZE,
    })
    const newItems = result.products.map((p: any) => ({ ...p, moq: p.moq || 10 }))
    if (currentPage.value === 1) {
      displayedProducts.value = newItems
    } else {
      displayedProducts.value.push(...newItems)
    }
    totalCount.value = result.total
    hasMore.value = displayedProducts.value.length < result.total
    currentPage.value++
  } catch (e) {
    console.error(e)
    displayedProducts.value = []; totalCount.value = 0; hasMore.value = false
  } finally { loading.value = false }
}

// Load categories
onMounted(async () => {
  try {
    const cats = await productsApi.getCategories()
    navCategories.value = flattenCats(cats)
  } catch (e) { console.error(e) }
  await loadMoreProducts()
  await nextTick()
  setupObserver()
})

function flattenCats(cats: any[], result: any[] = []) {
  for (const cat of cats) {
    result.push(cat)
    if (cat.children?.length) flattenCats(cat.children, result)
  }
  return result
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

watch(loadTrigger, () => { if (loadTrigger.value) setupObserver() })
watch([filters, sortBy, selectedCatId], () => { currentPage.value = 1 }, { deep: true })
</script>

<style scoped>
* { box-sizing: border-box; }
.b2b-category { min-height: 100vh; background: #f4f4f4; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
.b2b-header { position: sticky; top: 0; z-index: 100; background: #fff; border-bottom: 1px solid #e8d89a; box-shadow: 0 1px 4px rgba(0,0,0,0.05); }
.b2b-header.scrolled { box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
.b2b-header-inner { max-width: 1446px; margin: 0 auto; padding: 12px 16px; display: flex; align-items: center; gap: 16px; }
.b2b-logo { font-size: 20px; font-weight: 900; color: #c9a84c; text-decoration: none; letter-spacing: -0.5px; }
.header-center { flex: 1; }
.c2c-link { font-size: 12px; color: #888; text-decoration: none; }
.c2c-link:hover { color: #111; }
.header-actions { display: flex; align-items: center; gap: 4px; }
.header-icon-btn { position: relative; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border: none; background: transparent; cursor: pointer; border-radius: 50%; }
.header-icon-btn:hover { background: #f0f0f0; }
.cart-count { position: absolute; top: 2px; right: 2px; background: #c9a84c; color: #fff; font-size: 9px; font-weight: 800; width: 16px; height: 16px; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
.category-body { background: #f4f4f4; min-height: calc(100vh - 60px); }
.breadcrumb-bar { background: #fff; border-bottom: 1px solid #eee; }
.breadcrumb-inner { max-width: 1446px; margin: 0 auto; padding: 8px 16px; display: flex; align-items: center; gap: 6px; font-size: 12px; }
.breadcrumb-item { color: #999; text-decoration: none; }
.breadcrumb-item.active { color: #111; font-weight: 600; }
.category-layout { max-width: 1446px; margin: 0 auto; padding: 16px; display: grid; grid-template-columns: 220px 1fr; gap: 16px; align-items: start; }
.b2b-sidebar { background: #fff; border: 1px solid #eee; border-radius: 8px; overflow: hidden; position: sticky; top: 80px; max-height: calc(100vh - 100px); overflow-y: auto; scrollbar-width: thin; }
.sidebar-section { padding: 14px 16px; border-bottom: 1px solid #f0f0f0; }
.sidebar-section:last-child { border-bottom: none; }
.sidebar-title { font-size: 12px; font-weight: 800; color: #111; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 10px; }
.cat-list { display: flex; flex-direction: column; gap: 2px; }
.cat-btn { text-align: left; padding: 6px 10px; font-size: 12px; color: #555; border: none; background: none; cursor: pointer; border-radius: 4px; transition: all 0.15s; }
.cat-btn:hover { background: #f5f5f5; color: #111; }
.cat-btn.active { background: #fffef5; color: #c9a84c; font-weight: 700; }
.price-inputs { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; }
.price-input { width: 80px; padding: 6px 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 12px; outline: none; }
.price-input:focus { border-color: #c9a84c; }
.apply-btn { width: 100%; padding: 6px; background: #c9a84c; color: #fff; border: none; border-radius: 4px; font-size: 12px; font-weight: 700; cursor: pointer; }
.apply-btn:hover { background: #b8973b; }
.toggle-filter { display: flex; align-items: center; gap: 8px; cursor: pointer; }
.toggle-filter input { accent-color: #c9a84c; }
.toggle-label { font-size: 12px; color: #555; }
.b2b-main { min-width: 0; }
.b2b-sort-bar { background: #fff; border: 1px solid #eee; border-radius: 8px; padding: 12px 16px; display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; margin-bottom: 16px; }
.results-summary { font-size: 13px; color: #555; }
.results-summary strong { color: #111; font-weight: 800; }
.results-summary em { color: #111; font-style: normal; font-weight: 600; }
.sort-controls { display: flex; align-items: center; gap: 10px; }
.sort-select { padding: 7px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 12px; background: #fff; cursor: pointer; outline: none; }
.sort-select:focus { border-color: #c9a84c; }
.active-filters { display: flex; align-items: center; gap: 8px; }
.filter-count-badge { background: #c9a84c; color: #fff; padding: 3px 9px; border-radius: 20px; font-size: 11px; font-weight: 800; }
.clear-filters-btn { background: none; border: none; font-size: 11px; color: #e60023; cursor: pointer; font-weight: 600; }
.b2b-product-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; }
.b2b-product-card { background: #fff; border: 1px solid #eee; border-radius: 8px; overflow: hidden; transition: box-shadow 0.2s; }
.b2b-product-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
.b2b-img-wrap { position: relative; aspect-ratio: 1; overflow: hidden; background: #f9f9f9; }
.b2b-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
.b2b-product-card:hover .b2b-img { transform: scale(1.03); }
.b2b-img-tags { position: absolute; top: 8px; left: 8px; display: flex; flex-direction: column; gap: 3px; }
.b2b-tag { display: inline-block; padding: 2px 7px; border-radius: 3px; font-size: 10px; font-weight: 800; }
.b2b-tag.hot { background: #ff3e5a; color: #fff; }
.b2b-tag.new { background: #ff8f00; color: #fff; }
.b2b-tag.bargain { background: #7b2ff7; color: #fff; }
.b2b-card-body { padding: 12px; }
.b2b-product-name { font-size: 12px; color: #222; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; text-decoration: none; }
.b2b-product-name:hover { color: #c9a84c; }
.b2b-price-row { display: flex; align-items: baseline; gap: 8px; margin-top: 6px; }
.b2b-price { font-size: 15px; font-weight: 800; color: #c9a84c; }
.b2b-moq { font-size: 10px; color: #888; }
.b2b-meta-row { display: flex; align-items: center; gap: 6px; margin-top: 5px; }
.stars-comp { position: relative; display: inline-block; font-size: 10px; letter-spacing: -1px; }
.stars-fill { position: absolute; top: 0; left: 0; color: #c9a84c; overflow: hidden; white-space: nowrap; }
.stars-empty { color: #e0e0e0; }
.b2b-sold { font-size: 11px; color: #999; }
.b2b-actions { display: flex; gap: 6px; margin-top: 10px; }
.b2b-inquiry-btn { flex: 1; display: flex; align-items: center; justify-content: center; gap: 4px; padding: 7px 6px; background: #fff; border: 1.5px solid #c9a84c; border-radius: 5px; font-size: 11px; font-weight: 700; color: #c9a84c; cursor: pointer; transition: all 0.2s; }
.b2b-inquiry-btn:hover { background: #fffef5; }
.b2b-cart-btn { flex: 1; display: flex; align-items: center; justify-content: center; gap: 4px; padding: 7px 6px; background: #c9a84c; border: 1.5px solid #c9a84c; border-radius: 5px; font-size: 11px; font-weight: 800; color: #fff; cursor: pointer; transition: all 0.2s; }
.b2b-cart-btn:hover { background: #b8973b; border-color: #b8973b; }
.load-trigger { height: 1px; }
.loading-indicator { display: flex; align-items: center; justify-content: center; gap: 10px; padding: 24px; color: #999; font-size: 13px; }
.loading-spinner { width: 20px; height: 20px; border: 2px solid #eee; border-top-color: #c9a84c; border-radius: 50%; animation: spin 0.8s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
.no-more { text-align: center; padding: 24px; color: #bbb; font-size: 12px; }
.empty-state { text-align: center; padding: 60px 20px; }
.empty-state p { font-size: 16px; color: #555; margin-bottom: 16px; }
.empty-btn { padding: 10px 24px; background: #c9a84c; color: #fff; border: none; border-radius: 6px; font-size: 13px; font-weight: 700; cursor: pointer; }
.inquiry-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 200; display: flex; align-items: center; justify-content: center; padding: 16px; }
.inquiry-modal { background: #fff; border-radius: 12px; width: 100%; max-width: 480px; overflow: hidden; }
.inquiry-header { display: flex; align-items: center; justify-content: space-between; padding: 16px 20px; border-bottom: 1px solid #eee; }
.inquiry-header h3 { font-size: 15px; font-weight: 700; color: #111; margin: 0; }
.inquiry-close { border: none; background: transparent; cursor: pointer; padding: 4px; color: #999; }
.inquiry-body { padding: 20px; }
.inquiry-product { display: flex; gap: 12px; align-items: center; margin-bottom: 16px; }
.inquiry-img { width: 60px; height: 60px; object-fit: cover; border-radius: 6px; }
.inquiry-name { font-size: 13px; color: #333; font-weight: 600; margin-bottom: 4px; }
.inquiry-price { font-size: 15px; color: #c9a84c; font-weight: 800; }
.inquiry-textarea { width: 100%; height: 100px; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; resize: none; outline: none; font-family: inherit; }
.inquiry-textarea:focus { border-color: #c9a84c; }
.inquiry-actions { display: flex; gap: 10px; margin-top: 12px; }
.inquiry-submit { flex: 1; padding: 10px; background: #c9a84c; color: #fff; border: none; border-radius: 6px; font-size: 13px; font-weight: 700; cursor: pointer; }
.inquiry-cancel { padding: 10px 20px; background: #fff; color: #555; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; cursor: pointer; }
@media (max-width: 1100px) { .b2b-product-grid { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 900px) { .category-layout { grid-template-columns: 1fr; } .b2b-sidebar { position: static; max-height: none; } .b2b-product-grid { grid-template-columns: repeat(2, 1fr); } }
</style>
