<template>
  <div class="b2b-placeholder">
    <div class="placeholder-inner">
      <div class="placeholder-icon">🏭</div>
      <h1>B2B Wholesale</h1>
      <p>B2B 功能开发中，敬请期待...</p>
      <a href="/b2c" class="back-btn">← 返回 B2C 首页</a>
    </div>
  </div>
</template>

<script setup>
useHead({
  title: 'B2B Wholesale - NFR Platform',
  meta: [{ name: 'description', content: 'B2B Wholesale Portal - Coming Soon' }]
})
</script>

<style scoped>
.b2b-placeholder {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1a1a2e, #16213e);
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}
.placeholder-inner {
  text-align: center;
  color: #fff;
  padding: 40px;
}
.placeholder-icon {
  font-size: 80px;
  margin-bottom: 24px;
}
h1 {
  font-size: 42px;
  font-weight: 900;
  margin-bottom: 16px;
  letter-spacing: -1px;
}
p {
  font-size: 18px;
  color: #aaa;
  margin-bottom: 32px;
}
.back-btn {
  display: inline-block;
  padding: 12px 28px;
  background: #c9a84c;
  color: #111;
  text-decoration: none;
  border-radius: 4px;
  font-weight: 700;
  font-size: 14px;
  letter-spacing: 0.5px;
}
.back-btn:hover {
  background: #e0be6a;
}
</style>
