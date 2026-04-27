<template>
  <div>
    <!-- 顶部导航 -->
    <div class="page-title flex justify-between items-center">
      <div class="flex items-center gap-3">
        智能体控制台
        <span class="tag" :class="orchestratorRunning ? 'tag-green' : 'tag-red'">
          {{ orchestratorRunning ? '● 将军在线' : '○ 将军离线' }}
        </span>
      </div>
      <div class="flex gap-2">
        <button class="btn btn-sm btn-secondary" @click="createTask">+ 新建任务</button>
        <button class="btn btn-sm btn-secondary" @click="seedDefaultAgents">+ 初始化智能体</button>
      </div>
    </div>

    <!-- 皇上审批面板 (悬停提示) -->
    <div v-if="pendingApprovals.length > 0" class="approval-banner mb-4">
      <div class="approval-header">
        <span class="approval-icon">⚠️</span>
        <span class="approval-title">皇上，需要您决策 ({{ pendingApprovals.length }} 条待审批)</span>
      </div>
      <div v-for="(approval, i) in pendingApprovals" :key="i" class="approval-item">
        <div class="approval-question">{{ approval.question }}</div>
        <div class="approval-meta text-muted">来自: {{ approval.fromAgent }} | {{ formatTime(approval.ts) }}</div>
        <div v-if="approval.options?.length > 0" class="approval-options">
          <button
            v-for="opt in approval.options" :key="opt"
            class="btn btn-sm btn-primary"
            @click="decide(approval.taskId, opt)"
          >{{ opt }}</button>
        </div>
        <div v-else class="flex gap-2 mt-2">
          <button class="btn btn-sm btn-primary" @click="decide(approval.taskId, 'approve')">批准</button>
          <button class="btn btn-sm btn-danger" @click="decide(approval.taskId, 'reject')">拒绝</button>
        </div>
      </div>
    </div>

    <!-- 实时 Agent 会话输出 -->
    <div class="grid-2 mb-4">
      <!-- Agent 卡片 -->
      <div class="card">
        <div class="section-title mb-3">智能体池 ({{ agents.length }})</div>
        <div class="flex flex-col gap-2">
          <div
            v-for="a in agents" :key="a.id"
            class="agent-row"
            :class="{ 'agent-row-active': activeSession && activeSession.agentId === a.id }"
            @click="selectAgent(a)"
          >
            <div class="agent-icon">{{ agentIcon(a.type) }}</div>
            <div class="agent-info">
              <div class="agent-name">{{ a.name }}</div>
              <div class="text-muted" style="font-size:10px">{{ typeLabel(a.type) }} · {{ statusLabel(a.status) }}</div>
            </div>
            <div class="flex gap-1 ml-auto">
              <button
                v-if="a.status !== 'offline'"
                class="btn btn-xs"
                @click.stop="startSession(a.id)"
                :disabled="isSessionRunning(a.id)"
              >启动</button>
              <button
                v-if="isSessionRunning(a.id)"
                class="btn btn-xs btn-danger"
                @click.stop="stopSession(a.id)"
              >停止</button>
            </div>
          </div>
          <div v-if="agents.length === 0" class="text-muted text-sm">暂无智能体。点击"初始化智能体"创建。</div>
        </div>
      </div>

      <!-- 实时输出 -->
      <div class="card">
        <div class="section-title mb-2 flex justify-between items-center">
          <span>实时输出
            <span v-if="activeAgent" class="text-muted"> — {{ activeAgent.name }}</span>
          </span>
          <button v-if="activeSession" class="btn btn-xs btn-secondary" @click="clearOutput">清空</button>
        </div>
        <div class="output-terminal" ref="outputEl">
          <div v-if="!activeSession" class="text-muted text-sm" style="padding:12px">
            选择一个智能体查看实时输出
          </div>
          <div
            v-for="(line, i) in activeOutput" :key="i"
            class="output-line"
            :class="line.type"
          >{{ line.text }}</div>
        </div>
      </div>
    </div>

    <!-- 任务队列 -->
    <div class="card mb-4">
      <div class="section-title mb-3">任务队列 ({{ tasks.length }})</div>
      <div v-if="tasks.length === 0" class="text-muted text-sm mb-3">暂无任务。</div>
      <div v-else class="task-list">
        <div class="task-row" v-for="task in tasks" :key="task.id">
          <div class="task-info">
            <div class="task-title">{{ task.title }}</div>
            <div class="task-meta text-muted">
              {{ task.taskType }} · 优先级 {{ task.priority }} · {{ statusLabel(task.status) }}
              <span v-if="task.assignedAgentId"> → {{ getAgentName(task.assignedAgentId) }}</span>
            </div>
          </div>
          <div class="flex gap-2 items-center">
            <select v-if="task.status === 'queued'" class="assign-select" @change="assignTask(task, $event)">
              <option value="">分派给...</option>
              <option v-for="a in idleAgents" :key="a.id" :value="a.id">{{ a.name }}</option>
            </select>
            <span class="tag" :class="statusTag(task.status)">{{ statusLabel(task.status) }}</span>
            <button
              v-if="task.status === 'assigned' || task.status === 'queued'"
              class="btn btn-xs btn-primary"
              @click="startTaskNow(task)"
            >▶ 启动</button>
          </div>
        </div>
      </div>
    </div>

    <!-- 实时事件流 -->
    <div class="card">
      <div class="section-title mb-3 flex justify-between items-center">
        <span>实时事件流</span>
        <button class="btn btn-xs btn-secondary" @click="liveEvents = []">清空</button>
      </div>
      <div class="events-feed">
        <div class="event-item" v-for="e in liveEvents" :key="e.id">
          <span class="event-topic" :class="eventTag(e.topic)">{{ formatTopic(e.topic) }}</span>
          <span class="event-type text-muted">{{ e.eventType }}</span>
          <span class="event-time text-muted">{{ formatTime(e.createdAt) }}</span>
        </div>
        <div v-if="liveEvents.length === 0" class="text-muted text-sm">等待事件...</div>
      </div>
    </div>

    <!-- 新建任务弹窗 -->
    <div class="modal-overlay" v-if="showCreateModal" @click.self="showCreateModal = false">
      <div class="modal">
        <div class="modal-header">新建任务</div>
        <div class="modal-body">
          <label>标题</label>
          <input v-model="newTask.title" placeholder="任务标题" />
          <label>类型</label>
          <input v-model="newTask.taskType" placeholder="如：frontend, backend, research, orchestrator" />
          <label>优先级 (1-10)</label>
          <input v-model.number="newTask.priority" type="number" min="1" max="10" />
          <label>描述</label>
          <textarea v-model="newTask.inputJson" placeholder='{"description":"任务描述..."}' rows="3"></textarea>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="showCreateModal = false">取消</button>
          <button class="btn btn-primary" @click="submitTask">创建并分派</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Agent { id: string; name: string; type: string; status: string; capabilities?: string[] }
interface Task { id: string; title: string; taskType: string; priority: number; status: string; assignedAgentId?: string }
interface Approval { fromAgent: string; question: string; options?: string[]; taskId?: string; ts: string }
interface OutputLine { text: string; type: string }

const agents = ref<Agent[]>([])
const tasks = ref<Task[]>([])
const pendingApprovals = ref<Approval[]>([])
const liveEvents = ref<any[]>([])
const activeAgent = ref<Agent | null>(null)
const activeSession = ref<any>(null)
const activeOutput = ref<OutputLine[]>([])
const orchestratorRunning = ref(false)
const showCreateModal = ref(false)
const newTask = ref({ title: '', taskType: 'general', priority: 5, inputJson: '{"description":""}' })
const outputEl = ref<HTMLElement>()
let eventSource: EventSource | null = null
let esApprovals: EventSource | null = null

const idleAgents = computed(() => agents.value.filter(a => a.status === 'idle'))

// 运行中的 session ID
const runningSessionIds = new Set<string>()
function isSessionRunning(agentId: string) { return runningSessionIds.has(agentId) }

function getAgentName(agentId: string) {
  return agents.value.find(a => a.id === agentId)?.name || agentId.slice(0, 8)
}

async function load() {
  try {
    const [a, t, approvals] = await Promise.all([
      $fetch('http://127.0.0.1:3101/api/agents').catch(() => []),
      $fetch('http://127.0.0.1:3101/api/agents/tasks').catch(() => []),
      $fetch('http://127.0.0.1:3101/api/orchestrator/approvals').catch(() => ({ approvals: [] })),
    ])
    agents.value = Array.isArray(a) ? a : []
    tasks.value = Array.isArray(t) ? t : []
    pendingApprovals.value = (approvals as any).approvals || []
    orchestratorRunning.value = agents.value.some(a => a.type === 'orchestrator')
  } catch {}
}

async function loadSessions() {
  try {
    const sessions = await $fetch('http://127.0.0.1:3101/api/agents/sessions').catch(() => ({ sessions: [] })) as any
    runningSessionIds.clear()
    for (const s of sessions.sessions || []) {
      runningSessionIds.add(s.agentId)
    }
  } catch {}
}

function selectAgent(a: Agent) {
  activeAgent.value = a
  loadSessionOutput(a.id)
}

async function loadSessionOutput(agentId: string) {
  activeOutput.value = [{ text: `正在连接 ${agentId} 的会话输出...`, type: 'info' }]
  try {
    const session = await $fetch(`http://127.0.0.1:3101/api/agents/sessions`).catch(() => ({ sessions: [] })) as any
    const s = session.sessions?.find((x: any) => x.agentId === agentId)
    activeSession.value = s || null
  } catch { activeSession.value = null }
}

async function startSession(agentId: string) {
  try {
    await $fetch('http://127.0.0.1:3101/api/agents/sessions/start', {
      method: 'POST', body: { agentId }
    })
    runningSessionIds.add(agentId)
    await load()
  } catch (e) { console.error(e) }
}

async function stopSession(agentId: string) {
  try {
    await $fetch('http://127.0.0.1:3101/api/agents/sessions/stop', {
      method: 'POST', body: { agentId }
    })
    runningSessionIds.delete(agentId)
    await load()
  } catch (e) { console.error(e) }
}

function clearOutput() { activeOutput.value = [] }

async function createTask() { showCreateModal.value = true }

async function submitTask() {
  try {
    let input: any = {}
    try { input = JSON.parse(newTask.value.inputJson || '{}') } catch {}
    await $fetch('http://127.0.0.1:3101/api/agents/tasks', {
      method: 'POST',
      body: { title: newTask.value.title, taskType: newTask.value.taskType, priority: newTask.value.priority, input }
    })
    showCreateModal.value = false
    newTask.value = { title: '', taskType: 'general', priority: 5, inputJson: '{"description":""}' }
    await load()
  } catch {}
}

async function assignTask(task: Task, event: any) {
  const agentId = (event.target as HTMLSelectElement).value
  if (!agentId) return
  try {
    await $fetch(`http://127.0.0.1:3101/api/agents/tasks/${task.id}/assign`, { method: 'POST', body: { agentId } })
    await load()
  } catch {}
}

async function startTaskNow(task: Task) {
  try {
    await $fetch(`http://127.0.0.1:3101/api/agents/tasks/${task.id}/start`, { method: 'POST' })
    await load()
  } catch {}
}

async function decide(taskId: string | undefined, answer: string) {
  try {
    await $fetch('http://127.0.0.1:3101/api/orchestrator/decide', {
      method: 'POST', body: { answer, taskId }
    })
    await load()
  } catch {}
}

async function seedDefaultAgents() {
  const defaults = [
    { name: 'Orchestrator', type: 'orchestrator', status: 'idle', runtimeMode: 'child_process', capabilities: ['orchestration', 'decision-making', 'escalation'] },
    { name: '前端开发', type: 'frontend-dev', status: 'idle', runtimeMode: 'child_process', capabilities: ['vue', 'react', 'css', 'typescript'] },
    { name: '后端开发', type: 'backend-dev', status: 'idle', runtimeMode: 'child_process', capabilities: ['nodejs', 'python', 'sql', 'api'] },
    { name: '调研智能体', type: 'research', status: 'idle', runtimeMode: 'child_process', capabilities: ['分析', '调研', '文档'] },
    { name: '测试工程师', type: 'tester', status: 'idle', runtimeMode: 'child_process', capabilities: ['测试', 'QA', '验证'] },
  ]
  for (const a of defaults) {
    try {
      const existing = agents.value.find(x => x.name === a.name && x.type === a.type)
      if (!existing) await $fetch('http://127.0.0.1:3101/api/agents', { method: 'POST', body: a })
    } catch {}
  }
  await load()
}

function statusTag(status: string) {
  const map: Record<string, string> = { queued: 'tag-orange', assigned: 'tag-blue', running: 'tag-blue', completed: 'tag-green', failed: 'tag-red', cancelled: 'tag-red' }
  return map[status] || 'tag-blue'
}
function statusLabel(status: string) {
  const map: Record<string, string> = { queued: '排队中', assigned: '已分派', running: '执行中', completed: '已完成', failed: '失败', cancelled: '已取消', idle: '空闲', busy: '忙碌', offline: '离线' }
  return map[status] || status
}
function typeLabel(type: string) {
  const map: Record<string, string> = { 'frontend-dev': '前端开发', 'backend-dev': '后端开发', research: '调研', tester: '测试', general: '通用', orchestrator: '将军' }
  return map[type] || type
}
function agentIcon(type: string) {
  const icons: Record<string, string> = { 'frontend-dev': '◈', 'backend-dev': '◥', research: '◉', tester: '◩', general: '◇', orchestrator: '★' }
  return icons[type] || '◇'
}
function formatTime(ts: string) {
  if (!ts) return ''
  return new Date(ts).toLocaleTimeString('zh-CN', { hour12: false, hour: '2-digit', minute: '2-digit', second: '2-digit' })
}
function formatTopic(topic: string) {
  return topic.replace('agent.', '').replace('skill.', '').replace('memory.', '').replace('session.', '').replace('mcp.', '')
}
function eventTag(topic: string) {
  if (topic.includes('output')) return 'tag-dim'
  if (topic.includes('error') || topic.includes('failed')) return 'tag-red'
  if (topic.includes('completed') || topic.includes('success')) return 'tag-green'
  if (topic.includes('escalation') || topic.includes('approval')) return 'tag-orange'
  if (topic.includes('running')) return 'tag-blue'
  return 'tag-dim'
}

onMounted(async () => {
  await load()
  await loadSessions()

  eventSource = new EventSource('http://127.0.0.1:3101/api/realtime/events')
  eventSource.onmessage = (e) => {
    try {
      const event = JSON.parse(e.data)
      liveEvents.value.unshift(event)
      if (liveEvents.value.length > 80) liveEvents.value.pop()

      // 实时更新 Agent 输出
      if (event.topic === 'agent.output') {
        if (activeAgent.value && event.entityId === activeAgent.value.id) {
          const payload = event.payload || {}
          activeOutput.value.push({ text: payload.text || '', type: event.eventType || 'output' })
          if (activeOutput.value.length > 500) activeOutput.value.shift()
          nextTick(() => {
            if (outputEl.value) outputEl.value.scrollTop = outputEl.value.scrollHeight
          })
        }
      }

      // 更新会话状态
      if (event.topic === 'agent.session.started') {
        runningSessionIds.add(event.payload?.agentId)
        loadSessions()
      }
      if (event.topic === 'agent.session.stopped' || event.topic === 'agent.session.exited') {
        runningSessionIds.delete(event.payload?.agentId)
        loadSessions()
      }

      // 皇上 escalation 通知
      if (event.topic === 'agent.emperor-escalation') {
        load() // 刷新 pending approvals
      }

      // 通用刷新
      if (['agent.task.', 'agent.session.', 'agent.escalate', 'agent.human-approval'].some(p => event.topic?.startsWith(p))) {
        load()
      }
    } catch {}
  }
})

onUnmounted(() => {
  if (eventSource) eventSource.close()
  if (esApprovals) esApprovals.close()
})
</script>

<style scoped>
.approval-banner {
  background: rgba(245, 158, 11, 0.1);
  border: 1px solid rgba(245, 158, 11, 0.3);
  border-radius: 10px;
  padding: 14px;
}
.approval-header { display: flex; align-items: center; gap: 8px; margin-bottom: 10px; }
.approval-icon { font-size: 18px; }
.approval-title { font-weight: 700; font-size: 13px; color: var(--accent-orange); }
.approval-item { background: var(--bg-hover); border-radius: 8px; padding: 12px; margin-bottom: 8px; }
.approval-question { font-size: 13px; font-weight: 600; margin-bottom: 4px; }
.approval-meta { font-size: 11px; margin-bottom: 8px; }
.approval-options { display: flex; gap: 6px; flex-wrap: wrap; }

.grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }

.agent-row { display: flex; align-items: center; gap: 10px; padding: 10px; border-radius: 8px; border: 1px solid var(--border); cursor: pointer; transition: all 0.15s; background: var(--bg-hover); }
.agent-row:hover { border-color: var(--accent); }
.agent-row-active { border-color: var(--accent); background: var(--accent-dim); }
.agent-icon { font-size: 20px; flex-shrink: 0; }
.agent-info { flex: 1; }
.agent-name { font-size: 13px; font-weight: 700; }

.output-terminal {
  height: 280px;
  background: #0a0a0a;
  border-radius: 8px;
  overflow-y: auto;
  font-family: 'Cascadia Code', 'Fira Code', monospace;
  font-size: 11px;
  line-height: 1.5;
}
.output-line { padding: 1px 12px; white-space: pre-wrap; word-break: break-all; }
.output-line.stderr { color: #f87171; }
.output-line.error { color: #f87171; background: rgba(248, 113, 113, 0.1); }
.output-line.info { color: #60a5fa; }
.output-line.success { color: #34d399; }
.output-line:last-child { background: rgba(96, 165, 250, 0.05); }

.task-list { display: flex; flex-direction: column; gap: 6px; }
.task-row { display: flex; align-items: center; gap: 12px; padding: 12px; background: var(--bg-hover); border-radius: 8px; border: 1px solid var(--border); flex-wrap: wrap; }
.task-info { flex: 1; }
.task-title { font-size: 13px; font-weight: 600; margin-bottom: 2px; }
.task-meta { font-size: 11px; }
.assign-select { width: auto; min-width: 130px; font-size: 12px; }

.events-feed { display: flex; flex-direction: column; gap: 5px; max-height: 240px; overflow-y: auto; }
.event-item { display: flex; align-items: center; gap: 8px; font-size: 11px; padding: 5px 8px; border-radius: 6px; }
.event-item:hover { background: var(--bg-hover); }
.event-topic { font-size: 10px; font-weight: 700; padding: 1px 6px; border-radius: 4px; }
.event-time { margin-left: auto; }

.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 1000; display: flex; align-items: center; justify-content: center; padding: 20px; }
.modal { background: var(--bg-card); border: 1px solid var(--border-light); border-radius: 12px; width: 100%; max-width: 480px; }
.modal-header { padding: 16px; font-weight: 700; font-size: 16px; border-bottom: 1px solid var(--border); }
.modal-body { padding: 16px; display: flex; flex-direction: column; gap: 8px; }
.modal-body label { font-size: 12px; font-weight: 600; color: var(--text-secondary); }
.modal-footer { padding: 12px 16px; display: flex; justify-content: flex-end; gap: 8px; border-top: 1px solid var(--border); }
</style>
