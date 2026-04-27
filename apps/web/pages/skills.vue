<template>
  <div>
    <div class="page-title">技能库</div>

    <!-- 执行器 -->
    <div class="card mb-4">
      <div class="section-title mb-3">技能执行器</div>
      <div class="executor">
        <select v-model="selectedSkill" class="skill-select">
          <option value="">选择技能...</option>
          <option v-for="s in builtInSkills" :key="s.slash" :value="s.slash">{{ s.slash }} — {{ s.title }}</option>
        </select>
        <textarea v-model="inputJson" class="input-json" placeholder='{"query": "搜索关键词"}' rows="3"></textarea>
        <div class="executor-actions">
          <button class="btn btn-primary" @click="executeSkill" :disabled="!selectedSkill || executing">
            {{ executing ? '执行中...' : '执行' }}
          </button>
          <button class="btn btn-secondary" @click="selectedSkill = ''; inputJson = '{}'; outputJson = ''">清空</button>
        </div>
        <div class="output-area" v-if="outputJson">
          <div class="output-label">输出</div>
          <pre class="output-json">{{ outputJson }}</pre>
        </div>
        <div class="error-output" v-if="errorMsg">{{ errorMsg }}</div>
      </div>
    </div>

    <!-- 内置技能列表 -->
    <div class="card mb-4">
      <div class="section-title mb-3">内置技能</div>
      <div class="skills-grid">
        <div
          class="skill-card"
          v-for="s in builtInSkills"
          :key="s.slash"
          :class="{ active: selectedSkill === s.slash }"
          @click="selectSkill(s.slash)"
        >
          <div class="skill-slash">{{ s.slash }}</div>
          <div class="skill-title">{{ s.title }}</div>
          <div class="skill-desc text-muted">{{ s.description }}</div>
          <div class="skill-params text-muted">{{ s.params }}</div>
          <div class="skill-cat tag tag-blue">{{ s.category }}</div>
        </div>
      </div>
    </div>

    <!-- 执行记录 -->
    <div class="card">
      <div class="section-title mb-3">执行历史 ({{ runHistory.length }})</div>
      <div v-if="runHistory.length === 0" class="text-muted">暂无执行记录。</div>
      <div class="run-list">
        <div class="run-item" v-for="r in runHistory" :key="r.id">
          <div class="run-header">
            <span class="run-skill">{{ r.skillId }}</span>
            <span class="tag" :class="statusTag(r.status)">{{ statusLabel(r.status) }}</span>
            <span class="text-muted" style="font-size:10px; margin-left:auto">{{ formatTime(r.createdAt) }}</span>
          </div>
          <div class="run-output" v-if="r.output_json || r.error_text">
            <span class="text-muted" style="font-size:10px">输出：</span>
            <pre class="run-pre">{{ formatRunOutput(r) }}</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const selectedSkill = ref('')
const inputJson = ref('{}')
const outputJson = ref('')
const errorMsg = ref('')
const executing = ref(false)
const runHistory = ref<any[]>([])
let eventSource: EventSource | null = null

const builtInSkills = [
  { slash: '/memory-search', title: '记忆搜索', description: '在所有存储的对话中全文检索', category: '记忆', params: '{"query":"关键词"}' },
  { slash: '/memory-recent', title: '最近记忆', description: '获取最近的记忆条目', category: '记忆', params: '{"limit":20}' },
  { slash: '/memory-write', title: '写入记忆', description: '向当前会话写入一条记忆', category: '记忆', params: '{"role":"user","content":"内容"}' },
  { slash: '/session-create', title: '创建会话', description: '创建一个新的会话', category: '会话', params: '{"title":"标题"}' },
  { slash: '/session-list', title: '列出会话', description: '列出所有会话', category: '会话', params: '{}' },
  { slash: '/agent-dispatch', title: '智能体分派', description: '向指定智能体分派任务', category: '智能体', params: '{"title":"任务","taskType":"frontend","priority":5}' },
  { slash: '/agent-list', title: '列出智能体', description: '列出所有智能体及其状态', category: '智能体', params: '{}' },
  { slash: '/task-list', title: '列出任务', description: '列出所有任务及其状态', category: '智能体', params: '{}' },
  { slash: '/system-status', title: '系统状态', description: '获取系统当前状态概览', category: '系统', params: '{}' },
  { slash: '/context-link', title: '上下文关联', description: '获取某条记忆的上下文', category: '记忆', params: '{"turnId":"xxx","contextSize":5}' },
]

function selectSkill(slash: string) {
  selectedSkill.value = slash
  const skill = builtInSkills.find(s => s.slash === slash)
  if (skill) inputJson.value = skill.params
  outputJson.value = ''
  errorMsg.value = ''
}

async function loadRuns() {
  try {
    const runs = await $fetch('http://127.0.0.1:3101/api/skills/runs?limit=50') as any[]
    runHistory.value = Array.isArray(runs) ? runs : []
  } catch {}
}

async function executeSkill() {
  if (!selectedSkill.value) return
  executing.value = true
  outputJson.value = ''
  errorMsg.value = ''
  try {
    let input = {}
    try { input = JSON.parse(inputJson.value) } catch { errorMsg.value = '输入 JSON 格式错误'; executing.value = false; return }

    const resp = await $fetch('http://127.0.0.1:3101/api/skills/execute', {
      method: 'POST',
      body: { skillRef: selectedSkill.value, input }
    }) as any

    if (resp.error) {
      errorMsg.value = String(resp.error)
    } else if (resp.run?.status === 'failed') {
      errorMsg.value = String(resp.run?.error_text || '执行失败')
      outputJson.value = JSON.stringify(resp.output, null, 2)
    } else {
      outputJson.value = JSON.stringify(resp.output, null, 2)
    }
    await loadRuns()
  } catch (e: any) {
    errorMsg.value = String(e?.message || e)
  }
  executing.value = false
}

function statusTag(status: string) {
  const map: Record<string, string> = { queued: 'tag-orange', running: 'tag-blue', completed: 'tag-green', failed: 'tag-red' }
  return map[status] || 'tag-blue'
}
function statusLabel(status: string) {
  const map: Record<string, string> = { queued: '排队中', running: '执行中', completed: '已完成', failed: '失败' }
  return map[status] || status
}

function formatTime(ts: string) {
  if (!ts) return ''
  return new Date(ts).toLocaleString('zh-CN', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false })
}

function formatRunOutput(run: { output_json?: string | null; error_text?: string | null }) {
  if (!run.output_json) {
    return run.error_text || ''
  }

  try {
    return JSON.stringify(JSON.parse(run.output_json), null, 2).slice(0, 200)
  } catch {
    return run.output_json.slice(0, 200)
  }
}

onMounted(async () => {
  await loadRuns()
  try {
    eventSource = new EventSource('http://127.0.0.1:3101/api/realtime/events')
    eventSource.onmessage = (e) => {
      try {
        const event = JSON.parse(e.data)
        if (event.topic?.startsWith('skill.run')) loadRuns()
      } catch {}
    }
  } catch {}
})

onUnmounted(() => { if (eventSource) eventSource.close() })
</script>

<style scoped>
.executor { display: flex; flex-direction: column; gap: 10px; }
.skill-select { width: auto; font-size: 13px; }
.input-json { font-family: monospace; font-size: 12px; resize: vertical; }
.executor-actions { display: flex; gap: 8px; }
.output-area { background: var(--bg-secondary); border-radius: 8px; padding: 12px; border: 1px solid var(--border); }
.output-label { font-size: 11px; font-weight: 700; color: var(--text-muted); margin-bottom: 6px; text-transform: uppercase; }
.output-json { font-size: 12px; font-family: monospace; white-space: pre-wrap; word-break: break-all; max-height: 400px; overflow-y: auto; color: var(--accent-green); }
.error-output { background: rgba(239,68,68,0.1); border: 1px solid var(--accent-red); border-radius: 8px; padding: 10px 12px; font-size: 12px; color: var(--accent-red); }
.skills-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.skill-card { background: var(--bg-hover); border: 2px solid var(--border); border-radius: 8px; padding: 14px; cursor: pointer; transition: all 0.15s; }
.skill-card:hover { border-color: var(--accent); }
.skill-card.active { border-color: var(--accent); background: var(--accent-dim); }
.skill-slash { font-size: 14px; font-weight: 900; color: var(--accent); font-family: monospace; margin-bottom: 4px; }
.skill-title { font-size: 13px; font-weight: 700; margin-bottom: 4px; }
.skill-desc { font-size: 11px; line-height: 1.4; margin-bottom: 4px; }
.skill-params { font-size: 10px; font-family: monospace; margin-bottom: 8px; }
.run-list { display: flex; flex-direction: column; gap: 8px; }
.run-item { padding: 12px; background: var(--bg-hover); border-radius: 8px; border: 1px solid var(--border); }
.run-header { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.run-skill { font-size: 12px; font-weight: 600; font-family: monospace; color: var(--accent); }
.run-output { margin-top: 4px; }
.run-pre { font-size: 11px; font-family: monospace; white-space: pre-wrap; color: var(--accent-green); background: var(--bg-secondary); border-radius: 4px; padding: 6px; margin-top: 2px; max-height: 120px; overflow: hidden; }
</style>
