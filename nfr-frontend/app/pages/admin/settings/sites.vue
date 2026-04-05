<template>
  <div>
    <div class="d-flex d-justify-between d-align-center d-mb-24">
      <div>
        <h1 style="font-size:20px;font-weight:700;color:var(--d-text);margin:0">国际站点管理</h1>
        <p class="d-text-2 d-mt-4" style="font-size:13px;margin:0">配置全球销售站点，绑定UI模板，设置站点状态</p>
      </div>
      <div class="d-flex d-g-8">
        <button class="d-btn d-btn-outline" @click="showAdd = true">+ 添加站点</button>
        <button class="d-btn d-btn-outline" @click="showBatch = true">⚡ 批量配置</button>
        <button class="d-btn d-btn-primary" @click="llmAll">🤖 LLM 全量开通</button>
      </div>
    </div>

    <!-- 统计概览 -->
    <div class="d-flex d-g-16 d-mb-24 d-wrap">
      <div class="d-card" style="flex:1;min-width:150px">
        <div class="d-card-body d-d-flex d-align-center d-g-12" style="padding:14px 20px">
          <div style="width:36px;height:36px;border-radius:8px;background:rgba(51,112,255,0.12);display:flex;align-items:center;justify-content:center;font-size:16px">🌐</div>
          <div>
            <div style="font-size:18px;font-weight:700;color:var(--d-text)">{{ sites.length }}</div>
            <div class="d-text-2" style="font-size:11px">总站点数</div>
          </div>
        </div>
      </div>
      <div class="d-card" style="flex:1;min-width:150px">
        <div class="d-card-body d-d-flex d-align-center d-g-12" style="padding:14px 20px">
          <div style="width:36px;height:36px;border-radius:8px;background:rgba(82,196,26,0.12);display:flex;align-items:center;justify-content:center;font-size:16px">✅</div>
          <div>
            <div style="font-size:18px;font-weight:700;color:var(--d-green)">{{ sites.filter(s=>s.status==='open').length }}</div>
            <div class="d-text-2" style="font-size:11px">已开通</div>
          </div>
        </div>
      </div>
      <div class="d-card" style="flex:1;min-width:150px">
        <div class="d-card-body d-d-flex d-align-center d-g-12" style="padding:14px 20px">
          <div style="width:36px;height:36px;border-radius:8px;background:rgba(255,122,69,0.12);display:flex;align-items:center;justify-content:center;font-size:16px">🔧</div>
          <div>
            <div style="font-size:18px;font-weight:700;color:var(--d-orange)">{{ sites.filter(s=>s.status==='building').length }}</div>
            <div class="d-text-2" style="font-size:11px">搭建中</div>
          </div>
        </div>
      </div>
      <div class="d-card" style="flex:1;min-width:150px">
        <div class="d-card-body d-d-flex d-align-center d-g-12" style="padding:14px 20px">
          <div style="width:36px;height:36px;border-radius:8px;background:rgba(255,82,82,0.12);display:flex;align-items:center;justify-content:center;font-size:16px">🚫</div>
          <div>
            <div style="font-size:18px;font-weight:700;color:var(--d-red)">{{ sites.filter(s=>s.status==='closed').length }}</div>
            <div class="d-text-2" style="font-size:11px">已关闭</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 站点列表 -->
    <div class="d-card">
      <div class="d-card-header">
        <h3>站点列表</h3>
        <div class="d-flex d-g-8 d-align-center">
          <input v-model="searchKw" class="d-input" style="width:200px" placeholder="搜索国家/站点名..." />
          <select v-model="filterStatus" class="d-select" style="width:120px">
            <option value="">全部状态</option>
            <option value="open">已开通</option>
            <option value="building">搭建中</option>
            <option value="closed">已关闭</option>
          </select>
        </div>
      </div>
      <div class="d-table-wrap">
        <table class="d-table">
          <thead>
            <tr>
              <th>国家/地区</th>
              <th>站点代码</th>
              <th>站点名称</th>
              <th>UI模板</th>
              <th>货币</th>
              <th>语言</th>
              <th>商品数</th>
              <th>订单量</th>
              <th>月销售额</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="s in filteredSites" :key="s.code">
              <td>
                <div class="d-flex d-align-center d-g-8">
                  <span style="font-size:20px">{{ s.flag }}</span>
                  <div>
                    <div style="font-weight:600;font-size:13px;color:var(--d-text)">{{ s.name }}</div>
                    <div class="d-text-xs d-text-2">{{ s.nameEn }}</div>
                  </div>
                </div>
              </td>
              <td>
                <span class="d-badge d-badge-gray" style="font-family:monospace">{{ s.code }}</span>
              </td>
              <td style="font-size:13px;color:var(--d-text)">{{ s.siteName }}</td>
              <td>
                <span class="d-badge" :class="{
                  'd-badge-green': s.template === 'feishu',
                  'd-badge-blue': s.template === 'dark',
                  'd-badge-orange': s.template === 'light',
                  'd-badge-gray': s.template === 'custom'
                }">{{ templateLabel(s.template) }}</span>
              </td>
              <td><span class="d-text-2" style="font-size:13px">{{ s.currency }}</span></td>
              <td><span class="d-text-2" style="font-size:13px">{{ s.language }}</span></td>
              <td><span style="font-weight:600;font-size:13px">{{ s.products }}</span></td>
              <td><span style="font-weight:600;font-size:13px">{{ s.orders }}</span></td>
              <td><span style="font-weight:600;font-size:13px;color:var(--d-active)">{{ s.revenue }}</span></td>
              <td>
                <span class="d-badge" :class="{
                  'd-badge-green': s.status === 'open',
                  'd-badge-orange': s.status === 'building',
                  'd-badge-red': s.status === 'closed'
                }">{{ statusLabel(s.status) }}</span>
              </td>
              <td>
                <div class="d-flex d-g-4 d-wrap">
                  <button class="d-btn d-btn-sm d-btn-outline" style="font-size:11px" @click="editSite(s)">编辑</button>
                  <button
                    class="d-btn d-btn-sm"
                    :style="{
                      background: s.status === 'open' ? 'transparent' : 'var(--d-green)',
                      color: s.status === 'open' ? 'var(--d-text-2)' : '#fff',
                      border: '1px solid ' + (s.status === 'open' ? 'var(--d-border2)' : 'var(--d-green)'),
                      fontSize: '11px', padding: '3px 8px'
                    }"
                    @click="toggleStatus(s)"
                  >
                    {{ s.status === 'open' ? '关闭' : '开通' }}
                  </button>
                  <button class="d-btn d-btn-sm d-btn-outline" style="font-size:11px" @click="previewSite(s)">预览</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- LLM 全量开通结果 -->
    <div v-if="llmResult" class="d-card d-mt-16">
      <div class="d-card-header">
        <h3>🤖 LLM 操作结果</h3>
        <button class="d-btn d-btn-sm d-btn-outline" @click="llmResult = null">关闭</button>
      </div>
      <div class="d-card-body">
        <pre style="font-size:12px;color:var(--d-text-2);white-space:pre-wrap;line-height:1.8">{{ llmResult }}</pre>
      </div>
    </div>

    <!-- 添加/编辑站点抽屉 -->
    <div class="d-drawer-overlay" :class="{ on: showAdd }" @click="showAdd = false"></div>
    <div class="d-drawer" :class="{ on: showAdd }" style="width:480px">
      <div class="d-drawer-header">
        <h3>{{ editing ? '编辑站点' : '添加站点' }}</h3>
        <button class="d-drawer-close" @click="showAdd = false; editing = null">×</button>
      </div>
      <div class="d-drawer-body">
        <div class="d-flex d-g-12">
          <div class="d-form-group" style="flex:1">
            <label class="d-label">国家 *</label>
            <select v-model="form.country" class="d-select" :disabled="!!editing">
              <option value="">选择国家</option>
              <option v-for="c in availableCountries" :key="c.code" :value="c.code">{{ c.flag }} {{ c.name }}</option>
            </select>
          </div>
          <div class="d-form-group" style="flex:1">
            <label class="d-label">站点代码 *</label>
            <input v-model="form.code" class="d-input" placeholder="如 US, GB" style="text-transform:uppercase" :disabled="!!editing" />
          </div>
        </div>
        <div class="d-form-group">
          <label class="d-label">站点名称</label>
          <input v-model="form.siteName" class="d-input" placeholder="NFR USA | Global Marketplace" />
        </div>
        <div class="d-form-group">
          <label class="d-label">UI 模板</label>
          <select v-model="form.template" class="d-select">
            <option value="feishu">飞书深色 (Feishu Dark)</option>
            <option value="dark">经典深色 (Classic Dark)</option>
            <option value="light">护眼浅色 (Light)</option>
            <option value="custom">自定义模板</option>
          </select>
        </div>
        <div class="d-flex d-g-12">
          <div class="d-form-group" style="flex:1">
            <label class="d-label">货币</label>
            <select v-model="form.currency" class="d-select">
              <option>USD</option><option>EUR</option><option>GBP</option>
              <option>JPY</option><option>KRW</option><option>AUD</option>
              <option>CAD</option><option>BRL</option><option>MXN</option>
              <option>RUB</option><option>INR</option><option>SAR</option>
              <option>AED</option><option>CNY</option>
            </select>
          </div>
          <div class="d-form-group" style="flex:1">
            <label class="d-label">语言</label>
            <select v-model="form.language" class="d-select">
              <option>English</option><option>Deutsch</option><option>Français</option>
              <option>Español</option><option>Italiano</option><option>日本語</option>
              <option>한국어</option><option>Português</option><option>Русский</option>
              <option>العربية</option><option>हिन्दी</option><option>中文</option>
            </select>
          </div>
        </div>
        <div class="d-form-group">
          <label class="d-label">站点状态</label>
          <div class="d-flex d-g-8">
            <button
              v-for="s in ['open','building','closed']"
              :key="s"
              class="d-btn d-btn-sm"
              :style="{
                background: form.status === s ? (s==='open'?'var(--d-green)':s==='building'?'var(--d-orange)':'var(--d-red)') : 'transparent',
                color: form.status === s ? '#fff' : 'var(--d-text-2)',
                border: '1px solid ' + (form.status === s ? (s==='open'?'var(--d-green)':s==='building'?'var(--d-orange)':'var(--d-red)') : 'var(--d-border2)')
              }"
              @click="form.status = s"
            >
              {{ statusLabel(s) }}
            </button>
          </div>
        </div>
        <div class="d-form-group">
          <label class="d-label">站点 URL</label>
          <input v-model="form.url" class="d-input" placeholder="https://nfr.example.com" />
        </div>
      </div>
      <div class="d-drawer-footer">
        <button class="d-btn d-btn-outline" @click="showAdd = false; editing = null">取消</button>
        <button class="d-btn d-btn-primary" @click="saveSite">保存</button>
      </div>
    </div>

    <!-- 批量配置抽屉 -->
    <div class="d-drawer-overlay" :class="{ on: showBatch }" @click="showBatch = false"></div>
    <div class="d-drawer" :class="{ on: showBatch }" style="width:560px">
      <div class="d-drawer-header">
        <h3>批量配置站点</h3>
        <button class="d-drawer-close" @click="showBatch = false">×</button>
      </div>
      <div class="d-drawer-body">
        <div class="d-form-group">
          <label class="d-label">选择操作</label>
          <div class="d-flex d-g-8 d-wrap">
            <button class="d-btn" :class="batchOp === 'open' ? 'd-btn-success' : 'd-btn-outline'" @click="batchOp = 'open'">批量开通</button>
            <button class="d-btn" :class="batchOp === 'close' ? 'd-btn-danger' : 'd-btn-outline'" @click="batchOp = 'close'">批量关闭</button>
            <button class="d-btn" :class="batchOp === 'template' ? 'd-btn-primary' : 'd-btn-outline'" @click="batchOp = 'template'">批量设模板</button>
          </div>
        </div>
        <div v-if="batchOp === 'template'" class="d-form-group">
          <label class="d-label">选择模板</label>
          <select v-model="batchTemplate" class="d-select">
            <option value="feishu">飞书深色</option>
            <option value="dark">经典深色</option>
            <option value="light">护眼浅色</option>
          </select>
        </div>
        <div class="d-form-group">
          <label class="d-label">选择站点（可多选）</label>
          <div class="d-flex d-g-8 d-wrap d-mb-12">
            <button
              v-for="s in sites"
              :key="s.code"
              class="d-btn d-btn-sm"
              :style="{
                background: batchSelected.includes(s.code) ? 'var(--d-active-bg)' : 'transparent',
                color: batchSelected.includes(s.code) ? 'var(--d-active)' : 'var(--d-text-2)',
                border: '1px solid ' + (batchSelected.includes(s.code) ? 'var(--d-active)' : 'var(--d-border2)')
              }"
              @click="toggleBatch(s.code)"
            >
              {{ s.flag }} {{ s.code }}
            </button>
          </div>
          <button class="d-btn d-btn-sm d-btn-outline d-mr-4" @click="batchSelected = sites.map(s=>s.code)">全选</button>
          <button class="d-btn d-btn-sm d-btn-outline" @click="batchSelected = []">清空</button>
          <span class="d-text-sm d-text-2 d-ml-8">已选 {{ batchSelected.length }} 个</span>
        </div>
      </div>
      <div class="d-drawer-footer">
        <button class="d-btn d-btn-outline" @click="showBatch = false">取消</button>
        <button class="d-btn d-btn-primary" @click="doBatch" :disabled="batchSelected.length === 0">
          确认执行{{ batchSelected.length > 0 ? ` (${batchSelected.length}个)` : '' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
definePageMeta({ layout: 'admin' })
useHead({ title: '国际站点管理 - NFR 管理后台' })

const searchKw = ref('')
const filterStatus = ref('')
const showAdd = ref(false)
const showBatch = ref(false)
const editing = ref(null)
const llmResult = ref(null)
const batchOp = ref('open')
const batchTemplate = ref('feishu')
const batchSelected = ref([])

const allCountries = [
  { code: 'US', name: '美国', nameEn: 'United States', flag: '🇺🇸' },
  { code: 'GB', name: '英国', nameEn: 'United Kingdom', flag: '🇬🇧' },
  { code: 'DE', name: '德国', nameEn: 'Germany', flag: '🇩🇪' },
  { code: 'FR', name: '法国', nameEn: 'France', flag: '🇫🇷' },
  { code: 'ES', name: '西班牙', nameEn: 'Spain', flag: '🇪🇸' },
  { code: 'IT', name: '意大利', nameEn: 'Italy', flag: '🇮🇹' },
  { code: 'JP', name: '日本', nameEn: 'Japan', flag: '🇯🇵' },
  { code: 'KR', name: '韩国', nameEn: 'South Korea', flag: '🇰🇷' },
  { code: 'AU', name: '澳大利亚', nameEn: 'Australia', flag: '🇦🇺' },
  { code: 'CA', name: '加拿大', nameEn: 'Canada', flag: '🇨🇦' },
  { code: 'BR', name: '巴西', nameEn: 'Brazil', flag: '🇧🇷' },
  { code: 'MX', name: '墨西哥', nameEn: 'Mexico', flag: '🇲🇽' },
  { code: 'RU', name: '俄罗斯', nameEn: 'Russia', flag: '🇷🇺' },
  { code: 'IN', name: '印度', nameEn: 'India', flag: '🇮🇳' },
  { code: 'SA', name: '沙特阿拉伯', nameEn: 'Saudi Arabia', flag: '🇸🇦' },
  { code: 'AE', name: '阿联酋', nameEn: 'UAE', flag: '🇦🇪' },
  { code: 'NL', name: '荷兰', nameEn: 'Netherlands', flag: '🇳🇱' },
  { code: 'PL', name: '波兰', nameEn: 'Poland', flag: '🇵🇱' },
  { code: 'SE', name: '瑞典', nameEn: 'Sweden', flag: '🇸🇪' },
  { code: 'TR', name: '土耳其', nameEn: 'Turkey', flag: '🇹🇷' },
  { code: 'SG', name: '新加坡', nameEn: 'Singapore', flag: '🇸🇬' },
  { code: 'TH', name: '泰国', nameEn: 'Thailand', flag: '🇹🇭' },
  { code: 'MY', name: '马来西亚', nameEn: 'Malaysia', flag: '🇲🇾' },
  { code: 'ID', name: '印度尼西亚', nameEn: 'Indonesia', flag: '🇮🇩' },
  { code: 'VN', name: '越南', nameEn: 'Vietnam', flag: '🇻🇳' },
  { code: 'PH', name: '菲律宾', nameEn: 'Philippines', flag: '🇵🇭' },
  { code: 'EG', name: '埃及', nameEn: 'Egypt', flag: '🇪🇬' },
  { code: 'NG', name: '尼日利亚', nameEn: 'Nigeria', flag: '🇳🇬' },
  { code: 'ZA', name: '南非', nameEn: 'South Africa', flag: '🇿🇦' },
  { code: 'AR', name: '阿根廷', nameEn: 'Argentina', flag: '🇦🇷' },
  { code: 'CL', name: '智利', nameEn: 'Chile', flag: '🇨🇱' },
  { code: 'CO', name: '哥伦比亚', nameEn: 'Colombia', flag: '🇨🇴' },
]

const sites = ref([
  { code: 'US', name: '美国', nameEn: 'United States', flag: '🇺🇸', siteName: 'NFR USA', template: 'feishu', currency: 'USD', language: 'English', status: 'open', products: 2847, orders: 12453, revenue: '$2.4M', url: 'https://us.nfr.market' },
  { code: 'GB', name: '英国', nameEn: 'United Kingdom', flag: '🇬🇧', siteName: 'NFR UK', template: 'feishu', currency: 'GBP', language: 'English', status: 'open', products: 1923, orders: 8234, revenue: '£1.8M', url: 'https://uk.nfr.market' },
  { code: 'DE', name: '德国', nameEn: 'Germany', flag: '🇩🇪', siteName: 'NFR DE', template: 'dark', currency: 'EUR', language: 'Deutsch', status: 'open', products: 1654, orders: 6421, revenue: '€1.6M', url: 'https://de.nfr.market' },
  { code: 'FR', name: '法国', nameEn: 'France', flag: '🇫🇷', siteName: 'NFR FR', template: 'dark', currency: 'EUR', language: 'Français', status: 'open', products: 1432, orders: 5102, revenue: '€1.3M', url: 'https://fr.nfr.market' },
  { code: 'JP', name: '日本', nameEn: 'Japan', flag: '🇯🇵', siteName: 'NFR JP', template: 'feishu', currency: 'JPY', language: '日本語', status: 'open', products: 987, orders: 4123, revenue: '¥158M', url: 'https://jp.nfr.market' },
  { code: 'KR', name: '韩国', nameEn: 'South Korea', flag: '🇰🇷', siteName: 'NFR KR', template: 'dark', currency: 'KRW', language: '한국어', status: 'building', products: 654, orders: 2341, revenue: '₩890M', url: 'https://kr.nfr.market' },
  { code: 'ES', name: '西班牙', nameEn: 'Spain', flag: '🇪🇸', siteName: 'NFR ES', template: 'dark', currency: 'EUR', language: 'Español', status: 'open', products: 876, orders: 3214, revenue: '€820K', url: 'https://es.nfr.market' },
  { code: 'AU', name: '澳大利亚', nameEn: 'Australia', flag: '🇦🇺', siteName: 'NFR AU', template: 'light', currency: 'AUD', language: 'English', status: 'open', products: 765, orders: 2876, revenue: 'A$1.2M', url: 'https://au.nfr.market' },
  { code: 'CA', name: '加拿大', nameEn: 'Canada', flag: '🇨🇦', siteName: 'NFR CA', template: 'feishu', currency: 'CAD', language: 'English', status: 'open', products: 943, orders: 3542, revenue: 'C$1.1M', url: 'https://ca.nfr.market' },
  { code: 'AE', name: '阿联酋', nameEn: 'UAE', flag: '🇦🇪', siteName: 'NFR UAE', template: 'dark', currency: 'AED', language: 'العربية', status: 'building', products: 432, orders: 1234, revenue: 'AED 1.8M', url: 'https://ae.nfr.market' },
  { code: 'BR', name: '巴西', nameEn: 'Brazil', flag: '🇧🇷', siteName: 'NFR BR', template: 'light', currency: 'BRL', language: 'Português', status: 'open', products: 543, orders: 1823, revenue: 'R$2.1M', url: 'https://br.nfr.market' },
  { code: 'IN', name: '印度', nameEn: 'India', flag: '🇮🇳', siteName: 'NFR IN', template: 'light', currency: 'INR', language: 'हिन्दी', status: 'building', products: 321, orders: 876, revenue: '₹5.4M', url: 'https://in.nfr.market' },
  { code: 'MX', name: '墨西哥', nameEn: 'Mexico', flag: '🇲🇽', siteName: 'NFR MX', template: 'light', currency: 'MXN', language: 'Español', status: 'closed', products: 234, orders: 543, revenue: 'MX$890K', url: 'https://mx.nfr.market' },
  { code: 'IT', name: '意大利', nameEn: 'Italy', flag: '🇮🇹', siteName: 'NFR IT', template: 'dark', currency: 'EUR', language: 'Italiano', status: 'open', products: 654, orders: 2341, revenue: '€620K', url: 'https://it.nfr.market' },
  { code: 'SA', name: '沙特', nameEn: 'Saudi Arabia', flag: '🇸🇦', siteName: 'NFR SA', template: 'dark', currency: 'SAR', language: 'العربية', status: 'building', products: 198, orders: 654, revenue: 'SAR 740K', url: 'https://sa.nfr.market' },
  { code: 'RU', name: '俄罗斯', nameEn: 'Russia', flag: '🇷🇺', siteName: 'NFR RU', template: 'dark', currency: 'RUB', language: 'Русский', status: 'closed', products: 432, orders: 1234, revenue: '₽42M', url: 'https://ru.nfr.market' },
])

const filteredSites = computed(() => {
  let list = sites.value
  if (filterStatus.value) list = list.filter(s => s.status === filterStatus.value)
  if (searchKw.value) {
    const kw = searchKw.value.toLowerCase()
    list = list.filter(s => s.name.includes(kw) || s.nameEn.toLowerCase().includes(kw) || s.code.toLowerCase().includes(kw) || s.siteName.toLowerCase().includes(kw))
  }
  return list
})

const availableCountries = computed(() => {
  const used = sites.value.map(s => s.code)
  return allCountries.filter(c => !used.includes(c.code))
})

const form = reactive({
  country: '', code: '', siteName: '', template: 'feishu',
  currency: 'USD', language: 'English', status: 'open', url: ''
})

const editSite = (s) => {
  editing.value = s
  Object.assign(form, s)
  showAdd.value = true
}

const saveSite = () => {
  if (editing.value) {
    Object.assign(editing.value, form)
  } else {
    const country = allCountries.find(c => c.code === form.country)
    sites.value.push({
      ...form,
      name: country?.name || form.code,
      nameEn: country?.nameEn || form.code,
      flag: country?.flag || '🌐',
      products: 0, orders: 0, revenue: '$0'
    })
  }
  showAdd.value = false
  editing.value = null
}

const toggleStatus = (s) => {
  s.status = s.status === 'open' ? 'closed' : 'open'
}

const toggleBatch = (code) => {
  const idx = batchSelected.value.indexOf(code)
  idx > -1 ? batchSelected.value.splice(idx, 1) : batchSelected.value.push(code)
}

const doBatch = () => {
  batchSelected.value.forEach(code => {
    const s = sites.value.find(x => x.code === code)
    if (s) {
      if (batchOp.value === 'open') s.status = 'open'
      else if (batchOp.value === 'close') s.status = 'closed'
      else if (batchOp.value === 'template') s.template = batchTemplate.value
    }
  })
  showBatch.value = false
  batchSelected.value = []
}

const llmAll = () => {
  const all = sites.value.length
  const open = sites.value.filter(s => s.status === 'open').length
  const building = sites.value.filter(s => s.status === 'building').length
  const closed = sites.value.filter(s => s.status === 'closed').length

  let result = `【LLM 全量开通分析报告】
━━━━━━━━━━━━━━━━━━━━━━
📊 当前站点状态:
  ✅ 已开通: ${open} 个
  🔧 搭建中: ${building} 个
  🚫 已关闭: ${closed} 个
  🌐 总计: ${all} 个

🧠 AI 建议策略:
  1. 将搭建中的 ${building} 个站点标记为正式开通（UI已就绪）
  2. 对已关闭的 ${closed} 个站点进行复活评估（巴西/俄罗斯市场仍有潜力）
  3. 优先开通高价值市场: 荷兰、瑞典、新加坡、泰国
  4. 东南亚6国（泰/马/印尼/越/菲/新）统一使用飞书深色模板

⚡ 执行操作: 开通 ${building + closed} 个站点

✅ 已开通: ES, IT, AU, BR (4个)
🔧 维持搭建中: KR, AE, IN, SA (4个)
🚫 维持关闭: MX, RU (2个 - 需市场评估后手动开通)
🌐 新增建议: NL, SE, SG, TH, MY, ID, VN, PH, EG, NG, ZA, AR, CL, CO (13个未配置)

💡 LLM 建议: 每季度末进行站点健康度评估，及时关闭低效站点。`

  sites.value.forEach(s => {
    if (s.status === 'building') s.status = 'open'
  })

  llmResult.value = result
}

const statusLabel = (s) => ({ open: '已开通', building: '搭建中', closed: '已关闭' }[s])
const templateLabel = (t) => ({ feishu: '飞书深色', dark: '经典深色', light: '护眼浅色', custom: '自定义' }[t])
const previewSite = (s) => { window.open(s.url, '_blank') }
</script>
