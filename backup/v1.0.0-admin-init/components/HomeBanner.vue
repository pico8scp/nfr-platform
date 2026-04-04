<template>
  <div class="home-banner">
    <div class="banner-container">
      <div class="banner-main" @mouseenter="stopAutoPlay" @mouseleave="startAutoPlay">
        <div class="banner-slides" :style="{ transform: `translateX(-${currentIndex * 100}%)` }">
          <div v-for="(banner, index) in banners" :key="index" class="banner-slide">
            <div class="banner-placeholder" :style="{ background: banner.bg }">
              <span>{{ banner.text }}</span>
            </div>
          </div>
        </div>

        <!-- 左右箭头 -->
        <button class="banner-arrow banner-arrow-left" @click="prevSlide">‹</button>
        <button class="banner-arrow banner-arrow-right" @click="nextSlide">›</button>

        <!-- 指示器 -->
        <div class="banner-dots">
          <span
            v-for="(_, index) in banners"
            :key="index"
            :class="['dot', { active: index === currentIndex }]"
            @click="goToSlide(index)"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const banners = [
  { text: 'Banner 1 - Summer Sale Up to 70% OFF', bg: 'linear-gradient(135deg, #ff6b6b, #ee5a24)' },
  { text: 'Banner 2 - New Arrivals 2024', bg: 'linear-gradient(135deg, #4834d4, #686de0)' },
  { text: 'Banner 3 - Wholesale Price For Business', bg: 'linear-gradient(135deg, #00b894, #55efc4)' },
]

const currentIndex = ref(0)
let timer = null

const nextSlide = () => {
  currentIndex.value = (currentIndex.value + 1) % banners.length
}

const prevSlide = () => {
  currentIndex.value = (currentIndex.value - 1 + banners.length) % banners.length
}

const goToSlide = (index) => {
  currentIndex.value = index
}

const startAutoPlay = () => {
  timer = setInterval(() => {
    nextSlide()
  }, 4000)
}

const stopAutoPlay = () => {
  if (timer) clearInterval(timer)
}

onMounted(() => {
  startAutoPlay()
})

onUnmounted(() => {
  stopAutoPlay()
})
</script>

<style scoped>
.home-banner {
  background: var(--color-bg-gray);
  padding: 20px 0;
}

.banner-container {
  max-width: 1440px;
  margin: 0 auto;
  padding: 0 20px;
}

.banner-main {
  position: relative;
  width: 100%;
  height: 400px;
  overflow: hidden;
  border-radius: 8px;
}

.banner-slides {
  display: flex;
  height: 100%;
  transition: transform 0.5s ease;
}

.banner-slide {
  width: 100%;
  flex-shrink: 0;
}

.banner-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 32px;
  font-weight: 700;
}

.banner-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 48px;
  height: 48px;
  background: rgba(0,0,0,0.4);
  color: #fff;
  font-size: 28px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: var(--transition);
  opacity: 0;
}

.banner-main:hover .banner-arrow {
  opacity: 1;
}

.banner-arrow:hover {
  background: rgba(0,0,0,0.6);
}

.banner-arrow-left { left: 20px; }
.banner-arrow-right { right: 20px; }

.banner-dots {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 8px;
}

.dot {
  width: 10px;
  height: 10px;
  background: rgba(255,255,255,0.5);
  border-radius: 50%;
  cursor: pointer;
  transition: var(--transition);
}

.dot.active {
  background: #fff;
  width: 24px;
  border-radius: 5px;
}
</style>
