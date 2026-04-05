<template>
  <div>
    <!-- 页面标题 -->
    <div class="d-flex d-justify-between d-align-center d-mb-24">
      <div>
        <h1 style="font-size:20px;font-weight:700;color:var(--d-text);margin:0">控制台</h1>
        <p class="d-text-2 d-mt-4" style="font-size:13px;margin:0">欢迎回来，管理员。今天是 {{ today }}。</p>
      </div>
      <div class="d-flex d-g-8">
        <button class="d-btn d-btn-outline">📊 数据报表</button>
        <button class="d-btn d-btn-outline">🔔 消息中心</button>
      </div>
    </div>

    <!-- 概览统计 -->
    <div class="d-flex d-g-16 d-mb-24 d-wrap">
      <div class="d-card" style="flex:1;min-width:200px;cursor:pointer" @click="navigateTo('/admin/products')">
        <div class="d-card-body" style="padding:20px 24px">
          <div class="d-flex d-align-center d-justify-between">
            <div>
              <div style="font-size:28px;font-weight:700;color:var(--d-text)">{{ stats.products }}</div>
              <div class="d-text-2" style="font-size:13px;margin-top:4px">商品总数</div>
              <div class="d-text-xs d-text-success d-mt-4">↑ 12% 较上周</div>
            </div>
            <div style="width:48px;height:48px;border-radius:12px;background:rgba(51,112,255,0.12);display:flex;align-items:center;justify-content:center;font-size:22px">📦</div>
          </div>
        </div>
      </div>

      <div class="d-card" style="flex:1;min-width:200px;cursor:pointer" @click="navigateTo('/admin/orders')">
        <div class="d-card-body" style="padding:20px 24px">
          <div class="d-flex d-align-center d-justify-between">
            <div>
              <div style="font-size:28px;font-weight:700;color:var(--d-text)">{{ stats.orders }}</div>
              <div class="d-text-2" style="font-size:13px;margin-top:4px">今日订单</div>
              <div class="d-text-xs d-text-success d-mt-4">↑ 8% 较昨日</div>
            </div>
            <div style="width:48px;height:48px;border-radius:12px;background:rgba(82,196,26,0.12);display:flex;align-items:center;justify-content:center;font-size:22px">🧾</div>
          </div>
        </div>
      </div>

      <div class="d-card" style="flex:1;min-width:200px;cursor:pointer" @click="navigateTo('/admin/members')">
        <div class="d-card-body" style="padding:20px 24px">
          <div class="d-flex d-align-center d-justify-between">
            <div>
              <div style="font-size:28px;font-weight:700;color:var(--d-text)">{{ stats.members }}</div>
              <div class="d-text-2" style="font-size:13px;margin-top:4px">会员总数</div>
              <div class="d-text-xs d-text-success d-mt-4">↑ 23 新增今日</div>
            </div>
            <div style="width:48px;height:48px;border-radius:12px;background:rgba(255,122,69,0.12);display:flex;align-items:center;justify-content:center;font-size:22px">👥</div>
          </div>
        </div>
      </div>

      <div class="d-card" style="flex:1;min-width:200px;cursor:pointer">
        <div class="d-card-body" style="padding:20px 24px">
          <div class="d-flex d-align-center d-justify-between">
            <div>
              <div style="font-size:28px;font-weight:700;color:var(--d-text)">{{ stats.revenue }}</div>
              <div class="d-text-2" style="font-size:13px;margin-top:4px">今日销售额</div>
              <div class="d-text-xs d-text-success d-mt-4">↑ 15% 较昨日</div>
            </div>
            <div style="width:48px;height:48px;border-radius:12px;background:rgba(250,173,20,0.12);display:flex;align-items:center;justify-content:center;font-size:22px">💰</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 第二行 -->
    <div class="d-flex d-g-16 d-mb-24 d-wrap">
      <!-- 快捷操作 -->
      <div class="d-card" style="flex:1;min-width:300px">
        <div class="d-card-header">
          <h3>快捷操作</h3>
        </div>
        <div class="d-card-body">
          <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12px">
            <button class="d-flex d-flex-col d-align-center d-g-8 d-p-12 d-radius" style="border:1px solid var(--d-border);background:var(--d-bg);cursor:pointer;transition:all 0.15s" @click="navigateTo('/admin/products')">
              <span style="font-size:24px">📦</span>
              <span style="font-size:12px;color:var(--d-text-2)">发布商品</span>
            </button>
            <button class="d-flex d-flex-col d-align-center d-g-8 d-p-12 d-radius" style="border:1px solid var(--d-border);background:var(--d-bg);cursor:pointer;transition:all 0.15s" @click="navigateTo('/admin/orders')">
              <span style="font-size:24px">🧾</span>
              <span style="font-size:12px;color:var(--d-text-2)">处理订单</span>
            </button>
            <button class="d-flex d-flex-col d-align-center d-g-8 d-p-12 d-radius" style="border:1px solid var(--d-border);background:var(--d-bg);cursor:pointer;transition:all 0.15s" @click="navigateTo('/admin/support/tickets')">
              <span style="font-size:24px">🎧</span>
              <span style="font-size:12px;color:var(--d-text-2)">客服工单</span>
            </button>
            <button class="d-flex d-flex-col d-align-center d-g-8 d-p-12 d-radius" style="border:1px solid var(--d-border);background:var(--d-bg);cursor:pointer;transition:all 0.15s" @click="navigateTo('/admin/marketing')">
              <span style="font-size:24px">📢</span>
              <span style="font-size:12px;color:var(--d-text-2)">营销活动</span>
            </button>
            <button class="d-flex d-flex-col d-align-center d-g-8 d-p-12 d-radius" style="border:1px solid var(--d-border);background:var(--d-bg);cursor:pointer;transition:all 0.15s" @click="navigateTo('/admin/distribution')">
              <span style="font-size:24px">🏢</span>
              <span style="font-size:12px;color:var(--d-text-2)">分销管理</span>
            </button>
            <button class="d-flex d-flex-col d-align-center d-g-8 d-p-12 d-radius" style="border:1px solid var(--d-border);background:var(--d-bg);cursor:pointer;transition:all 0.15s" @click="navigateTo('/admin/settings/sites')">
              <span style="font-size:24px">🌐</span>
              <span style="font-size:12px;color:var(--d-text-2)">国际站点</span>
            </button>
          </div>
        </div>
      </div>

      <!-- 待办事项 -->
      <div class="d-card" style="flex:1;min-width:300px">
        <div class="d-card-header">
          <h3>待办事项</h3>
          <span class="d-badge d-badge-red">{{ todos.filter(t => !t.done).length }}</span>
        </div>
        <div class="d-card-body" style="padding:12px 20px">
          <div v-for="(todo, i) in todos" :key="i" :style="todo.done ? 'opacity:0.5;cursor:default' : 'cursor:pointer'" @click="todo.done || navigateTo(todo.path)">
            <div class="d-flex d-align-center d-g-12 d-mb-4" style="padding:8px;border-radius:6px;background:var(--d-bg);transition:background 0.15s" :style="!todo.done ? '' : ''">
              <input type="checkbox" class="d-checkbox" v-model="todo.done" style="flex-shrink:0" @click.stop />
              <span :style="{ fontSize:'13px', color: todo.done ? 'var(--d-text-3)' : 'var(--d-text)', textDecoration: todo.done ? 'line-through' : 'none', flex:1 }">{{ todo.text }}</span>
              <span class="d-badge" :class="todo.priority === 'high' ? 'd-badge-red' : todo.priority === 'mid' ? 'd-badge-orange' : 'd-badge-gray'" style="font-size:10px;flex-shrink:0">{{ todo.label }}</span>
            </div>
            <div v-if="!todo.done && todo.subText" class="d-text-xs d-text-3" style="padding:0 8px 4px 36px">{{ todo.subText }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 第三行 -->
    <div class="d-flex d-g-16 d-wrap">
      <!-- 最近订单 -->
      <div class="d-card" style="flex:2;min-width:400px">
        <div class="d-card-header">
          <h3>最近订单</h3>
          <button class="d-btn d-btn-sm d-btn-outline" @click="navigateTo('/admin/orders')">查看全部</button>
        </div>
        <div class="d-table-wrap">
          <table class="d-table">
            <thead>
              <tr>
                <th>订单号</th>
                <th>买家</th>
                <th>金额</th>
                <th>状态</th>
                <th>时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in recentOrders" :key="order.id">
                <td style="font-family:monospace;font-size:12px">{{ order.id }}</td>
                <td>{{ order.buyer }}</td>
                <td style="font-weight:600">{{ order.amount }}</td>
                <td><span class="d-badge" :class="order.statusClass">{{ order.status }}</span></td>
                <td class="d-text-2" style="font-size:12px">{{ order.time }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- 商品库存预警 -->
      <div class="d-card" style="flex:1;min-width:300px">
        <div class="d-card-header">
          <h3>库存预警</h3>
          <button class="d-btn d-btn-sm d-btn-outline" @click="navigateTo('/admin/products?tab=warning')">处理</button>
        </div>
        <div class="d-card-body" style="padding:12px 20px">
          <div v-for="p in lowStock" :key="p.id" class="d-flex d-align-center d-g-12 d-mb-8" style="padding:8px;border-radius:6px;background:var(--d-bg)">
            <img :src="p.image" style="width:36px;height:36px;border-radius:4px;object-fit:cover;flex-shrink:0" />
            <div style="flex:1;min-width:0">
              <div class="d-text-sm d-truncate" style="font-weight:500">{{ p.name }}</div>
              <div class="d-text-xs" :style="{ color: p.stock === 0 ? 'var(--d-red)' : 'var(--d-orange)' }">
                库存: {{ p.stock }} {{ p.stock === 0 ? '（已售罄）' : '（不足）' }}
              </div>
            </div>
          </div>
          <div v-if="lowStock.length === 0" class="d-empty" style="padding:24px">
            <div class="d-empty-icon">✅</div>
            <div class="d-empty-text">暂无预警</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
definePageMeta({ layout: 'admin' })
useHead({ title: '控制台 - NFR 管理后台' })

const today = new Date().toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' })

const stats = reactive({
  products: 128,
  orders: '2,847',
  members: '15,692',
  revenue: '¥328,450',
})

const todos = reactive([
  { text: '审核新分销商申请', priority: 'high', label: '紧急', done: false, path: '/admin/distribution/applications', subText: '3 个申请待审核' },
  { text: '处理待回复客服工单', priority: 'high', label: '紧急', done: false, path: '/admin/support/tickets', subText: '5 条工单待处理' },
  { text: '确认 1688 采购订单', priority: 'mid', label: '重要', done: false, path: '/admin/products/1688', subText: '#20240612 待确认' },
  { text: '更新英国站点商品价格', priority: 'mid', label: '重要', done: false, path: '/admin/settings/sites', subText: 'GB 站点 12 个商品待调价' },
  { text: '整理本月销售数据报表', priority: 'low', label: '常规', done: false, path: '/admin/reports', subText: '4月数据汇总' },
])

const recentOrders = [
  { id: 'NF2026040401', buyer: '张**', amount: '¥1,299', status: '待发货', statusClass: 'd-badge-orange', time: '2分钟前' },
  { id: 'NF2026040400', buyer: '李**', amount: '¥2,499', status: '已发货', statusClass: 'd-badge-blue', time: '15分钟前' },
  { id: 'NF2026040399', buyer: '王**', amount: '¥749', status: '已完成', statusClass: 'd-badge-green', time: '32分钟前' },
  { id: 'NF2026040398', buyer: '赵**', amount: '¥9,999', status: '待付款', statusClass: 'd-badge-gray', time: '1小时前' },
  { id: 'NF2026040397', buyer: '孙**', amount: '¥850', status: '已发货', statusClass: 'd-badge-blue', time: '2小时前' },
]

const lowStock = [
  { id: '10002', name: '索尼 WH-1000XM5 无线降噪耳机', stock: 8, image: 'https://picsum.photos/seed/p10002/120/120' },
  { id: '10005', name: '雅诗兰黛小棕瓶精华 50ml', stock: 5, image: 'https://picsum.photos/seed/p10005/120/120' },
  { id: '10003', name: 'Nike Air Force 1 纯白经典款', stock: 0, image: 'https://picsum.photos/seed/p10003/120/120' },
]
</script>
