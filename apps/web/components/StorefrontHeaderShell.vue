<template>
  <div class="storefront-header-shell">
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

    <button class="floating-cart" @click="openCartPanel">
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
          <button class="quick-panel-close" @click="closeQuickPanel">×</button>
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
          <button class="quick-panel-secondary" @click="closeQuickPanel">Close</button>
          <button v-if="!session.loggedIn" class="quick-panel-primary" @click="goToLogin">登录</button>
          <button v-else class="quick-panel-primary" @click="handleLogoutAction">Sign Out</button>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { HOME_DISPLAY_LIMITS, HOME_FALLBACK_IMAGES } from '~/config/home'

type QuickPanelType = 'cart' | 'collect' | null

const router = useRouter()
const route = useRoute()
const searchKeyword = ref('')
const isScrolled = ref(false)
const categoryMenuOpen = ref(false)
const activeCategoryRootId = ref<number | null>(null)
const activeQuickPanel = ref<QuickPanelType>(null)
const { homePage, loadHomePage } = useHomePage()
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

function syncSearchKeyword(): void {
  searchKeyword.value = typeof route.query.keyword === 'string' ? route.query.keyword : ''
}

function goTo(path: string): void {
  categoryMenuOpen.value = false
  activeQuickPanel.value = null
  router.push(path)
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
  router.push(`/products?keyword=${encodeURIComponent(keyword)}`)
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
  syncSearchKeyword()
})

onMounted(async () => {
  syncSearchKeyword()
  await Promise.all([
    loadHomePage(),
    refreshSession(),
  ])

  window.addEventListener('scroll', handleScroll, { passive: true })
  handleScroll()
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

.shein-home {
  min-height: 100vh;
  background: #fff;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  color: #222;
}

.top-policy {
  background: #fff;
  border-bottom: 1px solid #eee;
}

.policy-inner {
  max-width: 1446px;
  margin: 0 auto;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 38px;
}

.policy-item {
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

.policy-item:last-child { border-right: none; }
.policy-item em { color: #999; font-style: normal; font-size: 11px; }

.main-header {
  background: #fff;
  border-bottom: 1px solid #eee;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
}

.main-header.scrolled { box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08); }

.header-inner {
  max-width: 1446px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 12px 0;
}

.logo-button {
  cursor: pointer;
}

.logo {
  font-size: 28px;
  font-weight: 900;
  color: #111;
  letter-spacing: -2px;
  flex-shrink: 0;
  font-style: italic;
}

.b2b-btn {
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
}

.b2b-btn:hover {
  background: #fffdf5;
  box-shadow: 0 2px 8px rgba(201, 168, 76, 0.25);
  transform: translateY(-1px);
}

.b2b-icon { font-size: 18px; }
.b2b-text { display: flex; flex-direction: column; line-height: 1.2; }
.b2b-main { font-size: 12px; font-weight: 800; color: #111; letter-spacing: 0.3px; }
.b2b-sub { font-size: 9px; color: #777; font-weight: 500; }
.b2b-vip {
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

.header-search {
  flex: 1;
  max-width: 520px;
}

.search-bar {
  flex: 1;
  display: flex;
  align-items: center;
  background: #f7f7f7;
  border: 1px solid #eee;
  border-radius: 4px;
  padding: 0 4px 0 14px;
  max-width: 520px;
  height: 38px;
  transition: border-color 0.2s;
}

.search-bar:focus-within {
  border-color: #ccc;
  background: #fff;
}

.search-icon { color: #999; flex-shrink: 0; }
.search-input {
  flex: 1;
  border: none;
  background: transparent;
  padding: 0 10px;
  font-size: 13px;
  outline: none;
  color: #333;
}

.search-input::placeholder { color: #bbb; }

.search-btn {
  background: #111;
  color: #fff;
  padding: 8px 18px;
  border-radius: 3px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
  height: 30px;
  letter-spacing: 0.3px;
}

.search-btn:hover { background: #333; }

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
  cursor: pointer;
  color: #444;
  border-radius: 4px;
  transition: background 0.2s, color 0.2s;
}

.action-btn:hover { background: #f5f5f5; color: #111; }

.action-badge {
  position: absolute;
  top: 4px;
  right: 4px;
  background: #111;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  min-width: 16px;
  height: 16px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 3px;
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

.category-nav::-webkit-scrollbar { display: none; }

.category-nav-inner {
  max-width: 1446px;
  margin: 0 auto;
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
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  color: #fff;
  font-weight: 700;
  border-bottom: none !important;
  margin-bottom: 0;
  padding: 12px 18px;
  border-radius: 0 0 10px 10px;
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.08);
}
.cat-item-all:hover { color: #fff; background: linear-gradient(135deg, #111827 0%, #1f2937 100%); }
.cat-item-all-icon,
.cat-item-all-arrow {
  font-size: 12px;
  opacity: 0.9;
}
.cat-item-sale { color: #e60023; font-weight: 600; }
.nav-divider { width: 1px; height: 18px; background: #ddd; margin: 0 6px; flex-shrink: 0; }

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
  z-index: 40;
  overflow: hidden;
}

.category-root-list {
  padding: 14px 0 10px;
  background:
    radial-gradient(circle at top left, rgba(251, 191, 36, 0.12), transparent 30%),
    linear-gradient(180deg, #111827 0%, #172033 52%, #1f2937 100%);
  border-right: 1px solid rgba(255, 255, 255, 0.08);
  max-height: 560px;
  overflow-y: auto;
}

.category-root-list::-webkit-scrollbar,
.category-panel-content::-webkit-scrollbar {
  width: 10px;
}

.category-root-list::-webkit-scrollbar-thumb,
.category-panel-content::-webkit-scrollbar-thumb {
  background: rgba(148, 163, 184, 0.35);
  border-radius: 999px;
  border: 2px solid transparent;
  background-clip: padding-box;
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
  overflow-y: auto;
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

.category-panel-kicker {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.6px;
  text-transform: uppercase;
  color: #b45309;
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

.category-panel-links {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.category-panel-link {
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

.category-panel-all:hover {
  background: #e60023;
}

.category-panel-link:hover,
.category-panel-group-title:hover,
.category-panel-title:hover {
  color: #e60023;
}

.category-panel-link:hover {
  background: #fff1f2;
  border-color: #fecdd3;
  transform: translateY(-1px);
}

.cat-special,
.cat-distributor {
  color: #fff !important;
  border-radius: 3px;
  padding: 5px 14px;
  margin: 0 4px;
  font-size: 12px;
  font-weight: 600;
  border-bottom: none !important;
  letter-spacing: 0.3px;
}

.cat-special { background: #e60023; }
.cat-special:hover { background: #c5001e; }
.cat-distributor { background: #2a2a6a; }
.cat-distributor:hover { background: #1a1a50; }

.floating-cart {
  position: fixed;
  right: 24px;
  bottom: 24px;
  width: 62px;
  height: 62px;
  border-radius: 50%;
  background: #111;
  color: #fff;
  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.24);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.floating-cart-count {
  position: absolute;
  top: 8px;
  right: 8px;
  min-width: 18px;
  height: 18px;
  padding: 0 4px;
  border-radius: 9px;
  background: #e60023;
  color: #fff;
  font-size: 10px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
}

.quick-panel-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(15, 23, 42, 0.42);
  display: flex;
  justify-content: flex-end;
  padding: 24px;
  z-index: 120;
}

.quick-panel {
  width: min(420px, 100%);
  max-height: calc(100vh - 48px);
  overflow: auto;
  border-radius: 20px;
  background: #fff;
  box-shadow: 0 28px 56px rgba(15, 23, 42, 0.28);
  padding: 24px;
}

.quick-panel-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
}

.quick-panel-kicker {
  display: inline-flex;
  align-items: center;
  padding: 5px 10px;
  border-radius: 999px;
  background: #f1f5f9;
  color: #475569;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 0.4px;
  text-transform: uppercase;
}

.quick-panel-head h3 {
  margin: 12px 0 6px;
  font-size: 24px;
  font-weight: 800;
  color: #0f172a;
}

.quick-panel-head p {
  margin: 0;
  font-size: 13px;
  color: #64748b;
}

.quick-panel-close {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: #f8fafc;
  color: #0f172a;
  font-size: 24px;
  line-height: 1;
  cursor: pointer;
}

.quick-panel-alert {
  margin: 18px 0 0;
  padding: 12px 14px;
  border-radius: 14px;
  background: #fff7ed;
  color: #9a3412;
  font-size: 13px;
  line-height: 1.5;
}

.quick-panel-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
  margin-top: 20px;
}

.quick-panel-item {
  display: grid;
  grid-template-columns: 72px 1fr;
  gap: 14px;
  align-items: center;
  padding: 12px;
  border-radius: 16px;
  background: #f8fafc;
}

.quick-panel-thumb {
  width: 72px;
  height: 72px;
  border-radius: 14px;
  overflow: hidden;
  background: #e2e8f0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.quick-panel-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.quick-panel-thumb-empty {
  font-size: 14px;
  font-weight: 800;
  color: #475569;
  letter-spacing: 1px;
}

.quick-panel-item-main {
  display: flex;
  flex-direction: column;
  gap: 6px;
  min-width: 0;
}

.quick-panel-item-main strong {
  font-size: 14px;
  line-height: 1.5;
  color: #111827;
}

.quick-panel-item-main span {
  font-size: 13px;
  font-weight: 700;
  color: #e11d48;
}

.quick-panel-empty {
  margin: 20px 0 0;
  padding: 20px 16px;
  border-radius: 16px;
  background: #f8fafc;
  color: #64748b;
  font-size: 14px;
  text-align: center;
}

.quick-panel-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}

.quick-panel-secondary,
.quick-panel-primary {
  height: 42px;
  padding: 0 18px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
}

.quick-panel-secondary {
  background: #e2e8f0;
  color: #0f172a;
}

.quick-panel-primary {
  background: #111827;
  color: #fff;
}

@media (max-width: 1280px) {
  .header-inner,
  .policy-inner,
  .category-nav-inner,
  .main-content,
  .footer-inner {
    width: calc(100% - 32px);
  }

  .hero-left,
  .hero-right {
    width: 220px;
  }

  .product-grid {
    grid-template-columns: repeat(4, 1fr);
  }

  .category-grid {
    grid-template-columns: repeat(4, 1fr);
  }

  .category-mega-menu {
    width: min(980px, calc(100vw - 24px));
    grid-template-columns: 220px 1fr;
  }

  .category-panel-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .category-panel-groups {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 960px) {
  .policy-inner,
  .header-inner,
  .category-nav-inner,
  .section-inner,
  .footer-inner,
  .main-content {
    width: calc(100% - 24px);
  }

  .policy-inner {
    justify-content: flex-start;
    overflow-x: auto;
  }

  .category-nav {
    overflow-x: auto;
    scrollbar-width: none;
  }

  .header-inner {
    flex-wrap: wrap;
    gap: 12px;
  }

  .header-search,
  .search-bar {
    order: 3;
    max-width: none;
    width: 100%;
  }

  .hero-inner,
  .activity-grid-v2,
  .footer-grid,
  .footer-bottom {
    display: flex;
    flex-direction: column;
    height: auto;
  }

  .hero-left,
  .hero-right {
    width: 100%;
  }

  .product-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .category-mega-menu {
    display: none;
  }

  .category-grid {
    grid-template-columns: repeat(4, 1fr);
  }

  .quick-panel-backdrop {
    padding: 12px;
    align-items: flex-end;
  }

  .quick-panel {
    max-height: 80vh;
    padding: 18px;
  }
}
</style>
