<template>
  <div>
    <div class="page-title flex justify-between items-center">
      会话详情：{{ session?.title || route.params.sessionId }}
      <NuxtLink to="/sessions" class="btn btn-sm btn-secondary">← 返回</NuxtLink>
    </div>

    <div class="grid-2 mb-4">
      <div class="card">
        <div class="section-title mb-3">对话列表</div>
        <button class="btn btn-primary btn-sm mb-3" @click="createConversation">+ 新建对话</button>
        <div v-for="c in conversations" :key="c.id" class="conv-item" :class="{ active: c.id === activeConvId }" @click="selectConversation(c)">
          <div class="conv-title">{{ c.title || '未命名' }}</div>
          <div class="conv-meta text-muted">{{ formatDate(c.lastTurnAt) }}</div>
        </div>
      </div>

      <div class="card">
        <div class="section-title mb-3">最近记忆</div>
        <div v-for="t in recentTurns" :key="t.id" class="turn-mini">
          <span class="turn-role-sm" :class="t.role">{{ roleLabel(t.role) }}</span>
          <div class="turn-mini-text">{{ t.contentText.slice(0, 60) }}...</div>
        </div>
      </div>
    </div>

    <div class="card" v-if="activeConvId">
      <div class="section-title mb-3">对话历史</div>
      <div class="conversation-view">
        <div class="conv-turn" v-for="t in conversationTurns" :key="t.id">
          <div class="conv-turn-header">
            <span class="turn-role" :class="t.role">{{ roleLabel(t.role) }}</span>
            <span class="text-muted" style="font-size:10px">{{ formatTime(t.eventTime) }}</span>
          </div>
          <pre class="conv-turn-content">{{ t.contentText }}</pre>
        </div>
      </div>

      <div class="add-turn mt-3">
        <select v-model="newRole" class="role-select">
          <option value="user">用户</option>
          <option value="assistant">助手</option>
          <option value="system">系统</option>
        </select>
        <textarea v-model="newContent" class="new-content-input" placeholder="输入消息内容..." rows="3"></textarea>
        <button class="btn btn-primary btn-sm mt-2" @click="addTurn">添加记录</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const session = ref<any>(null)
const conversations = ref<any[]>([])
const recentTurns = ref<any[]>([])
const conversationTurns = ref<any[]>([])
const activeConvId = ref<string | null>(null)
const newRole = ref('user')
const newContent = ref('')

async function loadSession() {
  const id = route.params.sessionId as string
  session.value = await $fetch(`http://127.0.0.1:3101/api/sessions/${id}`).catch(() => null)
  conversations.value = await $fetch(`http://127.0.0.1:3101/api/sessions/${id}/conversations`).catch(() => []) as any[]
  recentTurns.value = await $fetch(`http://127.0.0.1:3101/api/memory/recent?sessionId=${id}&limit=10`).catch(() => []) as any[]
}

async function createConversation() {
  const id = route.params.sessionId as string
  const c = await $fetch('http://127.0.0.1:3101/api/conversations', {
    method: 'POST', body: { sessionId: id, title: `对话 ${conversations.value.length + 1}` }
  }) as any
  conversations.value.unshift(c)
  selectConversation(c)
}

async function selectConversation(c: any) {
  activeConvId.value = c.id
  conversationTurns.value = await $fetch(`http://127.0.0.1:3101/api/conversations/${c.id}/turns`).catch(() => []) as any[]
}

async function addTurn() {
  if (!newContent.value.trim() || !activeConvId.value) return
  const conv = conversations.value.find(c => c.id === activeConvId.value)
  if (!conv) return
  const t = await $fetch(`http://127.0.0.1:3101/api/conversations/${activeConvId.value}/turns`, {
    method: 'POST',
    body: { role: newRole.value, contentText: newContent.value, actorType: newRole.value === 'user' ? 'human' : 'assistant' }
  }) as any
  conversationTurns.value.push(t)
  newContent.value = ''
}

function roleLabel(role: string) {
  const map: Record<string, string> = { user: '用户', assistant: '助手', system: '系统', tool: '工具' }
  return map[role] || role
}

function formatDate(ts: string) {
  if (!ts) return ''
  return new Date(ts).toLocaleString('zh-CN', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false })
}

function formatTime(ts: string) {
  if (!ts) return ''
  return new Date(ts).toLocaleTimeString('zh-CN', { hour12: false, hour: '2-digit', minute: '2-digit' })
}

onMounted(loadSession)
</script>

<style scoped>
.conv-item { padding: 10px; border-radius: 7px; border: 1px solid var(--border); margin-bottom: 6px; cursor: pointer; transition: all 0.15s; }
.conv-item:hover { border-color: var(--accent); }
.conv-item.active { border-color: var(--accent); background: var(--accent-dim); }
.conv-title { font-size: 13px; font-weight: 600; margin-bottom: 3px; }
.conv-meta { font-size: 10px; }
.turn-mini { padding: 6px 0; border-bottom: 1px solid var(--border); }
.turn-mini:last-child { border-bottom: none; }
.turn-role-sm { font-size: 9px; font-weight: 800; padding: 1px 5px; border-radius: 3px; text-transform: uppercase; display: inline-block; margin-right: 6px; }
.turn-role-sm.user { background: rgba(79,156,249,0.2); color: var(--accent); }
.turn-role-sm.assistant { background: rgba(52,211,153,0.15); color: var(--accent-green); }
.turn-mini-text { font-size: 11px; color: var(--text-muted); display: inline; }
.conversation-view { display: flex; flex-direction: column; gap: 12px; max-height: 400px; overflow-y: auto; }
.conv-turn { background: var(--bg-secondary); border-radius: 8px; padding: 10px; }
.conv-turn-header { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.conv-turn-content { font-size: 12px; white-space: pre-wrap; word-break: break-word; line-height: 1.6; }
.turn-role { font-size: 9px; font-weight: 800; padding: 2px 6px; border-radius: 4px; text-transform: uppercase; }
.turn-role.user { background: rgba(79,156,249,0.2); color: var(--accent); }
.turn-role.assistant { background: rgba(52,211,153,0.15); color: var(--accent-green); }
.turn-role.system { background: rgba(100,116,139,0.2); color: var(--text-muted); }
.add-turn { border-top: 1px solid var(--border); padding-top: 12px; }
.role-select { width: auto; margin-bottom: 6px; }
.new-content-input { resize: vertical; font-family: inherit; }
</style>
