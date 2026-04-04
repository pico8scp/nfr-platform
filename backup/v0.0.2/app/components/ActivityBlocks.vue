<template>
  <div class="activity-blocks">
    <div class="container">
      <div class="blocks-grid">
        <div
          v-for="block in blocks"
          :key="block.id"
          class="activity-block"
          @click="handleClick(block)"
        >
          <div class="block-icon">{{ block.icon }}</div>
          <div class="block-info">
            <h3>{{ block.title }}</h3>
            <p>{{ block.subtitle }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const blocks = [
  { id: 1, icon: '🔥', title: '限时特惠', subtitle: 'Up to 70% OFF', link: '/sale' },
  { id: 2, icon: '✨', title: '新品上市', subtitle: 'New Arrivals', link: '/new' },
  { id: 3, icon: '🎨', title: '定制专区', subtitle: 'Custom Design', link: '/custom' },
  { id: 4, icon: '📦', title: '批发专区', subtitle: 'Wholesale Price', link: '/wholesale' },
]

const handleClick = (block) => {
  console.log('点击活动块:', block.title)
}
</script>

<style scoped>
.activity-blocks {
  padding: 40px 0;
}

.blocks-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.activity-block {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 24px;
  background: var(--color-bg);
  border-radius: 8px;
  box-shadow: var(--shadow);
  cursor: pointer;
  transition: var(--transition);
}

.activity-block:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.12);
}

.block-icon {
  font-size: 36px;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-bg-gray);
  border-radius: 50%;
}

.block-info h3 {
  font-size: var(--font-size-lg);
  color: var(--color-text);
  margin-bottom: 4px;
}

.block-info p {
  font-size: var(--font-size-sm);
  color: var(--color-text-light);
}
</style>
