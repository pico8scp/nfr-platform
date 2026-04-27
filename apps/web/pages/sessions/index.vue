<template>
  <div>
    <div class="page-title flex justify-between items-center">
      会话列表
      <button class="btn btn-primary btn-sm" @click="createSession">+ 新建会话</button>
    </div>

    <div v-if="loading" class="text-muted">加载中...</div>
    <div v-else-if="sessions.length === 0" class="card text-muted" style="text-align:center; padding:40px">
      暂无会话。去控制台创建一个吧。
    </div>
    <div v-else class="sessions-list">
      <div class="card session-card mb-2" v-for="s in sessions" :key="s.id">
        <div class="session-header">
          <div class="session-title">{{ s.title }}</div>
          <span class="tag" :class="s.status === 'active' ? 'tag-green' : 'tag-blue'">{{ s.status === 'active' ? '活跃' : '已归档' }}</span>
        </div>
        <div class="session-meta text-muted">
          创建：{{ formatDate(s.createdAt) }} | 更新：{{ formatDate(s.updatedAt) }}
        </div>
        <div class="session-actions mt-2">
          <button class="btn btn-sm btn-secondary" @click="openSession(s.id)">打开</button>
          <button class="btn btn-sm btn-secondary" @click="deleteSession(s.id)">删除</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const sessions = ref<any[]>([])
const loading = ref(true)

async function load() {
  loading.value = true
  try {
    const data = await $fetch('http://127.0.0.1:3101/api/sessions?limit=100') as any
    sessions.value = data.items || []
  } catch {}
  loading.value = false
}

async function createSession() {
  try {
    await $fetch('http://127.0.0.1:3101/api/sessions', {
      method: 'POST',
      body: { title: `会话 ${new Date().toLocaleString('zh-CN')}`, description: '' }
    })
    await load()
  } catch { alert('API 不可达') }
}

async function openSession(id: string) { navigateTo(`/sessions/${id}`) }

async function deleteSession(id: string) {
  if (!confirm('删除此会话及其所有对话？')) return
  try {
    await $fetch(`http://127.0.0.1:3101/api/sessions/${id}`, { method: 'PATCH', body: { status: 'archived' } })
    await load()
  } catch {}
}

function formatDate(ts: string) {
  if (!ts) return ''
  return new Date(ts).toLocaleString('zh-CN', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false })
}

onMounted(load)
</script>

<style scoped>
.session-card {}
.session-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px; }
.session-title { font-size: 14px; font-weight: 700; }
.session-meta { font-size: 11px; }
.session-actions { display: flex; gap: 6px; }
</style>
