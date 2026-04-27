<template>
  <div class="sidebar">
    <div class="sidebar-header">
      <div class="logo">⬡ Nexus</div>
      <div class="status-dot" :class="dbStatus"></div>
    </div>

    <nav class="sidebar-nav">
      <NuxtLink to="/" class="nav-item" :class="{ active: route.path === '/' }">
        <span class="nav-icon">◈</span>
        控制台
      </NuxtLink>
      <NuxtLink to="/memory" class="nav-item" :class="{ active: route.path === '/memory' }">
        <span class="nav-icon">◉</span>
        记忆中心
      </NuxtLink>
      <NuxtLink to="/sessions" class="nav-item" :class="{ active: route.path.startsWith('/sessions') }">
        <span class="nav-icon">◌</span>
        会话列表
      </NuxtLink>
      <NuxtLink to="/agents" class="nav-item" :class="{ active: route.path.startsWith('/agents') }">
        <span class="nav-icon">◥</span>
        智能体
        <span class="nav-badge" v-if="activeAgentCount > 0">{{ activeAgentCount }}</span>
      </NuxtLink>
      <NuxtLink to="/mcp" class="nav-item" :class="{ active: route.path === '/mcp' }">
        <span class="nav-icon">◈</span>
        MCP
      </NuxtLink>
      <NuxtLink to="/editor" class="nav-item" :class="{ active: route.path === '/editor' }">
        <span class="nav-icon">◇</span>
        代码编辑器
      </NuxtLink>
      <NuxtLink to="/skills" class="nav-item" :class="{ active: route.path === '/skills' }">
        <span class="nav-icon">◩</span>
        技能库
      </NuxtLink>
    </nav>

    <div class="sidebar-footer">
      <div class="api-status">
        <span class="api-dot" :class="apiStatus"></span>
        <span class="api-text">API {{ apiStatus === 'online' ? '在线' : '离线' }}</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const apiStatus = ref('offline')
const dbStatus = ref('offline')
const activeAgentCount = ref(0)
const orchestratorStatus = ref<'online' | 'offline'>('offline')
let eventSource: EventSource | null = null

onMounted(async () => {
  try {
    await $fetch('http://127.0.0.1:3101/api/health')
    apiStatus.value = 'online'
    dbStatus.value = 'online'
  } catch {}

  try {
    eventSource = new EventSource('http://127.0.0.1:3101/api/realtime/events')
    eventSource.onmessage = (e) => {
      try {
        const event = JSON.parse(e.data)
        if (event.topic === 'agent.task.queued' || event.topic === 'agent.task.assigned') {
          activeAgentCount.value++
        }
        if (event.topic === 'agent.session.started' || event.topic === 'orchestrator.ready') {
          orchestratorStatus.value = 'online'
        }
        if (event.topic === 'agent.escalate' || event.topic === 'agent.human-approval') {
          orchestratorStatus.value = 'online'
        }
      } catch {}
    }
  } catch {}
})

onUnmounted(() => { if (eventSource) eventSource.close() })
</script>

<style scoped>
.sidebar { width: var(--sidebar-width); background: var(--bg-secondary); border-right: 1px solid var(--border); display: flex; flex-direction: column; flex-shrink: 0; }
.sidebar-header { padding: 16px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); }
.logo { font-size: 18px; font-weight: 900; color: var(--accent); letter-spacing: -0.5px; }
.status-dot { width: 8px; height: 8px; border-radius: 50%; }
.status-dot.online { background: var(--accent-green); box-shadow: 0 0 6px var(--accent-green); }
.status-dot.offline { background: var(--text-muted); }
.sidebar-nav { flex: 1; padding: 12px 8px; display: flex; flex-direction: column; gap: 2px; }
.nav-item { display: flex; align-items: center; gap: 10px; padding: 9px 12px; border-radius: 8px; color: var(--text-secondary); text-decoration: none; font-size: 13px; font-weight: 500; transition: all 0.15s; position: relative; }
.nav-item:hover { background: var(--bg-hover); color: var(--text-primary); }
.nav-item.active { background: var(--accent-dim); color: var(--accent); font-weight: 600; }
.nav-icon { font-size: 14px; }
.nav-badge { margin-left: auto; background: var(--accent-orange); color: #000; font-size: 10px; font-weight: 800; padding: 1px 6px; border-radius: 10px; }
.sidebar-footer { padding: 12px 16px; border-top: 1px solid var(--border); }
.api-status { display: flex; align-items: center; gap: 6px; }
.api-dot { width: 6px; height: 6px; border-radius: 50%; }
.api-dot.online { background: var(--accent-green); }
.api-dot.offline { background: var(--accent-red); }
.api-text { font-size: 11px; color: var(--text-muted); }
</style>
