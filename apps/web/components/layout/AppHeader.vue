<template>
  <div class="header">
    <div class="header-left">
      <div class="page-label">{{ pageTitle }}</div>
    </div>
    <div class="header-right">
      <div class="stat-chip">
        <span class="stat-label">会话</span>
        <span class="stat-value">{{ stats.sessions }}</span>
      </div>
      <div class="stat-chip">
        <span class="stat-label">记忆</span>
        <span class="stat-value">{{ stats.turns }}</span>
      </div>
      <div class="stat-chip">
        <span class="stat-label">任务</span>
        <span class="stat-value">{{ stats.tasks }}</span>
      </div>
      <span class="time">{{ currentTime }}</span>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()

const pageTitles: Record<string, string> = {
  '/': '控制台',
  '/memory': '记忆中心',
  '/sessions': '会话列表',
  '/agents': '智能体',
  '/editor': '代码编辑器',
  '/skills': '技能库',
}

const pageTitle = computed(() => pageTitles[route.path] || 'Nexus')

const stats = ref({ sessions: 0, turns: 0, tasks: 0 })
const currentTime = ref('')
let timer: ReturnType<typeof setInterval> | null = null

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleTimeString('zh-CN', { hour12: false })
}

const loadStats = async () => {
  try {
    const [sessions, recent, tasks] = await Promise.all([
      $fetch('http://127.0.0.1:3101/api/sessions?limit=1').catch(() => ({ total: 0 })),
      $fetch('http://127.0.0.1:3101/api/memory/recent?limit=1').catch(() => []),
      $fetch('http://127.0.0.1:3101/api/agents/tasks?limit=1').catch(() => []),
    ])
    stats.value.sessions = (sessions as any).total ?? 0
    stats.value.turns = Array.isArray(recent) ? recent.length : 0
    stats.value.tasks = Array.isArray(tasks) ? tasks.length : 0
  } catch {}
}

onMounted(() => {
  updateTime()
  timer = setInterval(updateTime, 1000)
  loadStats()
})

onUnmounted(() => { if (timer) clearInterval(timer) })
</script>

<style scoped>
.header { height: var(--header-height); background: var(--bg-secondary); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; padding: 0 20px; flex-shrink: 0; }
.header-right { display: flex; align-items: center; gap: 12px; }
.stat-chip { display: flex; align-items: center; gap: 5px; padding: 4px 10px; background: var(--bg-card); border: 1px solid var(--border); border-radius: 6px; }
.stat-label { font-size: 10px; color: var(--text-muted); }
.stat-value { font-size: 12px; font-weight: 700; color: var(--accent); }
.page-label { font-size: 14px; font-weight: 600; color: var(--text-primary); }
.time { font-size: 12px; color: var(--text-muted); font-variant-numeric: tabular-nums; min-width: 70px; text-align: right; }
</style>
