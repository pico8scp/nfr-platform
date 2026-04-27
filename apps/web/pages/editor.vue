<template>
  <div>
    <div class="page-title">代码编辑器</div>

    <div class="editor-layout">
      <!-- Left: Editor Pane -->
      <div class="editor-pane">
        <div class="editor-tabs">
          <button
            v-for="tab in tabs"
            :key="tab.id"
            class="tab-btn"
            :class="{ active: activeTab === tab.id }"
            @click="switchTab(tab.id)"
          >{{ tab.label }}</button>
        </div>
        <div ref="editorContainer" class="monaco-container"></div>
        <div class="editor-controls">
          <button class="btn btn-primary btn-sm" @click="refreshPreview">刷新预览</button>
          <button class="btn btn-secondary btn-sm" @click="copyCode">复制代码</button>
          <span class="text-muted" style="font-size:11px">自动刷新：800ms 延迟</span>
        </div>
      </div>

      <!-- Right: Preview Pane -->
      <div class="preview-pane">
        <div class="preview-header">
          <span>实时预览</span>
          <span class="text-muted" style="font-size:11px">沙箱 iframe</span>
        </div>
        <iframe
          ref="previewFrame"
          class="preview-iframe"
          sandbox="allow-scripts"
          :srcdoc="previewDoc"
        ></iframe>
        <div class="preview-console">
          <div class="console-title">控制台</div>
          <div class="console-log text-muted" v-if="consoleLogs.length === 0">暂无输出</div>
          <div class="console-line" v-for="(log, i) in consoleLogs" :key="i" :class="log.type">
            <span class="console-prefix">{{ log.type === 'error' ? '✕' : '›' }}</span>
            {{ log.msg }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const tabs = [
  { id: 'html', label: 'HTML', lang: 'html' },
  { id: 'css', label: 'CSS', lang: 'css' },
  { id: 'js', label: 'JavaScript', lang: 'javascript' },
]

const activeTab = ref('html')
const editorContainer = ref<HTMLElement | null>(null)
const previewFrame = ref<HTMLIFrameElement | null>(null)
const consoleLogs = ref<{ type: string; msg: string }[]>([])

const code = ref({
  html: `<div class="container">
  <h1>Hello Nexus</h1>
  <p>编辑左侧代码，即可在右侧看到实时预览！</p>
  <button onclick="sayHello()">点我一下</button>
  <div id="output"></div>
</div>`,
  css: `.container {
  font-family: system-ui, sans-serif;
  max-width: 600px;
  margin: 40px auto;
  padding: 20px;
  text-align: center;
}
h1 { color: #4f9cf9; }
button {
  padding: 10px 24px;
  background: #4f9cf9;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  margin-top: 16px;
}
button:hover { background: #3b8be8; }
#output { margin-top: 20px; min-height: 20px; }`,
  js: `function sayHello() {
  console.log('来自 Nexus 编辑器：你好！');
  const output = document.getElementById('output');
  const msg = document.createElement('p');
  msg.textContent = '✨ 按钮已点击！时间：' + new Date().toLocaleTimeString('zh-CN');
  msg.style.cssText = 'color: #34d399; font-weight: bold;';
  output.appendChild(msg);
}`,
})

const previewDoc = ref('')
let updateTimer: ReturnType<typeof setTimeout> | null = null
let monacoEditor: any = null
let monacoInstance: any = null

function updatePreview() {
  const { html, css, js } = code.value
  previewDoc.value = `<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>${css}</style>
</head>
<body>
${html}
<script>
  const originalLog = console.log;
  const originalError = console.error;
  function postToParent(type, args) {
    try {
      window.parent.postMessage({ type, msg: Array.from(args).join(' ') }, '*');
    } catch(e) {}
  }
  console.log = (...args) => { try { originalLog.apply(console, args); postToParent('log', args); } catch(e) {} };
  console.error = (...args) => { try { originalError.apply(console, args); postToParent('error', args); } catch(e) {} };
  window.onerror = (msg) => { try { postToParent('error', [msg]); } catch(e) {} };
  ${js}
<\/script>
</body>
</html>`
}

function scheduleUpdate() {
  if (updateTimer) clearTimeout(updateTimer)
  updateTimer = setTimeout(updatePreview, 800)
}

function refreshPreview() { updatePreview() }

function copyCode() {
  navigator.clipboard.writeText(code.value[activeTab.value as keyof typeof code.value]).catch(() => {})
}

function switchTab(tabId: string) {
  if (monacoEditor && monacoInstance) {
    monacoEditor.setValue(code.value[tabId as keyof typeof code.value])
  }
  activeTab.value = tabId
}

onMounted(async () => {
  updatePreview()

  // Load Monaco from CDN
  const loaderScript = document.createElement('script')
  loaderScript.src = 'https://cdn.jsdelivr.net/npm/monaco-editor@0.52.0/min/vs/loader.js'
  loaderScript.onload = async () => {
    const anyWindow = window as any
    anyWindow.require.config({
      paths: { vs: 'https://cdn.jsdelivr.net/npm/monaco-editor@0.52.0/min/vs' }
    })
    anyWindow.require(['vs/editor/editor.main'], (monaco: any) => {
      monacoInstance = monaco

      monaco.editor.defineTheme('nexusDark', {
        base: 'vs-dark',
        inherit: true,
        rules: [],
        colors: { 'editor.background': '#0d1117', 'editor.foreground': '#c9d1d9' }
      })

      monacoEditor = monaco.editor.create(editorContainer.value!, {
        value: code.value.html,
        language: 'html',
        theme: 'nexusDark',
        fontSize: 13,
        fontFamily: "'Cascadia Code', 'Fira Code', 'Consolas', monospace",
        fontLigatures: true,
        lineHeight: 21,
        minimap: { enabled: false },
        scrollBeyondLastLine: false,
        automaticLayout: true,
        padding: { top: 12, bottom: 12 },
        renderLineHighlight: 'none',
        overviewRulerLanes: 0,
        hideCursorInOverviewRuler: true,
        scrollbar: { verticalScrollbarSize: 6, horizontalScrollbarSize: 6 },
        wordWrap: 'on',
        tabSize: 2,
      })

      monacoEditor.onDidChangeModelContent(() => {
        const val = monacoEditor.getValue()
        code.value[activeTab.value as keyof typeof code.value] = val
        scheduleUpdate()
      })

      monacoEditor.addCommand(
        monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS,
        () => { refreshPreview() }
      )
    })
  }
  document.head.appendChild(loaderScript)

  // Listen for console messages from iframe
  window.addEventListener('message', (e) => {
    if (e.data?.type === 'log' || e.data?.type === 'error') {
      consoleLogs.value.push({ type: e.data.type, msg: e.data.msg })
      if (consoleLogs.value.length > 100) consoleLogs.value.shift()
    }
  })
})

// Watch tab switches to update Monaco language
watch(activeTab, (newTab) => {
  if (monacoInstance && monacoEditor) {
    const model = monacoEditor.getModel()
    if (model) {
      monacoInstance.editor.setModelLanguage(model, tabs.find(t => t.id === newTab)?.lang || 'html')
    }
  }
})

onUnmounted(() => {
  if (updateTimer) clearTimeout(updateTimer)
  if (monacoEditor) monacoEditor.dispose()
})
</script>

<style scoped>
.editor-layout { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; height: calc(100vh - 140px); }
.editor-pane, .preview-pane { display: flex; flex-direction: column; background: var(--bg-card); border: 1px solid var(--border); border-radius: 10px; overflow: hidden; }
.editor-tabs { display: flex; background: var(--bg-secondary); border-bottom: 1px solid var(--border); padding: 0 8px; gap: 2px; flex-shrink: 0; }
.tab-btn { padding: 10px 16px; background: transparent; border: none; color: var(--text-muted); font-size: 13px; font-weight: 600; cursor: pointer; border-bottom: 2px solid transparent; transition: all 0.15s; }
.tab-btn:hover { color: var(--text-primary); }
.tab-btn.active { color: var(--accent); border-bottom-color: var(--accent); }
.monaco-container { flex: 1; min-height: 0; }
.editor-controls { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-top: 1px solid var(--border); background: var(--bg-secondary); flex-shrink: 0; }
.preview-header { display: flex; justify-content: space-between; align-items: center; padding: 10px 14px; font-size: 13px; font-weight: 600; border-bottom: 1px solid var(--border); background: var(--bg-secondary); flex-shrink: 0; }
.preview-iframe { flex: 1; width: 100%; border: none; background: #fff; min-height: 200px; }
.preview-console { height: 140px; border-top: 1px solid var(--border); background: #0d1117; padding: 8px; overflow-y: auto; flex-shrink: 0; }
.console-title { font-size: 11px; font-weight: 700; color: var(--text-muted); margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
.console-log { font-size: 12px; color: var(--text-muted); font-family: monospace; }
.console-line { display: flex; gap: 6px; font-size: 12px; font-family: monospace; padding: 2px 0; color: #c9d1d9; }
.console-prefix { color: var(--accent-green); }
.console-line.error .console-prefix { color: var(--accent-red); }
.console-line.error { color: var(--accent-red); }
</style>
