<template>
  <header class="site-header">
    <div class="header-main">
      <div class="container">
        <div class="header-content">
          <!-- Logo -->
          <div class="logo">
            <NuxtLink to="/">NFR</NuxtLink>
          </div>

          <!-- 搜索框 -->
          <div class="search-box">
            <input type="text" placeholder="Search products..." v-model="searchKeyword" @keyup.enter="handleSearch" />
            <button class="search-btn" @click="handleSearch">🔍</button>
          </div>

          <!-- 右侧图标 -->
          <div class="header-icons">
            <div class="header-icon-item" title="Cart">
              <span>🛒</span>
              <span class="cart-count" v-if="cartCount > 0">{{ cartCount }}</span>
            </div>
            <div class="header-icon-item" title="Language">
              <span>🌐</span>
            </div>
            <div class="header-icon-item">
              <NuxtLink to="/login">登录</NuxtLink>
              <span class="divider">|</span>
              <NuxtLink to="/register">注册</NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 主导航 -->
    <nav class="header-nav">
      <div class="container">
        <ul class="nav-list">
          <li><NuxtLink to="/">全部分类</NuxtLink></li>
          <li><NuxtLink to="/category/women">女装</NuxtLink></li>
          <li><NuxtLink to="/category/men">男装</NuxtLink></li>
          <li><NuxtLink to="/category/kids">童装</NuxtLink></li>
          <li><NuxtLink to="/category/beauty">美容</NuxtLink></li>
          <li><NuxtLink to="/category/home">家居</NuxtLink></li>
          <li><NuxtLink to="/category/electronics">电子</NuxtLink></li>
          <li><NuxtLink to="/custom">定制专区</NuxtLink></li>
          <li><NuxtLink to="/wholesale">批发专区</NuxtLink></li>
        </ul>
      </div>
    </nav>
  </header>
</template>

<script setup>
const searchKeyword = ref('')
const cartCount = ref(0)

const handleSearch = () => {
  console.log('搜索:', searchKeyword.value)
}
</script>

<style scoped>
.site-header {
  position: sticky;
  top: 0;
  z-index: 100;
  background: var(--color-bg);
  box-shadow: var(--shadow);
}

.header-main {
  padding: 16px 0;
  border-bottom: 1px solid var(--color-border);
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
}

.logo a {
  font-size: 28px;
  font-weight: 800;
  color: var(--color-primary);
  letter-spacing: 2px;
}

.search-box {
  flex: 1;
  max-width: 600px;
  display: flex;
  border: 2px solid var(--color-primary);
  border-radius: 4px;
  overflow: hidden;
}

.search-box input {
  flex: 1;
  padding: 10px 16px;
  border: none;
  font-size: var(--font-size-base);
}

.search-box .search-btn {
  padding: 10px 20px;
  background: var(--color-primary);
  color: #fff;
  font-size: 16px;
}

.header-icons {
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-icon-item {
  position: relative;
  font-size: var(--font-size-lg);
  cursor: pointer;
}

.cart-count {
  position: absolute;
  top: -6px;
  right: -8px;
  background: var(--color-primary);
  color: #fff;
  font-size: 10px;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.header-icon-item a {
  font-size: var(--font-size-sm);
  color: var(--color-text-light);
}

.header-icon-item a:hover {
  color: var(--color-primary);
}

.divider {
  margin: 0 6px;
  color: var(--color-border);
}

.header-nav {
  background: var(--color-bg);
  padding: 0;
}

.nav-list {
  display: flex;
  gap: 0;
}

.nav-list li a {
  display: block;
  padding: 12px 20px;
  font-size: var(--font-size-base);
  color: var(--color-text);
  font-weight: 500;
  transition: var(--transition);
  border-bottom: 2px solid transparent;
}

.nav-list li a:hover {
  color: var(--color-primary);
  border-bottom-color: var(--color-primary);
}
</style>
