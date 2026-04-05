<template>
  <div class="product-section">
    <div class="container">
      <!-- 标题栏 -->
      <div class="section-header">
        <h2>{{ title }}</h2>
        <NuxtLink to="/products" class="more-link">查看更多 ›</NuxtLink>
      </div>

      <!-- 商品网格 -->
      <div class="products-grid">
        <div
          v-for="product in products"
          :key="product.id"
          class="product-card"
          @click="goToDetail(product)"
        >
          <div class="product-image">
            <div class="image-placeholder" :style="{ background: product.color }">
              <span>{{ product.name }}</span>
            </div>
            <span v-if="product.tag" class="product-tag">{{ product.tag }}</span>
          </div>
          <div class="product-info">
            <h4 class="product-name">{{ product.name }}</h4>
            <div class="product-price">
              <span class="price-current">{{ product.currency }}{{ product.price }}</span>
              <span v-if="product.originalPrice" class="price-original">
                {{ product.currency }}{{ product.originalPrice }}
              </span>
            </div>
            <div class="product-sales">{{ product.sales }} sold</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    default: '今日推荐'
  },
  products: {
    type: Array,
    default: () => []
  }
})

const products = [
  { id: 1, name: 'Summer Dress 2024 New', price: '19.99', originalPrice: '39.99', currency: '$', sales: 1250, tag: 'HOT', color: '#ff6b6b' },
  { id: 2, name: 'Casual T-Shirt Men', price: '12.99', originalPrice: '24.99', currency: '$', sales: 890, tag: '', color: '#4834d4' },
  { id: 3, name: 'Wireless Earbuds Pro', price: '29.99', originalPrice: '', currency: '$', sales: 2100, tag: 'NEW', color: '#00b894' },
  { id: 4, name: 'Home Decor Set', price: '45.99', originalPrice: '89.99', currency: '$', sales: 456, tag: 'SALE', color: '#f9ca24' },
  { id: 5, name: 'Kids Toy Bundle', price: '18.99', originalPrice: '', currency: '$', sales: 780, tag: '', color: '#6c5ce7' },
]

const goToDetail = (product) => {
  console.log('查看商品:', product.id)
}
</script>

<style scoped>
.product-section {
  padding: 40px 0;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 2px solid var(--color-border);
}

.section-header h2 {
  font-size: 24px;
  color: var(--color-text);
}

.more-link {
  color: var(--color-primary);
  font-size: var(--font-size-base);
}

.more-link:hover {
  text-decoration: underline;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
}

.product-card {
  background: var(--color-bg);
  border-radius: 8px;
  overflow: hidden;
  box-shadow: var(--shadow);
  cursor: pointer;
  transition: var(--transition);
}

.product-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.12);
}

.product-image {
  position: relative;
  aspect-ratio: 3/4;
  overflow: hidden;
}

.image-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 14px;
  text-align: center;
  padding: 10px;
}

.product-tag {
  position: absolute;
  top: 8px;
  left: 8px;
  padding: 4px 8px;
  background: var(--color-primary);
  color: #fff;
  font-size: 10px;
  font-weight: 700;
  border-radius: 2px;
}

.product-info {
  padding: 12px;
}

.product-name {
  font-size: var(--font-size-sm);
  color: var(--color-text);
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-price {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}

.price-current {
  font-size: var(--font-size-lg);
  font-weight: 700;
  color: var(--color-primary);
}

.price-original {
  font-size: var(--font-size-sm);
  color: var(--color-text-light);
  text-decoration: line-through;
}

.product-sales {
  font-size: var(--font-size-sm);
  color: var(--color-text-light);
}
</style>
