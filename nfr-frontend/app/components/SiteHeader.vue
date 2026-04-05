<template>
  <div class="site-wrapper">
    <!-- ========== 1. 顶部政策条 ========== -->
    <div class="top-policy">
      <div class="policy-inner">
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12l5 5L20 7"/></svg>
          Free Shipping <em>*On orders $49+</em>
        </span>
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12a9 9 0 1 0 18 0 9 9 0 0 0-18 0"/><path d="M3 12l4-4m0 0l4 4m-4-4v8"/></svg>
          Free Returns <em>*T&amp;Cs apply</em>
        </span>
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          Secure Payment
        </span>
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 3"/></svg>
          No Hidden Fees <em>*Tariff FAQ</em>
        </span>
      </div>
    </div>

    <!-- ========== 2. 主导航头 (粘性) ========== -->
    <header class="main-header" :class="{ scrolled: isScrolled }">
      <div class="header-inner">
        <a href="/b2c" class="logo">NFR</a>

        <!-- B2B 尊贵批发按钮 -->
        <a href="/b2b" class="b2b-btn" title="B2B Wholesale - Business Account">
          <svg class="b2b-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#c9a84c" stroke-width="2">
            <path d="M2 20a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8l-7 5V8l-7 5V8l-7 5V8l-7 5V8l-7 5v12z"/>
          </svg>
          <span class="b2b-text">
            <span class="b2b-main">B2B Wholesale</span>
            <span class="b2b-sub">Business Account</span>
          </span>
          <span class="b2b-vip">VIP</span>
        </a>

        <!-- 搜索框 -->
        <div class="search-bar">
          <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
          <input v-model="searchQuery" type="text" placeholder="Search for 10,000+ products..." class="search-input" @keyup.enter="doSearch" />
          <button class="search-btn" @click="doSearch">Search</button>
        </div>

        <!-- 用户操作区 -->
        <div class="header-actions">
          <button class="action-btn" title="Wishlist">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
          </button>
          <button class="action-btn" title="Cart" @click="openCart">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            <span class="action-badge">{{ totalItems }}</span>
          </button>
          <button v-if="!isLoggedIn" class="signin-btn" title="Sign In">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            <span>Sign In</span>
          </button>
          <div v-else class="user-panel">
            <div class="user-avatar-wrap">
              <img :src="user.avatar" class="user-avatar" :alt="user.name" />
              <div class="identity-badges">
                <span v-if="user.identities.includes('c')" class="id-badge id-c" title="C端会员">C</span>
                <span v-if="user.identities.includes('b')" class="id-badge id-b" title="B端批发商">B</span>
                <span v-if="user.identities.includes('d')" class="id-badge id-d" title="分销商">D</span>
              </div>
              <div v-if="user.identities.length >= 2" class="avatar-glow" :class="'glow-' + user.identities.length"></div>
            </div>
            <div class="user-info-col">
              <span class="user-name">{{ user.name }}</span>
              <div class="user-level">
                <span v-if="user.level === 'gold'" class="level-badge gold">金牌</span>
                <span v-else-if="user.level === 'silver'" class="level-badge silver">银牌</span>
                <span v-else class="level-badge bronze">铜牌</span>
                <span v-if="user.unread > 0" class="msg-dot">{{ user.unread }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- ========== 3. 分类导航横条 ========== -->
    <nav class="category-nav">
      <div class="category-nav-inner">
        <button class="cat-item" :class="{ active: !route.query.cat }" @click="setCategory('')">New In</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Sale' }" @click="setCategory('Sale')">Sale</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Women' }" @click="setCategory('Women')">Women</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Men' }" @click="setCategory('Men')">Men</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Kids' }" @click="setCategory('Kids')">Kids</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Beauty' }" @click="setCategory('Beauty')">Beauty</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Shoes' }" @click="setCategory('Shoes')">Shoes &amp; Bags</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Home' }" @click="setCategory('Home')">Home &amp; Living</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Electronics' }" @click="setCategory('Electronics')">Electronics</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Sports' }" @click="setCategory('Sports')">Sports</button>
        <button class="cat-item" :class="{ active: route.query.cat === 'Jewelry' }" @click="setCategory('Jewelry')">Jewelry</button>
        <span class="nav-divider"></span>
        <button class="cat-special" @click="goActivity">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="margin-right:4px;vertical-align:middle"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
          活动中心
        </button>
        <button class="cat-distributor" @click="goDistributor">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="margin-right:4px;vertical-align:middle"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          分销商
        </button>
      </div>
    </nav>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCart } from '~/composables/useCart'

const route = useRoute()
const router = useRouter()

const isScrolled = ref(false)
const handleScroll = () => { isScrolled.value = window.scrollY > 20 }
onMounted(() => window.addEventListener('scroll', handleScroll, { passive: true }))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))

const isLoggedIn = ref(false)
const user = ref({ name: 'Sarah Chen', avatar: 'https://picsum.photos/seed/avatar1/80/80', level: 'gold', identities: ['c', 'b', 'd'], unread: 3 })

const searchQuery = ref('')
const doSearch = () => { if (searchQuery.value.trim()) router.push({ path: '/b2c/search', query: { q: searchQuery.value } }) }

const goActivity = () => router.push('/activity')
const goDistributor = () => router.push('/distributor')
const setCategory = (cat) => router.push({ path: '/b2c/search', query: cat ? { cat } : {} })

const { items, openCart } = useCart()
const totalItems = computed(() => items.value.reduce((s, i) => s + i.quantity, 0))
</script>

<style scoped>
* { box-sizing: border-box; }
.site-wrapper { background: #fff; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }

.top-policy { background: #fff; border-bottom: 1px solid #eee; }
.policy-inner { max-width: 1446px; margin: 0 auto; display: flex; justify-content: center; align-items: center; height: 38px; }
.policy-item { display: flex; align-items: center; gap: 6px; padding: 0 32px; font-size: 12px; color: #555; white-space: nowrap; border-right: 1px solid #eee; letter-spacing: 0.2px; }
.policy-item:last-child { border-right: none; }
.policy-item svg { color: #222; flex-shrink: 0; }
.policy-item em { color: #999; font-style: normal; font-size: 11px; }

.main-header { background: #fff; border-bottom: 1px solid #eee; position: sticky; top: 0; z-index: 100; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
.main-header.scrolled { box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
.header-inner { max-width: 1446px; margin: 0 auto; display: flex; align-items: center; gap: 24px; padding: 12px 0; }
.logo { font-size: 28px; font-weight: 900; color: #111; text-decoration: none; letter-spacing: -2px; flex-shrink: 0; font-style: italic; }

.b2b-btn { display: flex; align-items: center; gap: 8px; padding: 7px 16px; background: #fff; border: 1.5px solid #c9a84c; border-radius: 4px; text-decoration: none; flex-shrink: 0; transition: all 0.2s; box-shadow: 0 1px 3px rgba(201,168,76,0.15); }
.b2b-btn:hover { background: #fffdf5; box-shadow: 0 2px 8px rgba(201,168,76,0.25); transform: translateY(-1px); }
.b2b-icon { flex-shrink: 0; }
.b2b-text { display: flex; flex-direction: column; line-height: 1.2; }
.b2b-main { font-size: 12px; font-weight: 800; color: #111; letter-spacing: 0.3px; }
.b2b-sub { font-size: 9px; color: #777; font-weight: 500; }
.b2b-vip { font-size: 8px; font-weight: 900; color: #c9a84c; background: #f9f7f0; padding: 2px 5px; border-radius: 3px; letter-spacing: 1px; border: 1px solid #e8d89a; }

.search-bar { flex: 1; display: flex; align-items: center; background: #f7f7f7; border: 1px solid #eee; border-radius: 4px; padding: 0 4px 0 14px; max-width: 520px; height: 38px; transition: border-color 0.2s; }
.search-bar:focus-within { border-color: #ccc; background: #fff; }
.search-icon { color: #999; flex-shrink: 0; }
.search-input { flex: 1; border: none; background: transparent; padding: 0 10px; font-size: 13px; outline: none; color: #333; }
.search-input::placeholder { color: #bbb; }
.search-btn { background: #111; color: #fff; border: none; padding: 8px 18px; border-radius: 3px; font-size: 13px; font-weight: 600; cursor: pointer; height: 30px; letter-spacing: 0.3px; white-space: nowrap; }
.search-btn:hover { background: #333; }

.header-actions { display: flex; align-items: center; gap: 2px; flex-shrink: 0; margin-left: auto; }
.action-btn { position: relative; display: flex; align-items: center; justify-content: center; width: 38px; height: 38px; background: none; border: none; cursor: pointer; color: #444; border-radius: 4px; transition: background 0.2s; }
.action-btn:hover { background: #f5f5f5; }
.action-badge { position: absolute; top: 4px; right: 4px; background: #111; color: #fff; font-size: 9px; font-weight: 700; min-width: 16px; height: 16px; border-radius: 8px; display: flex; align-items: center; justify-content: center; padding: 0 3px; }
.signin-btn { display: flex; align-items: center; gap: 6px; padding: 8px 16px; background: #111; color: #fff; border: none; border-radius: 3px; font-size: 13px; font-weight: 600; cursor: pointer; margin-left: 6px; letter-spacing: 0.3px; height: 38px; }
.signin-btn:hover { background: #333; }
.user-panel { display: flex; align-items: center; gap: 10px; padding: 4px 12px 4px 4px; background: #fafafa; border: 1px solid #eee; border-radius: 28px; cursor: pointer; margin-left: 4px; }
.user-panel:hover { background: #f0f0f0; }
.user-avatar-wrap { position: relative; flex-shrink: 0; }
.user-avatar { width: 32px; height: 32px; border-radius: 50%; object-fit: cover; border: 2px solid #f0f0f0; }
.identity-badges { position: absolute; bottom: -3px; right: -5px; display: flex; flex-direction: row-reverse; gap: 1px; }
.id-badge { font-size: 8px; font-weight: 800; width: 14px; height: 14px; border-radius: 3px; display: flex; align-items: center; justify-content: center; border: 1px solid rgba(0,0,0,0.15); }
.id-c { background: #e76f51; color: #fff; }
.id-b { background: linear-gradient(135deg, #c9a84c, #f0d68a); color: #4a3000; }
.id-d { background: #6c5ce7; color: #fff; }
.avatar-glow { position: absolute; inset: -3px; border-radius: 50%; pointer-events: none; }
.glow-2 { background: #c9a84c; opacity: 0.4; filter: blur(3px); }
.glow-3 { background: linear-gradient(135deg, #c9a84c, #6c5ce7); opacity: 0.4; filter: blur(3px); }
.user-info-col { display: flex; flex-direction: column; gap: 2px; }
.user-name { font-size: 12px; font-weight: 600; color: #222; max-width: 80px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.user-level { display: flex; align-items: center; gap: 5px; }
.level-badge { font-size: 10px; font-weight: 700; }
.level-badge.gold { color: #c9a84c; }
.level-badge.silver { color: #adb5bd; }
.level-badge.bronze { color: #cd7f32; }
.msg-dot { background: #e60023; color: #fff; font-size: 9px; font-weight: 700; min-width: 15px; height: 15px; border-radius: 8px; display: flex; align-items: center; justify-content: center; padding: 0 3px; }

.category-nav { background: #fff; border-bottom: 2px solid #111; overflow-x: auto; scrollbar-width: none; }
.category-nav::-webkit-scrollbar { display: none; }
.category-nav-inner { max-width: 1446px; margin: 0 auto; display: flex; align-items: center; }
.cat-item { padding: 12px 22px; font-size: 13px; font-weight: 500; color: #555; background: none; border: none; cursor: pointer; border-bottom: 2px solid transparent; margin-bottom: -2px; white-space: nowrap; letter-spacing: 0.2px; }
.cat-item:hover { color: #111; }
.cat-item.active { color: #111; border-bottom-color: #111; font-weight: 600; }
.nav-divider { width: 1px; height: 18px; background: #ddd; margin: 0 6px; flex-shrink: 0; }
.cat-special { background: #e60023; color: #fff; border-radius: 3px; padding: 5px 14px; margin: 0 4px; font-size: 12px; font-weight: 600; border: none; cursor: pointer; letter-spacing: 0.3px; }
.cat-special:hover { background: #c5001e; }
.cat-special svg { vertical-align: middle; }
.cat-distributor { background: #2a2a6a; color: #fff; border-radius: 3px; padding: 5px 14px; margin: 0 4px; font-size: 12px; font-weight: 600; border: none; cursor: pointer; letter-spacing: 0.3px; }
.cat-distributor:hover { background: #1a1a50; }
.cat-distributor svg { vertical-align: middle; }

@media (max-width: 900px) { .b2b-btn { display: none; } }
@media (max-width: 600px) {
  .policy-inner { flex-wrap: wrap; height: auto; padding: 4px 0; }
  .policy-item { padding: 4px 12px; border-right: none; border-bottom: 1px solid #eee; flex: 1 1 50%; font-size: 11px; }
  .header-inner { flex-wrap: wrap; gap: 8px; padding: 8px 12px; }
  .logo { font-size: 24px; }
  .b2b-btn { display: none; }
  .search-bar { max-width: 100%; width: 100%; }
  .signin-btn { padding: 6px 12px; font-size: 12px; }
  .user-panel { padding: 2px 8px 2px 2px; }
  .user-name { font-size: 11px; max-width: 60px; }
  .category-nav-inner { padding: 0 8px; }
  .cat-item { padding: 10px 12px; font-size: 12px; }
  .cat-special, .cat-distributor { padding: 5px 10px; font-size: 11px; }
  .nav-divider { margin: 0 4px; }
}
</style>
