<template>
  <div class="home-page">
    <SiteHeader />
    <main class="home-main">
      <HomeBanner />
      <ActivityBlocks />
      <ProductGrid title="今日推荐" />
      <ProductGrid title="新品上架" />
    </main>
    <SiteFooter />
  </div>
</template>

<script setup>
// SEO meta
useHead({
  title: 'NFR - Global Cross-border E-commerce Platform',
  meta: [
    { name: 'description', content: 'Shop the latest fashion, electronics, home goods and more at NFR. Wholesale and retail available.' }
  ]
})
</script>

<style scoped>
.home-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.home-main {
  flex: 1;
}
</style>
