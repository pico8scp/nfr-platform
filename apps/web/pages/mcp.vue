<template>
  <div>
    <div class="page-title flex justify-between items-center">
      MCP 服务器管理
      <button class="btn btn-primary btn-sm" @click="showAddModal = true">+ 添加服务器</button>
    </div>

    <!-- Servers Grid -->
    <div class="grid-3 mb-4">
      <div class="card server-card" v-for="s in servers" :key="s.id">
        <div class="server-header">
          <div class="server-icon">{{ serverIcon(s.transport) }}</div>
          <div>
            <div class="server-name">{{ s.name }}</div>
            <div class="server-transport text-muted">{{ s.transport }}</div>
          </div>
          <span class="status-badge" :class="s.status">{{ statusLabel(s.status) }}</span>
        </div>
        <div class="server-meta text-muted">
          <div>ID: {{ s.id }}</div>
          <div v-if="s.command">命令: {{ s.command }}</div>
          <div v-if="s.endpoint">端点: {{ s.endpoint }}</div>
        </div>
        <div class="server-tools" v-if="getTools(s.id).length > 0">
          <div class="section-title mb-1" style="font-size:11px">工具 ({{ getTools(s.id).length }})</div>
          <div class="tool-chips">
            <span class="tool-chip" v-for="t in getTools(s.id).slice(0, 5)" :key="t.id">{{ t.toolName }}</span>
            <span v-if="getTools(s.id).length > 5" class="text-muted" style="font-size:10px">+{{ getTools(s.id).length - 5 }} 更多</span>
          </div>
        </div>
        <div class="server-actions">
          <button class="btn btn-sm" :class="s.status === 'running' ? 'btn-secondary' : 'btn-primary'" @click="toggleServer(s)">
            {{ s.status === 'running' ? '停止' : '启动' }}
          </button>
          <button class="btn btn-sm btn-secondary" @click="discoverTools(s)">发现工具</button>
          <button class="btn btn-sm btn-secondary" @click="deleteServer(s)">删除</button>
        </div>
      </div>
    </div>

    <div v-if="servers.length === 0" class="card text-muted" style="text-align:center; padding:40px">
      暂无 MCP 服务器。点击上方按钮添加一个。
    </div>

    <!-- All Tools -->
    <div class="card" v-if="allTools.length > 0">
      <div class="section-title mb-3">已发现工具 ({{ allTools.length }})</div>
      <div class="tools-table">
        <div class="tool-row" v-for="t in allTools" :key="t.id">
          <div class="tool-info">
            <span class="tool-name">{{ t.toolName }}</span>
            <span class="tool-desc text-muted">{{ t.description || '无描述' }}</span>
          </div>
          <div class="tool-server tag tag-blue">{{ getServerName(t.serverId) }}</div>
        </div>
      </div>
    </div>

    <!-- Add Server Modal -->
    <div class="modal-overlay" v-if="showAddModal" @click.self="showAddModal = false">
      <div class="modal">
        <div class="modal-header">添加 MCP 服务器</div>
        <div class="modal-body">
          <label>名称</label>
          <input v-model="newServer.name" placeholder="如：filesystem, github" />
          <label>传输方式</label>
          <select v-model="newServer.transport">
            <option value="stdio">stdio</option>
            <option value="http">HTTP</option>
          </select>
          <label>命令 (stdio 模式)</label>
          <input v-model="newServer.command" placeholder="如：npx 或 node 路径" />
          <label>参数 (一行一个)</label>
          <textarea v-model="newServer.argsRaw" placeholder="--flag&#10;value" rows="3"></textarea>
          <label>环境变量 (KEY=VALUE, 每行一个)</label>
          <textarea v-model="newServer.envRaw" placeholder="API_KEY=xxx" rows="2"></textarea>
          <label>HTTP 端点 (HTTP 模式)</label>
          <input v-model="newServer.endpoint" placeholder="http://..." :disabled="newServer.transport === 'stdio'" />
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" @click="showAddModal = false">取消</button>
          <button class="btn btn-primary" @click="addServer">添加</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const servers = ref<any[]>([])
const allTools = ref<any[]>([])
const serverToolsMap = ref<Record<string, any[]>>({})
const showAddModal = ref(false)
const newServer = ref({ name: '', transport: 'stdio', command: '', argsRaw: '', envRaw: '', endpoint: '' })

const MCP_API = 'http://127.0.0.1:3002'

async function load() {
  try {
    servers.value = await $fetch('http://127.0.0.1:3101/api/mcp/servers') as any[]
    const tools = await $fetch('http://127.0.0.1:3101/api/mcp/tools') as any[]
    allTools.value = Array.isArray(tools) ? tools : []
    serverToolsMap.value = {}
    allTools.value.forEach((t: any) => {
      if (!serverToolsMap.value[t.serverId]) serverToolsMap.value[t.serverId] = []
      serverToolsMap.value[t.serverId].push(t)
    })

    // Also check running status from MCP server
    try {
      const running = await $fetch(`${MCP_API}/mcp/servers`) as any[]
      running.forEach((r: any) => {
        const s = servers.value.find(s => s.id === r.id)
        if (s && r.ready) s.status = 'running'
      })
    } catch {}
  } catch {}
}

function getTools(serverId: string) {
  return serverToolsMap.value[serverId] || []
}

function getServerName(serverId: string) {
  const s = servers.value.find(s => s.id === serverId)
  return s?.name || serverId
}

function parseServerEnv(raw: string | null | undefined): Record<string, string> | null {
  if (!raw) {
    return {}
  }

  try {
    const parsed = JSON.parse(raw)
    if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) {
      return null
    }

    return Object.fromEntries(
      Object.entries(parsed).map(([key, value]) => [key, String(value)])
    )
  } catch {
    return null
  }
}

function serverIcon(transport: string) {
  return transport === 'stdio' ? '◉' : '◈'
}

function statusLabel(status: string) {
  const map: Record<string, string> = { configured: '已配置', running: '运行中', error: '错误', stopped: '已停止' }
  return map[status] || status
}

async function toggleServer(s: any) {
  try {
    if (s.status === 'running') {
      await $fetch(`${MCP_API}/mcp/servers/${s.id}/stop`, { method: 'POST' })
      s.status = 'stopped'
    } else {
      const args = (s.args_json || '[]').split('\n').filter(Boolean)
      const env = parseServerEnv(s.env_json)
      if (!env) {
        alert('鐜鍙橀噺 JSON 鏍煎紡閿欒')
        return
      }
      await $fetch(`${MCP_API}/mcp/servers/${s.id}/start`, {
        method: 'POST',
        body: { name: s.name, command: s.command, args, env }
      })
      s.status = 'running'
    }
    await $fetch(`http://127.0.0.1:3101/api/mcp/servers/${s.id}`, {
      method: 'PATCH', body: { status: s.status }
    })
  } catch (e) {
    alert(`操作失败：${e}`)
  }
}

async function discoverTools(s: any) {
  try {
    const resp = await $fetch(`http://127.0.0.1:3101/api/mcp/servers/${s.id}/discover`, { method: 'POST' }) as any
    const tools = resp.tools || []
    serverToolsMap.value[s.id] = tools
    allTools.value = Object.values(serverToolsMap.value).flat()
    alert(`发现 ${tools.length} 个工具`)
  } catch (e) {
    alert(`发现失败：${e}`)
  }
}

async function addServer() {
  if (!newServer.value.name) { alert('请输入名称'); return }
  try {
    const args = newServer.value.argsRaw.split('\n').filter((s: string) => s.trim())
    const env: Record<string, string> = {}
    newServer.value.envRaw.split('\n').forEach((line: string) => {
      const [k, ...v] = line.split('=')
      if (k?.trim()) env[k.trim()] = v.join('=').trim()
    })
    await $fetch('http://127.0.0.1:3101/api/mcp/servers', {
      method: 'POST',
      body: {
        name: newServer.value.name,
        transport: newServer.value.transport,
        command: newServer.value.transport === 'stdio' ? newServer.value.command : null,
        endpoint: newServer.value.transport === 'http' ? newServer.value.endpoint : null,
        args,
        env,
        status: 'configured',
        enabled: true,
      }
    })
    showAddModal.value = false
    newServer.value = { name: '', transport: 'stdio', command: '', argsRaw: '', envRaw: '', endpoint: '' }
    await load()
  } catch (e) { alert(`添加失败：${e}`) }
}

async function deleteServer(s: any) {
  if (!confirm(`删除服务器 "${s.name}"？`)) return
  try {
    await $fetch(`http://127.0.0.1:3101/api/mcp/servers/${s.id}`, { method: 'DELETE' })
    await load()
  } catch (e) { alert(`删除失败：${e}`) }
}

onMounted(load)
</script>

<style scoped>
.grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
.server-card { padding: 16px; }
.server-header { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
.server-icon { font-size: 24px; }
.server-name { font-size: 14px; font-weight: 700; }
.server-transport { font-size: 11px; }
.server-meta { font-size: 11px; margin-bottom: 10px; }
.server-meta div { margin-bottom: 2px; }
.server-tools { margin-bottom: 10px; }
.tool-chips { display: flex; flex-wrap: wrap; gap: 4px; }
.tool-chip { font-size: 10px; padding: 2px 7px; border-radius: 6px; background: var(--bg-hover); border: 1px solid var(--border); font-family: monospace; }
.server-actions { display: flex; gap: 6px; flex-wrap: wrap; }
.status-badge { margin-left: auto; font-size: 10px; font-weight: 700; padding: 3px 8px; border-radius: 10px; }
.status-badge.running { background: rgba(52,211,153,0.15); color: var(--accent-green); }
.status-badge.configured { background: rgba(79,156,249,0.15); color: var(--accent); }
.status-badge.error { background: rgba(239,68,68,0.15); color: var(--accent-red); }
.status-badge.stopped { background: rgba(100,116,139,0.15); color: var(--text-muted); }
.tools-table { display: flex; flex-direction: column; gap: 6px; }
.tool-row { display: flex; align-items: center; gap: 12px; padding: 10px; background: var(--bg-hover); border-radius: 8px; border: 1px solid var(--border); }
.tool-info { flex: 1; }
.tool-name { font-size: 12px; font-weight: 700; font-family: monospace; margin-right: 8px; }
.tool-desc { font-size: 11px; }
.tool-server { font-size: 10px; }
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.6); z-index: 1000; display: flex; align-items: center; justify-content: center; padding: 20px; }
.modal { background: var(--bg-card); border: 1px solid var(--border-light); border-radius: 12px; width: 100%; max-width: 520px; max-height: 85vh; overflow-y: auto; }
.modal-header { padding: 16px; font-weight: 700; font-size: 16px; border-bottom: 1px solid var(--border); }
.modal-body { padding: 16px; display: flex; flex-direction: column; gap: 8px; }
.modal-body label { font-size: 12px; font-weight: 600; color: var(--text-secondary); }
.modal-footer { padding: 12px 16px; display: flex; justify-content: flex-end; gap: 8px; border-top: 1px solid var(--border); }
.modal-body textarea { font-family: monospace; font-size: 12px; }
</style>
