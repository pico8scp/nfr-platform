<template>
  <div class="shein-home">
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

    <main class="main-content">
      <section class="hero-section">
        <div class="hero-inner">
          <div class="hero-left">
            <button class="hero-side-banner promo-banner" @click="goTo('/activity')">
              <img :src="heroSideCards[0].image" :alt="heroSideCards[0].title" @error="handleImageError($event, heroSideCards[0].fallbackImage)" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">{{ heroSideCards[0].tag }}</span>
                <span class="hero-side-title">{{ heroSideCards[0].title }}</span>
                <span class="hero-side-price">{{ heroSideCards[0].subtitle }}</span>
              </div>
              <span class="promo-badge">NEW</span>
            </button>
            <button class="hero-side-banner dist-banner" @click="goTo('/distribution')">
              <img :src="heroSideCards[1].image" :alt="heroSideCards[1].title" @error="handleImageError($event, heroSideCards[1].fallbackImage)" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">{{ heroSideCards[1].tag }}</span>
                <span class="hero-side-title">{{ heroSideCards[1].title }}</span>
                <span class="hero-side-price">{{ heroSideCards[1].subtitle }}</span>
              </div>
            </button>
            <button class="hero-side-banner" @click="goTo('/products?scene=new')">
              <img :src="heroSideCards[2].image" :alt="heroSideCards[2].title" @error="handleImageError($event, heroSideCards[2].fallbackImage)" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">{{ heroSideCards[2].tag }}</span>
                <span class="hero-side-title">{{ heroSideCards[2].title }}</span>
                <span class="hero-side-price">{{ heroSideCards[2].subtitle }}</span>
              </div>
            </button>
          </div>

          <div class="hero-carousel" v-if="homePage.banners.length">
            <div class="carousel-track" :style="bannerTrackStyle">
              <button
                v-for="banner in displayBanners"
                :key="banner.id"
                class="carousel-slide"
                @click="goTo(banner.link)"
              >
                <img :src="banner.image" :alt="banner.title" @error="handleImageError($event, banner.fallbackImage)" />
                <div class="carousel-content">
                  <span class="carousel-tag">{{ banner.tag }}</span>
                  <h2 class="carousel-title">{{ banner.title }}</h2>
                  <span class="carousel-sub">{{ banner.subtitle }}</span>
                  <span class="carousel-btn">{{ banner.cta }}</span>
                </div>
              </button>
            </div>
            <button class="carousel-arrow carousel-arrow-prev" @click="previousBanner">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M15 18l-6-6 6-6"/></svg>
            </button>
            <button class="carousel-arrow carousel-arrow-next" @click="nextBanner">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M9 18l6-6-6-6"/></svg>
            </button>
            <div class="carousel-dots">
              <button
                v-for="(banner, index) in displayBanners"
                :key="banner.id"
                class="carousel-dot"
                :class="{ active: index === activeBanner }"
                @click="activeBanner = index"
              ></button>
            </div>
          </div>

          <div class="hero-right">
            <button class="hero-side-banner upgrade-banner" @click="goTo('/b2b')">
              <img :src="heroSideCards[3].image" :alt="heroSideCards[3].title" @error="handleImageError($event, heroSideCards[3].fallbackImage)" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">{{ heroSideCards[3].tag }}</span>
                <span class="hero-side-title">{{ heroSideCards[3].title }}</span>
                <span class="hero-side-price">{{ heroSideCards[3].subtitle }}</span>
              </div>
            </button>
            <button class="hero-side-banner activity-side-banner" @click="goTo('/combination')">
              <img :src="heroSideCards[4].image" :alt="heroSideCards[4].title" @error="handleImageError($event, heroSideCards[4].fallbackImage)" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">{{ heroSideCards[4].tag }}</span>
                <span class="hero-side-title">{{ heroSideCards[4].title }}</span>
                <span class="hero-side-price">{{ heroSideCards[4].subtitle }}</span>
              </div>
            </button>
            <button class="hero-side-banner" @click="goTo('/products?scene=hot')">
              <img :src="heroSideCards[5].image" :alt="heroSideCards[5].title" @error="handleImageError($event, heroSideCards[5].fallbackImage)" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">{{ heroSideCards[5].tag }}</span>
                <span class="hero-side-title">{{ heroSideCards[5].title }}</span>
                <span class="hero-side-price">{{ heroSideCards[5].subtitle }}</span>
              </div>
            </button>
          </div>
        </div>
      </section>

      <section class="activity-section">
        <div class="section-inner">
          <div class="activity-grid-v2">
            <div class="activity-card-v2 card-flash">
              <div class="card-header-v2">
                <div class="card-title-group">
                  <svg class="icon-flash" width="16" height="16" viewBox="0 0 24 24" fill="#e60023"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>
                  <span class="card-title">限时特惠</span>
                </div>
                <div class="countdown-v2">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#e60023" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
                  <span>{{ countdownLabel }}</span>
                </div>
              </div>

              <div class="flash-products-v2">
                <button
                  v-for="product in flashSaleProducts"
                  :key="product.id"
                  class="flash-item"
                  @click="goToProduct(product.id)"
                >
                  <div class="flash-img-wrap">
                    <img :src="product.image" :alt="product.name" @error="handleImageError($event, fallbackProductImage)" />
                    <span class="flash-off">-{{ productDiscount(product) }}%</span>
                  </div>
                  <div class="flash-info">
                    <span class="flash-name">{{ product.name }}</span>
                    <span class="flash-price">¥{{ product.price }}</span>
                    <span class="flash-old">¥{{ product.originalPrice }}</span>
                  </div>
                </button>
              </div>

              <button class="card-more-v2" @click="goTo('/seckill')">See More <span>→</span></button>
            </div>

            <div class="activity-card-v2 card-trending">
              <div class="card-header-v2">
                <div class="card-title-group">
                  <svg class="icon-trophy" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#c9a84c" stroke-width="2"><path d="M8 21h8M12 17v4M7 4h10v5a5 5 0 0 1-10 0V4zM5 4v3a7 7 0 0 0 14 0V4"/></svg>
                  <span class="card-title">平台最畅销</span>
                </div>
                <button class="card-see-all" @click="goTo('/products?scene=hot')">查看全部 →</button>
              </div>

              <div class="trending-list-v2">
                <button
                  v-for="(product, index) in bestSellerProducts"
                  :key="product.id"
                  class="trending-row"
                  @click="goToProduct(product.id)"
                >
                  <span class="trend-rank" :class="{ top: index < 3 }">{{ index + 1 }}</span>
                  <img :src="product.image" :alt="product.name" @error="handleImageError($event, fallbackProductImage)" />
                  <div class="trend-info">
                    <span class="trend-name">{{ product.name }}</span>
                    <span class="trend-sales">已售 {{ product.sales }} 件</span>
                    <span class="trend-price">¥{{ product.price }}</span>
                  </div>
                </button>
              </div>
            </div>

            <div class="activity-card-v2 card-brands card-groupbuy">
              <div class="card-header-v2">
                <div class="card-title-group">
                  <svg class="icon-people" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e60023" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                  <span class="card-title">公开拼团</span>
                </div>
                <span class="groupbuy-live-tag">进行中</span>
              </div>

              <div class="groupbuy-list-v2">
                <button
                  v-for="product in groupBuyProducts"
                  :key="product.id"
                  class="groupbuy-row"
                  @click="goToProduct(product.id)"
                >
                  <div class="groupbuy-img-wrap">
                    <img :src="product.image" :alt="product.name" @error="handleImageError($event, fallbackProductImage)" />
                    <span class="groupbuy-count">{{ groupBuyMembers(product) }}/{{ groupBuyTarget(product) }}人</span>
                  </div>
                  <div class="groupbuy-info">
                    <span class="groupbuy-title">{{ product.name }}</span>
                    <div class="groupbuy-price-row">
                      <span class="groupbuy-price">¥{{ product.price }}</span>
                      <span class="groupbuy-save">省¥{{ groupBuySave(product) }}</span>
                    </div>
                    <div class="groupbuy-progress">
                      <div class="groupbuy-bar" :style="{ width: groupBuyProgress(product) + '%' }"></div>
                    </div>
                    <span class="groupbuy-status">剩余 {{ groupBuyRemaining(product) }}</span>
                  </div>
                  <span class="groupbuy-join-btn">加入</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section class="products-section">
        <div class="section-inner">
          <div class="section-title-row">
            <h3 class="section-title">Hot Sellers</h3>
            <button class="section-more" @click="goTo('/products')">View All →</button>
          </div>
          <div class="product-grid">
            <div class="product-card-wrap" v-for="product in displayProducts" :key="product.id">
              <button class="product-card" @click="goToProduct(product.id)">
                <div class="product-img">
                  <img :src="product.image" :alt="product.name" @error="handleImageError($event, fallbackProductImage)" />
                  <span v-if="product.badge" class="product-tag">{{ product.badge }}</span>
                  <span class="product-wish">♡</span>
                </div>
                <div class="product-info">
                  <p class="product-name">{{ product.name }}</p>
                  <div class="product-price-row">
                    <span class="product-price">¥{{ product.price }}</span>
                    <span v-if="product.originalPrice" class="product-old-price">¥{{ product.originalPrice }}</span>
                    <span class="product-off">{{ productDiscount(product) }}%</span>
                  </div>
                </div>
              </button>
              <button class="b2b-price-btn" @click="goTo('/b2b')">
                <span class="b2b-price-icon">🏭</span>
                <span class="b2b-price-text">B端最低 <strong>¥{{ b2bPrice(product) }}</strong></span>
                <span class="b2b-price-arrow">→</span>
              </button>
            </div>
          </div>
          <div class="load-more">
            <button class="load-more-btn" @click="goTo('/products')">Load More</button>
          </div>
        </div>
      </section>
    </main>

    <footer class="main-footer">
      <div class="footer-inner">
        <div class="footer-grid">
          <div class="footer-col">
            <h4 class="footer-heading">Company Info</h4>
            <ul class="footer-links-list">
              <li><button @click="goTo('/about')">About Us</button></li>
              <li><button @click="goTo('/careers')">Careers</button></li>
              <li><button @click="goTo('/activity')">Activity Center</button></li>
              <li class="footer-distributor-link"><button class="distributor-link" @click="goTo('/distribution')">Become a Distributor — Earn Commission</button></li>
            </ul>
          </div>

          <div class="footer-col">
            <h4 class="footer-heading">Customer Service</h4>
            <ul class="footer-links-list">
              <li><button @click="goTo('/help')">Help Center</button></li>
              <li><button @click="goTo('/orders')">Track Order</button></li>
              <li><button @click="goTo('/service')">Return Policy</button></li>
              <li><button @click="goTo('/privacy')">Privacy Policy</button></li>
              <li><button @click="goTo('/agreement')">Terms & Conditions</button></li>
            </ul>
          </div>

          <div class="footer-col">
            <h4 class="footer-heading">Marketing Pages</h4>
            <div class="marketing-route-list">
              <button v-for="item in marketingRoutes" :key="item.path" class="marketing-route-item" @click="goTo(item.path)">
                <span class="marketing-route-name">{{ item.name }}</span>
                <span class="marketing-route-note">{{ item.note }}</span>
              </button>
            </div>
          </div>

          <div class="footer-col">
            <h4 class="footer-heading">Stay Updated</h4>
            <p class="footer-sub-text">{{ footerDescription }}</p>
            <div class="footer-subscribe">
              <input type="email" placeholder="Enter your email" class="subscribe-input" />
              <button class="subscribe-btn">Subscribe</button>
            </div>
          </div>
        </div>

        <div class="footer-bottom">
          <p class="copyright">© 2026 {{ homePage.siteName }}. All rights reserved.</p>
          <p class="footer-note">活动、优惠券、拼团等营销入口统一在首页展示，独立活动页已预留。</p>
        </div>
      </div>
    </footer>

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
import { HOME_DISPLAY_LIMITS, HOME_FALLBACK_IMAGES, isHomeFallbackImage } from '~/config/home'

definePageMeta({
  layout: 'home',
})

useHead({
  title: 'NFR 商城首页',
})

interface MarketingRouteItem {
  path: string
  name: string
  note: string
}

interface DisplayBannerItem {
  id: string
  tag: string
  title: string
  subtitle: string
  cta: string
  link: string
  bg: string
  image: string
  fallbackImage: string
}

type QuickPanelType = 'cart' | 'collect' | null

const router = useRouter()
const searchKeyword = ref('')
const activeBanner = ref(0)
const isScrolled = ref(false)
const categoryMenuOpen = ref(false)
const activeCategoryRootId = ref<number | null>(null)
const activeQuickPanel = ref<QuickPanelType>(null)
const countdown = reactive({ h: '08', m: '42', s: '15' })
const { homePage, loadHomePage } = useHomePage()
const { session, refreshSession, logout } = useCrmebSession()

const fallbackBannerImage = HOME_FALLBACK_IMAGES.banner
const fallbackProductImage = HOME_FALLBACK_IMAGES.product
const fallbackHeroSideImages = HOME_FALLBACK_IMAGES.heroSide

const categoryMenuRoots = computed(() => homePage.value.categoryTreeRoots)
const activeCategoryRoot = computed(() => {
  return categoryMenuRoots.value.find((item) => item.id === activeCategoryRootId.value) ?? categoryMenuRoots.value[0] ?? null
})
const realImagePool = computed(() => {
  const pool = [
    ...homePage.value.featuredProducts,
    ...homePage.value.dealProducts,
    ...homePage.value.seckillProducts,
  ]
    .map((item) => item.image)
    .filter((image): image is string => Boolean(image) && !isHomeFallbackImage(image))

  return Array.from(new Set(pool))
})
const primaryNavItems = computed(() => {
  return homePage.value.navItems
    .filter((item) => !item.link.includes('category_id='))
    .slice(0, HOME_DISPLAY_LIMITS.categoryEntries)
})
const flashSaleProducts = computed(() => homePage.value.seckillProducts.slice(0, HOME_DISPLAY_LIMITS.flashSaleProducts))
const bestSellerProducts = computed(() => homePage.value.featuredProducts.slice(0, HOME_DISPLAY_LIMITS.bestSellerProducts))
const groupBuyProducts = computed(() => (homePage.value.seckillProducts.length ? homePage.value.seckillProducts : homePage.value.dealProducts).slice(0, HOME_DISPLAY_LIMITS.groupBuyProducts))
const headerCartCount = computed(() => session.value.loggedIn ? session.value.cartCount : homePage.value.cartCount)
const headerCollectCount = computed(() => session.value.collectCount)
const quickPanelItems = computed(() => activeQuickPanel.value === 'cart' ? session.value.cartItems : session.value.collectItems)
const quickPanelTitle = computed(() => activeQuickPanel.value === 'cart' ? '购物车预览' : '收藏预览')
const quickPanelSummary = computed(() => {
  const count = activeQuickPanel.value === 'cart' ? headerCartCount.value : headerCollectCount.value
  const label = activeQuickPanel.value === 'cart' ? 'items in your cart' : 'items in your wishlist'
  return `${count} ${label}`
})
const quickPanelEmptyText = computed(() => activeQuickPanel.value === 'cart' ? '购物车当前为空。' : '收藏夹当前为空。')
const displayProducts = computed(() => {
  const merged = [...homePage.value.featuredProducts, ...homePage.value.dealProducts]
  return merged.slice(0, HOME_DISPLAY_LIMITS.hotSellerProducts)
})
const displayBanners = computed<DisplayBannerItem[]>(() => {
  return homePage.value.banners.map((banner, index) => {
    const poolImage = pickRealImage(index)
    const preferredImage = isHomeFallbackImage(banner.image) ? '' : banner.image

    return {
      ...banner,
      image: preferredImage || poolImage || fallbackBannerImage,
      fallbackImage: poolImage || fallbackBannerImage,
    }
  })
})
const countdownLabel = computed(() => `${countdown.h}:${countdown.m}:${countdown.s}`)
const footerDescription = computed(() => `${homePage.value.siteName} · 跨境批发与零售一体化前台商城，统一承接活动、搜索、分类与商品详情。`)
const bannerTrackStyle = computed(() => ({ transform: `translateX(-${activeBanner.value * 100}%)` }))

const marketingRoutes = computed<MarketingRouteItem[]>(() => [
  { path: '/activity', name: '活动中心', note: '聚合秒杀/拼团/券包' },
  { path: '/seckill', name: '秒杀会场', note: '限时抢购专题页' },
  { path: '/combination', name: '拼团会场', note: '公开拼团活动页' },
  { path: '/coupons', name: '领券中心', note: '优惠券集中领取页' },
  { path: '/distribution', name: '分销中心', note: '分销招募与佣金页' },
  { path: '/b2b', name: 'B2B 批发', note: '企业批发独立入口' },
])

const heroSideCards = computed(() => [
  {
    tag: 'LIMITED TIME',
    title: 'Activity Center',
    subtitle: 'Group Buy / Bargain / Cashback',
    image: displayBanners.value[0]?.image || pickRealImage(0) || fallbackHeroSideImages[0],
    fallbackImage: pickRealImage(0) || fallbackHeroSideImages[0],
  },
  {
    tag: 'EARN COMMISSION',
    title: 'Become a Distributor',
    subtitle: 'Commission / Easy Earnings',
    image: displayBanners.value[1]?.image || pickRealImage(1) || fallbackHeroSideImages[1],
    fallbackImage: pickRealImage(1) || fallbackHeroSideImages[1],
  },
  {
    tag: 'NEW ARRIVALS',
    title: 'New Product Launch',
    subtitle: homePage.value.featuredProducts[0]?.name || 'Fresh picks every day',
    image: homePage.value.featuredProducts[0]?.image || fallbackHeroSideImages[2],
    fallbackImage: fallbackHeroSideImages[2],
  },
  {
    tag: 'B2B WHOLESALE',
    title: 'Upgrade to 企业批发',
    subtitle: '专享批发低价 · 专属客服',
    image: homePage.value.dealProducts[0]?.image || fallbackHeroSideImages[3],
    fallbackImage: fallbackHeroSideImages[3],
  },
  {
    tag: 'HOW TO SAVE MORE',
    title: 'Invite & Earn Cash',
    subtitle: '砍价 · 拼团 · 邀请返现',
    image: homePage.value.seckillProducts[1]?.image || fallbackHeroSideImages[4],
    fallbackImage: fallbackHeroSideImages[4],
  },
  {
    tag: 'HOT SELLERS',
    title: 'Trending Now',
    subtitle: homePage.value.dealProducts[0]?.name || '平台热卖专区',
    image: homePage.value.dealProducts[1]?.image || fallbackHeroSideImages[5],
    fallbackImage: fallbackHeroSideImages[5],
  },
])

let countdownTimer: ReturnType<typeof setInterval> | null = null
let bannerTimer: ReturnType<typeof setInterval> | null = null

function pickRealImage(index: number): string {
  if (!realImagePool.value.length) {
    return ''
  }

  return realImagePool.value[index % realImagePool.value.length] || ''
}

function goTo(path: string): void {
  categoryMenuOpen.value = false
  activeQuickPanel.value = null
  router.push(path)
}

function goToLogin(): void {
  goTo(`/login?redirect=${encodeURIComponent('/')}`)
}

function handleImageError(event: Event, fallbackSrc: string): void {
  const image = event.target as HTMLImageElement | null
  if (!image || !fallbackSrc || image.dataset.fallbackApplied === '1') {
    return
  }

  image.dataset.fallbackApplied = '1'
  image.src = fallbackSrc
}

function goToProduct(productId: number): void {
  router.push(`/product/${productId}`)
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

function nextBanner(): void {
  if (!homePage.value.banners.length) {
    return
  }

  activeBanner.value = (activeBanner.value + 1) % homePage.value.banners.length
}

function previousBanner(): void {
  if (!homePage.value.banners.length) {
    return
  }

  activeBanner.value = (activeBanner.value - 1 + homePage.value.banners.length) % homePage.value.banners.length
}

function startCountdown(): void {
  let total = 8 * 3600 + 42 * 60 + 15

  countdownTimer = setInterval(() => {
    total = Math.max(0, total - 1)
    countdown.h = String(Math.floor(total / 3600)).padStart(2, '0')
    countdown.m = String(Math.floor((total % 3600) / 60)).padStart(2, '0')
    countdown.s = String(total % 60).padStart(2, '0')
  }, 1000)
}

function startBannerRotation(): void {
  bannerTimer = setInterval(() => {
    nextBanner()
  }, 4000)
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

function groupBuyMembers(product: { sales: number }): number {
  return Math.max(2, Math.min(9, (product.sales % 7) + 2))
}

function groupBuyTarget(product: { stock: number }): number {
  return Math.max(groupBuyMembers(product) + 1, Math.min(10, (product.stock % 5) + 6))
}

function groupBuySave(product: { price: string; originalPrice: string }): string {
  const price = Number(product.price)
  const originalPrice = Number(product.originalPrice)
  return Math.max(0, originalPrice - price).toFixed(2)
}

function groupBuyProgress(product: { sales: number; stock: number }): number {
  const members = groupBuyMembers(product)
  const target = groupBuyTarget(product)
  return Math.round((members / target) * 100)
}

function groupBuyRemaining(product: { sales: number; stock: number }): string {
  const hours = String((product.sales % 6) + 1)
  const minutes = String((product.stock % 50) + 10).padStart(2, '0')
  return `${hours}h ${minutes}m`
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

onMounted(async () => {
  await Promise.all([
    loadHomePage(true),
    refreshSession(true),
  ])
  startCountdown()
  startBannerRotation()
  window.addEventListener('scroll', handleScroll, { passive: true })
})

onUnmounted(() => {
  if (countdownTimer) {
    clearInterval(countdownTimer)
  }

  if (bannerTimer) {
    clearInterval(bannerTimer)
  }

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

.main-content {
  max-width: 1446px;
  margin: 0 auto;
  background: #fff;
}

.hero-section { padding: 20px 0; background: #fff; }
.hero-inner {
  display: flex;
  gap: 14px;
  align-items: stretch;
  height: 300px;
}

.hero-left,
.hero-right {
  width: 280px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.hero-side-banner {
  position: relative;
  flex: 1;
  border-radius: 4px;
  overflow: hidden;
  display: block;
  background: #f0f0f0;
  cursor: pointer;
}

.hero-side-banner img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.hero-side-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.6) 0%, rgba(0, 0, 0, 0.05) 50%, transparent 100%);
}

.hero-side-text {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 12px 14px;
  color: #fff;
  z-index: 1;
  text-align: left;
}

.hero-side-tag { font-size: 9px; font-weight: 700; letter-spacing: 1.5px; opacity: 0.85; display: block; }
.hero-side-title { font-size: 14px; font-weight: 800; display: block; line-height: 1.25; margin: 3px 0 2px; letter-spacing: 0.3px; white-space: pre-line; }
.hero-side-price { font-size: 11px; font-weight: 500; display: block; opacity: 0.9; }
.promo-banner { border: 1px solid #eee; }
.promo-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  background: #e60023;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 2px;
  z-index: 2;
  letter-spacing: 0.5px;
}

.hero-carousel {
  flex: 1;
  position: relative;
  border-radius: 4px;
  overflow: hidden;
}

.carousel-track {
  display: flex;
  transition: transform 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  height: 100%;
}

.carousel-slide {
  min-width: 100%;
  position: relative;
  display: block;
  height: 100%;
  cursor: pointer;
}

.carousel-slide img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.carousel-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 24px 32px;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.65), transparent);
  color: #fff;
  text-align: left;
}

.carousel-tag { font-size: 10px; font-weight: 700; letter-spacing: 2px; opacity: 0.9; display: block; }
.carousel-title { font-size: 28px; font-weight: 800; margin: 6px 0 6px; line-height: 1.1; letter-spacing: -0.5px; }
.carousel-sub { font-size: 13px; opacity: 0.85; display: block; margin-bottom: 12px; }
.carousel-btn {
  display: inline-flex;
  background: #fff;
  color: #111;
  padding: 8px 20px;
  border-radius: 3px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.carousel-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background: rgba(255, 255, 255, 0.95);
  width: 36px;
  height: 36px;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #333;
  z-index: 5;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
}

.carousel-arrow-prev { left: 12px; }
.carousel-arrow-next { right: 12px; }

.carousel-dots {
  position: absolute;
  bottom: 12px;
  right: 20px;
  display: flex;
  gap: 5px;
  z-index: 5;
}

.carousel-dot {
  width: 6px;
  height: 6px;
  border-radius: 3px;
  background: rgba(255, 255, 255, 0.5);
  cursor: pointer;
  transition: all 0.3s;
}

.carousel-dot.active { background: #fff; width: 20px; }

.category-grid-section { padding: 28px 0; background: #fff; border-bottom: 1px solid #f0f0f0; }
.section-inner { max-width: 1446px; margin: 0 auto; padding: 0 16px; }
.category-grid-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}

.category-grid-kicker {
  display: block;
  margin-bottom: 4px;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1px;
  text-transform: uppercase;
  color: #94a3b8;
}

.category-grid-title {
  margin: 0;
  font-size: 24px;
  font-weight: 800;
  color: #111827;
}

.category-grid-more {
  font-size: 12px;
  font-weight: 700;
  color: #111827;
  cursor: pointer;
}

.category-grid { display: grid; grid-template-columns: repeat(8, 1fr); gap: 16px; }

.cat-icon-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  color: #333;
  cursor: pointer;
  padding: 12px 10px;
  border-radius: 18px;
  background: linear-gradient(180deg, #fff 0%, #fafafa 100%);
  border: 1px solid #f1f5f9;
  transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
}

.cat-icon-item:hover {
  transform: translateY(-2px);
  border-color: #e2e8f0;
  box-shadow: 0 14px 24px rgba(15, 23, 42, 0.08);
}

.cat-icon-img {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  overflow: hidden;
  background: #f5f5f5;
  border: 2px solid #eee;
}

.cat-icon-img img { width: 100%; height: 100%; object-fit: cover; }
.cat-icon-name { font-size: 11px; font-weight: 500; text-align: center; color: #444; letter-spacing: 0.2px; }

.activity-section { padding: 24px 0; background: #fafafa; }
.activity-grid-v2 { display: grid; grid-template-columns: 45fr 30fr 25fr; gap: 16px; align-items: stretch; }
.activity-card-v2 {
  background: #fff;
  border-radius: 4px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  border: 1px solid #eee;
  min-height: 400px;
}

.card-header-v2 {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 16px 12px;
  border-bottom: 1px solid #f0f0f0;
}

.card-title-group { display: flex; align-items: center; gap: 8px; }
.card-title { font-size: 14px; font-weight: 700; color: #111; letter-spacing: 0.3px; }
.countdown-v2 {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  color: #e60023;
  font-weight: 600;
  background: #fff0f0;
  padding: 4px 10px;
  border-radius: 3px;
}

.flash-products-v2 { display: flex; gap: 16px; padding: 16px; flex: 1; align-items: flex-start; }
.flash-item { flex: 1; display: flex; flex-direction: column; gap: 6px; cursor: pointer; text-align: left; }
.flash-img-wrap { position: relative; aspect-ratio: 1; border-radius: 4px; overflow: hidden; background: #f5f5f5; }
.flash-img-wrap img { width: 100%; height: 100%; object-fit: cover; }
.flash-off {
  position: absolute;
  top: 6px;
  left: 6px;
  background: #e60023;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  padding: 2px 5px;
  border-radius: 2px;
}
.flash-info { display: flex; flex-direction: column; gap: 3px; }
.flash-name { font-size: 11px; color: #444; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.4; }
.flash-price { font-size: 15px; font-weight: 700; color: #111; }
.flash-old { font-size: 11px; color: #999; text-decoration: line-through; }
.card-more-v2 {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  padding: 12px;
  font-size: 12px;
  font-weight: 600;
  color: #e60023;
  border-top: 1px solid #f0f0f0;
  margin-top: auto;
  letter-spacing: 0.3px;
  cursor: pointer;
}

.card-more-v2:hover { background: #fff8f8; }
.trending-list-v2 { display: flex; flex-direction: column; gap: 0; padding: 8px 0; flex: 1; }
.trending-row {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 16px;
  transition: background 0.2s;
  cursor: pointer;
  text-align: left;
}

.trending-row:hover { background: #fafafa; }
.trend-rank { font-size: 14px; font-weight: 800; color: #ccc; min-width: 20px; text-align: center; }
.trend-rank.top { color: #e60023; }
.trending-row img { width: 44px; height: 44px; border-radius: 6px; object-fit: cover; background: #f5f5f5; flex-shrink: 0; }
.trend-info { flex: 1; display: flex; flex-direction: column; gap: 2px; min-width: 0; }
.trend-name { font-size: 11px; font-weight: 600; color: #333; display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; }
.trend-sales { font-size: 11px; color: #999; }
.trend-price { font-size: 13px; font-weight: 800; color: #222; }
.card-see-all { font-size: 11px; font-weight: 600; color: #e60023; cursor: pointer; }

.card-groupbuy { border: 1px solid #e0e0e0; }
.groupbuy-live-tag {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 10px;
  font-weight: 700;
  color: #fff;
  background: #e60023;
  padding: 3px 8px;
  border-radius: 3px;
}

.groupbuy-list-v2 { display: flex; flex-direction: column; gap: 0; padding: 8px 0; flex: 1; overflow: hidden; }
.groupbuy-row {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 16px;
  transition: background 0.2s;
  border-bottom: 1px solid #f5f5f5;
  cursor: pointer;
  text-align: left;
}

.groupbuy-row:last-child { border-bottom: none; }
.groupbuy-row:hover { background: #fff5f5; }
.groupbuy-img-wrap { position: relative; flex-shrink: 0; width: 52px; height: 52px; border-radius: 6px; overflow: hidden; background: #f5f5f5; }
.groupbuy-img-wrap img { width: 100%; height: 100%; object-fit: cover; }
.groupbuy-count {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(0, 0, 0, 0.6);
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  text-align: center;
  padding: 2px;
}

.groupbuy-info { flex: 1; display: flex; flex-direction: column; gap: 2px; min-width: 0; }
.groupbuy-title { font-size: 11px; font-weight: 600; color: #333; display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; }
.groupbuy-price-row { display: flex; align-items: center; gap: 6px; }
.groupbuy-price { font-size: 13px; font-weight: 800; color: #e60023; }
.groupbuy-save { font-size: 10px; color: #999; font-weight: 500; }
.groupbuy-progress { height: 3px; background: #f0f0f0; border-radius: 2px; overflow: hidden; margin: 2px 0; }
.groupbuy-bar { height: 100%; background: #e60023; border-radius: 2px; }
.groupbuy-status { font-size: 10px; color: #666; }
.groupbuy-join-btn {
  flex-shrink: 0;
  background: #e60023;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  padding: 7px 12px;
  border-radius: 3px;
}

.products-section { padding: 24px 0 40px; background: #fff; }
.section-title-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; }
.section-title { font-size: 24px; font-weight: 800; color: #111; letter-spacing: -0.3px; }
.section-more { font-size: 12px; font-weight: 700; color: #111; cursor: pointer; }
.product-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 16px; }
.product-card-wrap { display: flex; flex-direction: column; gap: 8px; }
.product-card {
  display: flex;
  flex-direction: column;
  border: 1px solid #eee;
  border-radius: 4px;
  overflow: hidden;
  background: #fff;
  cursor: pointer;
  text-align: left;
}

.product-img { position: relative; aspect-ratio: 3 / 4; background: #f5f5f5; overflow: hidden; }
.product-img img { width: 100%; height: 100%; object-fit: cover; display: block; }
.product-tag {
  position: absolute;
  top: 10px;
  left: 10px;
  background: #111;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  padding: 3px 6px;
  border-radius: 2px;
}

.product-wish {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.92);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
}

.product-info { padding: 12px; }
.product-name {
  font-size: 12px;
  line-height: 1.5;
  color: #333;
  min-height: 36px;
  margin: 0 0 8px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.product-price-row { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.product-price { font-size: 16px; font-weight: 800; color: #111; }
.product-old-price { font-size: 11px; color: #999; text-decoration: line-through; }
.product-off { font-size: 10px; color: #e60023; font-weight: 700; }

.b2b-price-btn {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  padding: 9px 12px;
  border: 1px solid #e8d89a;
  border-radius: 4px;
  background: #fffdf5;
  color: #6a4a00;
  cursor: pointer;
}

.b2b-price-icon { font-size: 14px; }
.b2b-price-text { font-size: 11px; font-weight: 700; }
.b2b-price-arrow { font-size: 12px; font-weight: 800; }
.load-more { display: flex; justify-content: center; margin-top: 28px; }
.load-more-btn {
  background: #111;
  color: #fff;
  padding: 12px 32px;
  border-radius: 3px;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
}

.main-footer { background: #111; color: #f3f4f6; padding: 36px 0 18px; }
.footer-inner { max-width: 1446px; margin: 0 auto; padding: 0 16px; }
.footer-grid { display: grid; grid-template-columns: 1.1fr 1fr 1.1fr 1fr; gap: 24px; }
.footer-heading { font-size: 14px; font-weight: 800; margin: 0 0 14px; color: #fff; }
.footer-links-list { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 10px; }
.footer-links-list button { color: #cbd5e1; cursor: pointer; text-align: left; }
.footer-distributor-link .distributor-link { color: #fbbf24; font-weight: 700; }
.marketing-route-list { display: flex; flex-direction: column; gap: 10px; }
.marketing-route-item {
  display: flex;
  flex-direction: column;
  gap: 3px;
  padding: 10px 12px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 6px;
  background: rgba(255, 255, 255, 0.03);
  cursor: pointer;
  text-align: left;
}

.marketing-route-name { color: #fff; font-size: 12px; font-weight: 700; }
.marketing-route-note { color: #94a3b8; font-size: 11px; }
.footer-sub-text { margin: 0 0 14px; color: #cbd5e1; line-height: 1.6; font-size: 13px; }
.footer-subscribe { display: flex; gap: 8px; }
.subscribe-input {
  flex: 1;
  min-width: 0;
  height: 40px;
  padding: 0 12px;
  border-radius: 4px;
  border: 1px solid #374151;
  background: #0f172a;
  color: #fff;
}

.subscribe-btn {
  height: 40px;
  padding: 0 14px;
  border-radius: 4px;
  background: #fff;
  color: #111;
  font-weight: 700;
  cursor: pointer;
}

.footer-bottom {
  margin-top: 24px;
  padding-top: 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  display: flex;
  justify-content: space-between;
  gap: 16px;
  font-size: 12px;
  color: #94a3b8;
}

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
