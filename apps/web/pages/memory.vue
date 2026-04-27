<template>
  <div>
    <div class="page-title">记忆中心</div>

    <div class="card mb-4">
      <div class="search-bar">
        <input v-model="query" type="text" placeholder="全文搜索记忆...（如：'vue 组件', '数据库迁移'）" class="search-input" @keyup.enter="doSearch" />
        <button class="btn btn-primary" @click="doSearch">搜索</button>
        <button class="btn btn-secondary" @click="loadRecent">最近</button>
      </div>

      <div class="search-filters">
        <select v-model="filterRole" class="filter-select" @change="doSearch">
          <option value="">全部角色</option>
          <option value="user">用户</option>
          <option value="assistant">助手</option>
          <option value="system">系统</option>
        </select>
        <select v-model="filterSession" class="filter-select" @change="doSearch">
          <option value="">全部会话</option>
          <option v-for="s in sessions" :key="s.id" :value="s.id">{{ s.title }}</option>
        </select>
        <span class="result-count text-muted">{{ searchTotal }} 条结果</span>
      </div>
    </div>

    <div class="card mb-4 live-feed" v-if="liveEvents.length">
      <div class="section-title flex justify-between items-center mb-2">
        实时记忆流
        <span class="live-dot"></span>
      </div>
      <div class="feed-items">
        <div class="feed-item" v-for="e in liveEvents.slice(0, 5)" :key="e.id">
          <span class="tag tag-blue">{{ e.topic }}</span>
          <span class="text-secondary">{{ e.eventType }}</span>
          <span class="text-muted" style="font-size:10px">{{ formatTime(e.createdAt) }}</span>
        </div>
      </div>
    </div>

    <div v-if="loading" class="text-muted">搜索中...</div>
    <div v-else-if="turns.length === 0" class="card text-muted" style="text-align:center; padding:40px">
      未找到记忆。试试其他关键词，或从控制台写入测试数据。
    </div>
    <div v-else class="results-list">
      <div class="card result-card mb-2" v-for="t in turns" :key="t.id">
        <div class="result-header">
          <span class="turn-role" :class="t.role">{{ roleLabel(t.role) }}</span>
          <span class="result-meta text-muted">{{ t.sessionId?.slice(0,12) }}...</span>
          <span class="result-time text-muted">{{ formatTime(t.eventTime) }}</span>
          <span class="tag tag-blue" v-if="t.actorType !== 'human'">{{ t.actorType }}</span>
        </div>
        <pre class="result-content">{{ t.contentText }}</pre>
        <div class="result-actions">
          <button class="btn btn-sm btn-secondary" @click="viewContext(t.id)">查看上下文</button>
          <button class="btn btn-sm btn-secondary" @click="copyContent(t)">复制</button>
        </div>
      </div>
    </div>

    <div class="context-panel" v-if="contextPanel" @click.self="contextPanel = null">
      <div class="context-inner">
        <div class="context-header">
          <span>对话上下文</span>
          <button class="btn btn-sm btn-secondary" @click="contextPanel = null">✕ 关闭</button>
        </div>
        <div class="context-turns">
          <div class="ctx-turn" v-for="t in contextTurns" :key="t.id">
            <span class="turn-role" :class="t.role">{{ roleLabel(t.role) }}</span>
            <pre class="ctx-content">{{ t.contentText }}</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const query = ref('')
const turns = ref<any[]>([])
const searchTotal = ref(0)
const loading = ref(false)
const filterRole = ref('')
const filterSession = ref('')
const sessions = ref<any[]>([])
const liveEvents = ref<any[]>([])
const contextPanel = ref(false)
const contextTurns = ref<any[]>([])
let eventSource: EventSource | null = null

async function loadSessions() {
  try {
    const data = await $fetch('http://127.0.0.1:3101/api/sessions?limit=100') as any
    sessions.value = data.items || []
  } catch {}
}

async function loadRecent() {
  query.value = ''
  loading.value = true
  try {
    const q = filterSession.value
      ? `?sessionId=${filterSession.value}&limit=50`
      : '?limit=50'
    const data = await $fetch(`http://127.0.0.1:3101/api/memory/recent${q}`) as any[]
    turns.value = Array.isArray(data) ? data : []
    searchTotal.value = turns.value.length
  } catch {}
  loading.value = false
}

async function doSearch() {
  if (!query.value.trim()) { loadRecent(); return }
  loading.value = true
  try {
    const params = new URLSearchParams({ q: query.value, limit: '50' })
    if (filterRole.value) params.set('role', filterRole.value)
    if (filterSession.value) params.set('sessionId', filterSession.value)
    const data = await $fetch(`http://127.0.0.1:3101/api/memory/search?${params}`) as any
    turns.value = data.turns || []
    searchTotal.value = data.total || 0
  } catch {}
  loading.value = false
}

async function viewContext(turnId: string) {
  try {
    contextTurns.value = await $fetch(`http://127.0.0.1:3101/api/memory/turns/${turnId}/context?contextSize=5`) as any[]
    contextPanel.value = true
  } catch {}
}

function copyContent(turn: any) { navigator.clipboard.writeText(turn.contentText).catch(() => {}) }

function roleLabel(role: string) {
  const map: Record<string, string> = { user: '用户', assistant: '助手', system: '系统', tool: '工具' }
  return map[role] || role
}

function formatTime(ts: string) {
  if (!ts) return ''
  return new Date(ts).toLocaleString('zh-CN', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false })
}

onMounted(() => {
  loadSessions()
  loadRecent()
  try {
    eventSource = new EventSource('http://127.0.0.1:3101/api/realtime/events')
    eventSource.onmessage = (e) => {
      try {
        const event = JSON.parse(e.data)
        if (event.topic === 'memory.turn.created') {
          liveEvents.value.unshift(event)
          if (liveEvents.value.length > 10) liveEvents.value.pop()
          turns.value.unshift(event.payload)
        }
      } catch {}
    }
  } catch {}
})

onUnmounted(() => { if (eventSource) eventSource.close() })
</script>

<style scoped>
.search-bar { display: flex; gap: 8px; margin-bottom: 10px; }
.search-input { flex: 1; }
.search-filters { display: flex; align-items: center; gap: 10px; }
.filter-select { width: auto; min-width: 140px; font-size: 12px; }
.result-count { font-size: 12px; margin-left: auto; }
.result-card {}
.result-header { display: flex; align-items: center; gap: 8px; margin-bottom: 8px; flex-wrap: wrap; }
.result-meta { font-size: 11px; }
.result-time { font-size: 11px; }
.result-content { font-size: 12px; color: var(--text-secondary); background: var(--bg-secondary); border-radius: 6px; padding: 10px 12px; white-space: pre-wrap; word-break: break-word; max-height: 200px; overflow-y: auto; line-height: 1.6; margin-bottom: 8px; }
.result-actions { display: flex; gap: 6px; }
.turn-role { font-size: 9px; font-weight: 800; padding: 2px 6px; border-radius: 4px; flex-shrink: 0; text-transform: uppercase; letter-spacing: 0.5px; }
.turn-role.user { background: rgba(79,156,249,0.2); color: var(--accent); }
.turn-role.assistant { background: rgba(52,211,153,0.15); color: var(--accent-green); }
.turn-role.system { background: rgba(100,116,139,0.2); color: var(--text-muted); }
.live-dot { display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: var(--accent-green); animation: pulse 1.5s infinite; }
@keyframes pulse { 0%, 100% { opacity: 1; transform: scale(1); } 50% { opacity: 0.5; transform: scale(0.8); } }
.feed-items { display: flex; flex-direction: column; gap: 6px; }
.feed-item { display: flex; align-items: center; gap: 8px; font-size: 12px; }
.context-panel { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.6); z-index: 1000; display: flex; align-items: center; justify-content: center; padding: 20px; }
.context-inner { background: var(--bg-card); border: 1px solid var(--border-light); border-radius: 12px; width: 100%; max-width: 700px; max-height: 80vh; display: flex; flex-direction: column; overflow: hidden; }
.context-header { display: flex; justify-content: space-between; align-items: center; padding: 14px 16px; border-bottom: 1px solid var(--border); font-weight: 700; }
.context-turns { flex: 1; overflow-y: auto; padding: 16px; display: flex; flex-direction: column; gap: 12px; }
.ctx-turn { display: flex; gap: 10px; }
.ctx-content { flex: 1; font-size: 12px; background: var(--bg-secondary); border-radius: 6px; padding: 8px 10px; white-space: pre-wrap; word-break: break-word; line-height: 1.5; }
</style>
