<template>
  <div class="d-layout">
    <!-- 侧边栏 -->
    <aside class="d-sidebar">
      <!-- Logo -->
      <div class="d-logo">
        <NuxtLink to="/admin" class="d-logo-text">NFR</NuxtLink>
      </div>

      <!-- 导航 -->
      <nav class="d-nav">
        <!-- 控制台 -->
        <NuxtLink to="/admin" class="d-nav-item" :class="{ active: route.path === '/admin' }">
          <span class="d-nav-icon">📊</span>
          <span>控制台</span>
        </NuxtLink>

        <!-- 核心运营 -->
        <div class="d-nav-group">
          <div class="d-nav-label">核心运营</div>

          <div class="d-nav-parent" :class="{ open: openSub === 'products' }" @click="toggle('products')">
            <span class="d-nav-icon">📦</span>
            <span>商品管理</span>
            <span class="d-nav-arrow">{{ openSub === 'products' ? '▲' : '▼' }}</span>
          </div>
          <div class="d-nav-children" v-if="openSub === 'products'">
            <NuxtLink to="/admin/products" class="d-nav-child" :class="{ active: route.path === '/admin/products' }">商品列表</NuxtLink>
            <NuxtLink to="/admin/products/self" class="d-nav-child" :class="{ active: route.path === '/admin/products/self' }">自营管理</NuxtLink>
            <NuxtLink to="/admin/products/1688" class="d-nav-child" :class="{ active: route.path === '/admin/products/1688' }">1688采集</NuxtLink>
            <NuxtLink to="/admin/products/ai-pricing" class="d-nav-child" :class="{ active: route.path === '/admin/products/ai-pricing' }">AI定价</NuxtLink>
            <NuxtLink to="/admin/products/inventory" class="d-nav-child" :class="{ active: route.path === '/admin/products/inventory' }">库存管理</NuxtLink>
          </div>

          <div class="d-nav-parent" :class="{ open: openSub === 'orders' }" @click="toggle('orders')">
            <span class="d-nav-icon">🧾</span>
            <span>订单管理</span>
            <span class="d-nav-arrow">{{ openSub === 'orders' ? '▲' : '▼' }}</span>
            <span class="d-nav-reddot" v-if="5">5</span>
          </div>
          <div class="d-nav-children" v-if="openSub === 'orders'">
            <NuxtLink to="/admin/orders" class="d-nav-child" :class="{ active: route.path === '/admin/orders' }">C端订单</NuxtLink>
            <NuxtLink to="/admin/orders/wholesale" class="d-nav-child" :class="{ active: route.path === '/admin/orders/wholesale' }">B端订单</NuxtLink>
            <NuxtLink to="/admin/orders/security-exception" class="d-nav-child" :class="{ active: route.path === '/admin/orders/security-exception' }">安检异常</NuxtLink>
            <NuxtLink to="/admin/orders/dropship" class="d-nav-child" :class="{ active: route.path === '/admin/orders/dropship' }">1688代发</NuxtLink>
          </div>
        </div>

        <!-- 会员与支付 -->
        <div class="d-nav-group">
          <div class="d-nav-label">会员与支付</div>

          <div class="d-nav-parent" :class="{ open: openSub === 'members' }" @click="toggle('members')">
            <span class="d-nav-icon">👥</span>
            <span>会员管理</span>
            <span class="d-nav-arrow">{{ openSub === 'members' ? '▲' : '▼' }}</span>
          </div>
          <div class="d-nav-children" v-if="openSub === 'members'">
            <NuxtLink to="/admin/members" class="d-nav-child" :class="{ active: route.path === '/admin/members' }">会员列表</NuxtLink>
            <NuxtLink to="/admin/members/certification" class="d-nav-child" :class="{ active: route.path === '/admin/members/certification' }">认证审核</NuxtLink>
            <NuxtLink to="/admin/members/anomaly" class="d-nav-child" :class="{ active: route.path === '/admin/members/anomaly' }">资质异常</NuxtLink>
          </div>

          <NuxtLink to="/admin/payments" class="d-nav-item" :class="{ active: route.path.startsWith('/admin/payments') }">
            <span class="d-nav-icon">💳</span>
            <span>支付管理</span>
          </NuxtLink>

          <NuxtLink to="/admin/contracts" class="d-nav-item" :class="{ active: route.path.startsWith('/admin/contracts') }">
            <span class="d-nav-icon">📄</span>
            <span>合同管理</span>
          </NuxtLink>
        </div>

        <!-- 客户运营 -->
        <div class="d-nav-group">
          <div class="d-nav-label">客户运营</div>

          <div class="d-nav-parent" :class="{ open: openSub === 'support' }" @click="toggle('support')">
            <span class="d-nav-icon">🎧</span>
            <span>客服系统</span>
            <span class="d-nav-arrow">{{ openSub === 'support' ? '▲' : '▼' }}</span>
            <span class="d-nav-reddot" v-if="3">3</span>
          </div>
          <div class="d-nav-children" v-if="openSub === 'support'">
            <NuxtLink to="/admin/support" class="d-nav-child" :class="{ active: route.path === '/admin/support' }">工作台</NuxtLink>
            <NuxtLink to="/admin/support/tickets" class="d-nav-child" :class="{ active: route.path === '/admin/support/tickets' }">工单列表</NuxtLink>
            <NuxtLink to="/admin/support/satisfaction" class="d-nav-child" :class="{ active: route.path === '/admin/support/satisfaction' }">满意度统计</NuxtLink>
            <NuxtLink to="/admin/support/templates" class="d-nav-child" :class="{ active: route.path === '/admin/support/templates' }">快捷模板</NuxtLink>
            <NuxtLink to="/admin/support/knowledge" class="d-nav-child" :class="{ active: route.path === '/admin/support/knowledge' }">知识库</NuxtLink>
          </div>

          <div class="d-nav-parent" :class="{ open: openSub === 'marketing' }" @click="toggle('marketing')">
            <span class="d-nav-icon">📢</span>
            <span>营销工具</span>
            <span class="d-nav-arrow">{{ openSub === 'marketing' ? '▲' : '▼' }}</span>
          </div>
          <div class="d-nav-children" v-if="openSub === 'marketing'">
            <NuxtLink to="/admin/marketing" class="d-nav-child" :class="{ active: route.path === '/admin/marketing' }">优惠券</NuxtLink>
            <NuxtLink to="/admin/marketing/flash" class="d-nav-child" :class="{ active: route.path === '/admin/marketing/flash' }">限时折扣</NuxtLink>
            <NuxtLink to="/admin/marketing/full-reduction" class="d-nav-child" :class="{ active: route.path === '/admin/marketing/full-reduction' }">满减活动</NuxtLink>
            <NuxtLink to="/admin/marketing/festival" class="d-nav-child" :class="{ active: route.path === '/admin/marketing/festival' }">节日活动</NuxtLink>
            <NuxtLink to="/admin/marketing/viral" class="d-nav-child" :class="{ active: route.path === '/admin/marketing/viral' }">病毒裂变</NuxtLink>
            <NuxtLink to="/admin/marketing/bargain" class="d-nav-child" :class="{ active: route.path === '/admin/marketing/bargain' }">拼多多砍价</NuxtLink>
          </div>
        </div>

        <!-- B端特色 -->
        <div class="d-nav-group">
          <div class="d-nav-label">B端特色</div>

          <div class="d-nav-parent" :class="{ open: openSub === 'distribution' }" @click="toggle('distribution')">
            <span class="d-nav-icon">🏢</span>
            <span>分销管理</span>
            <span class="d-nav-arrow">{{ openSub === 'distribution' ? '▲' : '▼' }}</span>
          </div>
          <div class="d-nav-children" v-if="openSub === 'distribution'">
            <NuxtLink to="/admin/distribution" class="d-nav-child" :class="{ active: route.path === '/admin/distribution' }">分销商列表</NuxtLink>
            <NuxtLink to="/admin/distribution/tiers" class="d-nav-child" :class="{ active: route.path === '/admin/distribution/tiers' }">档位配置</NuxtLink>
            <NuxtLink to="/admin/distribution/settlement" class="d-nav-child" :class="{ active: route.path === '/admin/distribution/settlement' }">结算管理</NuxtLink>
            <NuxtLink to="/admin/distribution/products" class="d-nav-child" :class="{ active: route.path === '/admin/distribution/products' }">商品池</NuxtLink>
            <NuxtLink to="/admin/distribution/applications" class="d-nav-child" :class="{ active: route.path === '/admin/distribution/applications' }">申请审核</NuxtLink>
          </div>

          <NuxtLink to="/admin/custom-orders" class="d-nav-item" :class="{ active: route.path.startsWith('/admin/custom-orders') }">
            <span class="d-nav-icon">🔧</span>
            <span>定制单</span>
          </NuxtLink>
        </div>

        <!-- 数据与系统 -->
        <div class="d-nav-group">
          <div class="d-nav-label">数据与系统</div>

          <NuxtLink to="/admin/reports" class="d-nav-item" :class="{ active: route.path.startsWith('/admin/reports') }">
            <span class="d-nav-icon">📊</span>
            <span>报表中心</span>
          </NuxtLink>

          <NuxtLink to="/admin/llm" class="d-nav-item" :class="{ active: route.path.startsWith('/admin/llm') }">
            <span class="d-nav-icon">🤖</span>
            <span>LLM管理</span>
            <span class="d-nav-reddot" v-if="3">3</span>
          </NuxtLink>

          <NuxtLink to="/admin/notifications" class="d-nav-item" :class="{ active: route.path.startsWith('/admin/notifications') }">
            <span class="d-nav-icon">🔔</span>
            <span>消息通知</span>
          </NuxtLink>

          <NuxtLink to="/admin/permissions" class="d-nav-item" :class="{ active: route.path.startsWith('/admin/permissions') }">
            <span class="d-nav-icon">🔐</span>
            <span>权限管理</span>
          </NuxtLink>

          <NuxtLink to="/admin/settings" class="d-nav-item" :class="{ active: route.path.startsWith('/admin/settings') }">
            <span class="d-nav-icon">⚙️</span>
            <span>系统设置</span>
          </NuxtLink>

          <NuxtLink to="/admin/settings/sites" class="d-nav-item" :class="{ active: route.path.startsWith('/admin/settings/sites') }">
            <span class="d-nav-icon">🌐</span>
            <span>国际站点</span>
          </NuxtLink>
        </div>
      </nav>

      <!-- 用户信息 -->
      <div class="d-user">
        <div class="d-user-avatar">管</div>
        <div class="d-user-info">
          <div class="d-user-name">管理员</div>
          <div class="d-user-role">超级管理员</div>
        </div>
        <button class="d-user-logout" @click="handleLogout" title="退出">↩</button>
      </div>
    </aside>

    <!-- 主内容 -->
    <div class="d-main">
      <!-- 顶栏 -->
      <header class="d-header">
        <div class="d-header-left">
          <span class="d-breadcrumb">
            <NuxtLink to="/admin" class="d-bread-link">首页</NuxtLink>
            <span class="d-bread-sep">/</span>
            <span class="d-bread-cur">{{ pageTitle }}</span>
          </span>
        </div>
        <div class="d-header-right">
          <button class="d-theme-btn" @click="toggleTheme" :title="isDark ? '切换浅色' : '切换深色'">{{ isDark ? '☀️' : '🌙' }}</button>
          <div class="d-mode-toggle">
            <button class="d-mode-btn" :class="{ on: activeMode === 'b2c' }" @click="activeMode = 'b2c'">B2C</button>
            <button class="d-mode-btn" :class="{ on: activeMode === 'b2b' }" @click="activeMode = 'b2b'">B2B</button>
          </div>
          <button class="d-header-icon">🔔</button>
          <button class="d-header-icon">✉️</button>
        </div>
      </header>

      <!-- 页面内容 -->
      <div class="d-body">
        <slot />
      </div>
    </div>
  </div>
</template>

<script setup>
const route = useRoute()
const openSub = ref('products')
const activeMode = ref('b2c')
const isDark = ref(true)

// 主题切换
const toggleTheme = () => {
  isDark.value = !isDark.value
  if (isDark.value) {
    document.body.classList.add('theme-dark')
    document.body.classList.remove('theme-light')
  } else {
    document.body.classList.add('theme-light')
    document.body.classList.remove('theme-dark')
  }
  localStorage.setItem('nfr_theme', isDark.value ? 'dark' : 'light')
}

// 初始化主题
onMounted(() => {
  const saved = localStorage.getItem('nfr_theme')
  if (saved === 'light') {
    isDark.value = false
    document.body.classList.add('theme-light')
  } else {
    document.body.classList.add('theme-dark')
  }
})

const pageTitleMap = {
  '/admin': '',
  '/admin/products': '商品列表',
  '/admin/products/self': '自营商品管理',
  '/admin/products/1688': '1688采集管理',
  '/admin/products/ai-pricing': 'AI定价',
  '/admin/products/inventory': '库存管理',
  '/admin/orders': 'C端订单',
  '/admin/orders/wholesale': 'B端订单',
  '/admin/orders/security-exception': '安检异常',
  '/admin/orders/dropship': '1688代发',
  '/admin/members': '会员列表',
  '/admin/members/certification': '认证审核',
  '/admin/members/anomaly': '资质异常',
  '/admin/payments': '支付管理',
  '/admin/contracts': '合同管理',
  '/admin/support': '客服工作台',
  '/admin/support/tickets': '工单列表',
  '/admin/support/satisfaction': '满意度统计',
  '/admin/support/templates': '快捷模板',
  '/admin/support/knowledge': '知识库',
  '/admin/marketing': '优惠券',
  '/admin/marketing/flash': '限时折扣',
  '/admin/marketing/full-reduction': '满减活动',
  '/admin/marketing/festival': '节日活动',
  '/admin/marketing/viral': '病毒裂变',
  '/admin/marketing/bargain': '拼多多砍价',
  '/admin/distribution': '分销商列表',
  '/admin/distribution/tiers': '档位配置',
  '/admin/distribution/settlement': '结算管理',
  '/admin/distribution/products': '商品池',
  '/admin/distribution/applications': '申请审核',
  '/admin/custom-orders': '定制单列表',
  '/admin/reports': '报表中心',
  '/admin/llm': 'LLM管理',
  '/admin/notifications': '消息通知',
  '/admin/permissions': '权限管理',
  '/admin/settings': '系统设置',
  '/admin/settings/sites': '国际站点管理',
}
const pageTitle = computed(() => pageTitleMap[route.path] || '')

const toggle = (key) => {
  openSub.value = openSub.value === key ? '' : key
}

const handleLogout = () => {
  localStorage.removeItem('nfr_admin_token')
  navigateTo('/admin/login')
}
</script>
