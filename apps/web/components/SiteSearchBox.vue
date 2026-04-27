<template>
  <div
    ref="rootRef"
    class="search-box"
    :class="{ focused: isFocused, opened: showDropdown }"
  >
    <div class="search-bar">
      <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="11" cy="11" r="8" />
        <path d="M21 21l-4.35-4.35" />
      </svg>
      <input
        :value="modelValue"
        type="text"
        :placeholder="placeholder"
        class="search-input"
        @focus="handleFocus"
        @input="handleInput"
        @keydown.enter.prevent="submitKeyword(modelValue)"
      />
      <button class="search-btn" type="button" @click="submitKeyword(modelValue)">{{ buttonText }}</button>
    </div>

    <div v-if="showDropdown" class="search-suggest-panel">
      <div class="search-suggest-head">
        <span>{{ trimmedKeyword ? '猜你想搜' : '热门搜索' }}</span>
        <span v-if="loading" class="search-suggest-state">加载中...</span>
      </div>

      <button
        v-for="item in displaySuggestions"
        :key="item"
        type="button"
        class="search-suggest-item"
        @mousedown.prevent="submitKeyword(item)"
      >
        <span class="search-suggest-mark">🔎</span>
        <span>{{ item }}</span>
      </button>

      <p v-if="!displaySuggestions.length && !loading" class="search-suggest-empty">暂无可用联想词</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { PRODUCT_SUGGESTION_LIMIT } from '~/config/product'

interface AssistResponse {
  status?: number
  msg?: string
  data?: {
    suggestions?: string[]
    popularKeywords?: string[]
  }
}

const props = withDefaults(defineProps<{
  modelValue: string
  placeholder?: string
  buttonText?: string
}>(), {
  placeholder: 'Search products, categories, activities...',
  buttonText: 'Search',
})

const emit = defineEmits<{
  'update:modelValue': [value: string]
  submit: [value: string]
}>()

const rootRef = ref<HTMLElement | null>(null)
const isFocused = ref(false)
const loading = ref(false)
const suggestions = ref<string[]>([])
const popularKeywords = ref<string[]>([])
const trimmedKeyword = computed(() => props.modelValue.trim())
const displaySuggestions = computed(() => trimmedKeyword.value ? suggestions.value : popularKeywords.value)
const showDropdown = computed(() => isFocused.value && (loading.value || displaySuggestions.value.length > 0))

let requestToken = 0
let debounceTimer: ReturnType<typeof setTimeout> | null = null

function handleInput(event: Event): void {
  const target = event.target as HTMLInputElement | null
  emit('update:modelValue', target?.value || '')
}

function submitKeyword(value: string): void {
  const keyword = value.trim()
  if (!keyword) {
    return
  }

  emit('update:modelValue', keyword)
  emit('submit', keyword)
  isFocused.value = false
}

async function loadAssistData(): Promise<void> {
  const currentToken = ++requestToken
  loading.value = true

  try {
    const response = await $fetch<AssistResponse>('/api/products/assist', {
      query: {
        keyword: trimmedKeyword.value,
        limit: PRODUCT_SUGGESTION_LIMIT,
      },
    })

    if (currentToken !== requestToken) {
      return
    }

    suggestions.value = response.data?.suggestions ?? []
    popularKeywords.value = response.data?.popularKeywords ?? []
  } catch {
    if (currentToken !== requestToken) {
      return
    }

    suggestions.value = []
    popularKeywords.value = []
  } finally {
    if (currentToken === requestToken) {
      loading.value = false
    }
  }
}

function queueAssistLoad(): void {
  if (debounceTimer) {
    clearTimeout(debounceTimer)
  }

  debounceTimer = setTimeout(() => {
    void loadAssistData()
  }, 160)
}

function handleFocus(): void {
  isFocused.value = true
  queueAssistLoad()
}

function handleDocumentClick(event: MouseEvent): void {
  if (!rootRef.value) {
    return
  }

  const target = event.target as Node | null
  if (target && rootRef.value.contains(target)) {
    return
  }

  isFocused.value = false
}

watch(trimmedKeyword, () => {
  if (!isFocused.value) {
    return
  }

  queueAssistLoad()
})

onMounted(() => {
  document.addEventListener('click', handleDocumentClick)
})

onUnmounted(() => {
  if (debounceTimer) {
    clearTimeout(debounceTimer)
  }

  document.removeEventListener('click', handleDocumentClick)
})
</script>

<style scoped>
.search-box {
  position: relative;
  width: 100%;
}

.search-bar {
  display: flex;
  align-items: center;
  width: 100%;
  height: 44px;
  background: #fff;
  border: 2px solid #111;
  transition: box-shadow 0.2s ease, border-color 0.2s ease;
}

.search-box.focused .search-bar {
  box-shadow: 0 10px 24px rgba(17, 17, 17, 0.12);
}

.search-icon {
  color: #999;
  flex-shrink: 0;
  margin-left: 14px;
}

.search-input {
  flex: 1;
  min-width: 0;
  height: 100%;
  border: none;
  outline: none;
  padding: 0 14px 0 10px;
  font-size: 14px;
  color: #222;
  background: transparent;
}

.search-input::placeholder {
  color: #bbb;
}

.search-btn {
  height: 100%;
  padding: 0 22px;
  background: #111;
  color: #fff;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.3px;
  cursor: pointer;
  transition: background 0.2s ease;
}

.search-btn:hover {
  background: #333;
}

.search-suggest-panel {
  position: absolute;
  top: calc(100% + 8px);
  left: 0;
  right: 0;
  z-index: 40;
  padding: 10px;
  background: #fff;
  border: 1px solid #e5e5e5;
  box-shadow: 0 20px 40px rgba(17, 17, 17, 0.16);
}

.search-suggest-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 2px 4px 8px;
  color: #555;
  font-size: 12px;
  font-weight: 700;
}

.search-suggest-state {
  color: #999;
  font-weight: 600;
}

.search-suggest-item {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  padding: 11px 8px;
  color: #111;
  text-align: left;
  border-top: 1px solid #f1f1f1;
  cursor: pointer;
}

.search-suggest-item:first-of-type {
  border-top: none;
}

.search-suggest-item:hover {
  background: #f8f8f8;
}

.search-suggest-mark {
  flex-shrink: 0;
  font-size: 12px;
}

.search-suggest-empty {
  padding: 14px 8px 6px;
  color: #999;
  font-size: 12px;
}

@media (max-width: 767px) {
  .search-bar {
    height: 42px;
  }

  .search-btn {
    padding: 0 16px;
  }
}
</style>
