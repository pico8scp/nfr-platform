<template>
  <div>
    <!-- 页面标题 -->
    <div class="d-flex d-justify-between d-align-center d-mb-24">
      <div>
        <h1 style="font-size:20px;font-weight:700;color:var(--d-text);margin:0">商品列表</h1>
        <p class="d-text-2 d-mt-4" style="font-size:13px;margin:0">实时掌控商品表现，支持批量操作和快捷编辑</p>
      </div>
      <div class="d-flex d-g-8">
        <button class="d-btn d-btn-outline">📥 批量导入</button>
        <button class="d-btn d-btn-outline">📤 导出Excel</button>
        <button class="d-btn d-btn-primary" @click="showCreate = true">+ 发布商品</button>
      </div>
    </div>

    <!-- 今日概览统计 -->
    <div class="d-flex d-g-16 d-mb-24 d-wrap">
      <div class="d-card" style="flex:1;min-width:180px">
        <div class="d-card-body d-d-flex d-align-center d-g-12" style="padding:16px 20px">
          <div style="width:40px;height:40px;border-radius:8px;background:rgba(51,112,255,0.12);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0">📦</div>
          <div>
            <div style="font-size:20px;font-weight:700;color:var(--d-text)">{{ stats.total }}</div>
            <div class="d-text-2" style="font-size:12px">商品总数</div>
          </div>
        </div>
      </div>
      <div class="d-card" style="flex:1;min-width:180px">
        <div class="d-card-body d-d-flex d-align-center d-g-12" style="padding:16px 20px">
          <div style="width:40px;height:40px;border-radius:8px;background:rgba(82,196,26,0.12);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0">💰</div>
          <div>
            <div style="font-size:20px;font-weight:700;color:var(--d-text)">{{ stats.sales7d }}</div>
            <div class="d-text-2" style="font-size:12px">7日销售额</div>
          </div>
        </div>
      </div>
      <div class="d-card" style="flex:1;min-width:180px">
        <div class="d-card-body d-d-flex d-align-center d-g-12" style="padding:16px 20px">
          <div style="width:40px;height:40px;border-radius:8px;background:rgba(255,122,69,0.12);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0">🛒</div>
          <div>
            <div style="font-size:20px;font-weight:700;color:var(--d-text)">{{ stats.orders7d }}</div>
            <div class="d-text-2" style="font-size:12px">7日订单量</div>
          </div>
        </div>
      </div>
      <div class="d-card" style="flex:1;min-width:180px">
        <div class="d-card-body d-d-flex d-align-center d-g-12" style="padding:16px 20px">
          <div style="width:40px;height:40px;border-radius:8px;background:rgba(255,82,82,0.12);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0">⚠️</div>
          <div>
            <div style="font-size:20px;font-weight:700;color:var(--d-red)">{{ stats.warning }}</div>
            <div class="d-text-2" style="font-size:12px">库存预警</div>
          </div>
        </div>
      </div>
      <div class="d-card" style="flex:1;min-width:180px">
        <div class="d-card-body d-d-flex d-align-center d-g-12" style="padding:16px 20px">
          <div style="width:40px;height:40px;border-radius:8px;background:rgba(51,112,255,0.12);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0">🤖</div>
          <div>
            <div style="font-size:20px;font-weight:700;color:var(--d-text)">{{ stats.aiScoreAvg }}</div>
            <div class="d-text-2" style="font-size:12px">AI健康度均值</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 状态 Tab -->
    <div class="d-card d-mb-16">
      <div class="d-card-body" style="padding:12px 20px">
        <div class="d-flex d-align-center d-g-8 d-wrap">
          <button
            v-for="tab in statusTabs"
            :key="tab.value"
            class="d-tab"
            :class="{ active: activeTab === tab.value }"
            @click="activeTab = tab.value"
            style="padding:6px 16px"
          >
            {{ tab.label }}
            <span v-if="tab.count" class="d-tab-count">{{ tab.count }}</span>
          </button>
        </div>
      </div>
    </div>

    <!-- 筛选区域 -->
    <div class="d-card d-mb-16">
      <div class="d-card-body" style="padding:16px 20px">
        <div class="d-flex d-g-12 d-wrap d-align-center">
          <div class="d-search" style="flex:1;min-width:200px;max-width:280px">
            <input v-model="search.keyword" class="d-input" placeholder="商品名称 / SKU / 商品ID" @keyup.enter="handleSearch" />
          </div>
          <select v-model="search.category" class="d-select" style="width:130px">
            <option value="">全部分类</option>
            <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
          </select>
          <select v-model="search.source" class="d-select" style="width:110px">
            <option value="">全部来源</option>
            <option value="self">自营商品</option>
            <option value="1688">1688采集</option>
            <option value="supplier">供应商</option>
          </select>
          <div class="d-flex d-align-center d-g-4">
            <input v-model="search.priceMin" class="d-input" style="width:85px" placeholder="价格从" />
            <span class="d-text-2">-</span>
            <input v-model="search.priceMax" class="d-input" style="width:85px" placeholder="到" />
          </div>
          <select v-model="search.stock" class="d-select" style="width:110px">
            <option value="">全部库存</option>
            <option value="warning">库存预警</option>
            <option value="out">已售罄</option>
            <option value="safe">库存充足</option>
          </select>
          <select v-model="search.aiScore" class="d-select" style="width:110px">
            <option value="">AI健康度</option>
            <option value="good">优秀 ≥80</option>
            <option value="ok">良好 60-80</option>
            <option value="bad">预警 &lt;60</option>
          </select>
          <select v-model="search.country" class="d-select" style="width:130px">
            <option value="">销售国家</option>
            <option v-for="c in countriesList" :key="c.code" :value="c.code">{{ c.flag }} {{ c.name }}</option>
          </select>
          <button class="d-btn d-btn-primary" @click="handleSearch">🔍 查询</button>
          <button class="d-btn d-btn-outline" @click="resetSearch">重置</button>
        </div>
      </div>
    </div>

    <!-- 批量操作栏 -->
    <div
      v-if="selectedIds.length > 0"
      class="d-flex d-align-center d-g-12 d-mb-16"
      style="padding:12px 16px;background:var(--d-active-bg);border-radius:var(--d-radius);border:1px solid var(--d-active)"
    >
      <span class="d-text-sm" style="color:var(--d-active)">已选择 {{ selectedIds.length }} 个商品</span>
      <div class="d-flex d-g-8">
        <button class="d-btn d-btn-sm d-btn-success" @click="batchOnShelf">批量上架</button>
        <button class="d-btn d-btn-sm d-btn-outline" @click="batchOffShelf">批量下架</button>
        <button class="d-btn d-btn-sm d-btn-danger" @click="batchDelete">批量删除</button>
      </div>
      <button class="d-btn d-btn-sm d-btn-outline" style="margin-left:auto" @click="clearSelection">取消选择</button>
    </div>

    <!-- 商品列表 -->
    <div class="d-card">
      <div class="d-table-wrap" style="max-width:100%;overflow-x:auto">
        <table class="d-table">
          <thead>
            <tr>
              <th style="width:36px">
                <input type="checkbox" class="d-checkbox" :checked="isAllSelected" @change="toggleSelectAll" />
              </th>
              <th style="width:60px">商品</th>
              <th style="min-width:160px">商品信息</th>
              <th style="width:65px">来源</th>
              <th style="width:110px">销售国家</th>
              <th style="width:70px">C端价格</th>
              <th style="width:65px">B端价格</th>
              <th style="width:55px">库存</th>
              <th style="width:65px">7日销量</th>
              <th style="width:75px">7日销售额</th>
              <th style="width:55px">AI</th>
              <th style="width:55px">利润率</th>
              <th style="width:55px">转化率</th>
              <th style="width:55px">评分</th>
              <th style="width:70px">C端状态</th>
              <th style="width:70px">B端状态</th>
              <th style="width:95px">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="p in filteredProducts" :key="p.id" style="height:60px">
              <td style="vertical-align:middle">
                <input type="checkbox" class="d-checkbox" :checked="selectedIds.includes(p.id)" @change="toggleSelect(p.id)" />
              </td>
              <td style="vertical-align:middle">
                <div style="width:48px;height:48px;border-radius:6px;overflow:hidden;background:var(--d-hover);cursor:pointer;flex-shrink:0" @click="openDetail(p)">
                  <img :src="p.image" style="width:100%;height:100%;object-fit:cover" :alt="p.name" />
                </div>
              </td>
              <td style="vertical-align:middle">
                <div style="cursor:pointer;min-width:0" @click="openDetail(p)">
                  <div style="font-weight:600;font-size:13px;color:var(--d-text);margin-bottom:3px;max-width:220px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis" :title="p.name">{{ p.name }}</div>
                  <div class="d-text-xs d-text-2">SKU: {{ p.sku }}</div>
                  <div class="d-flex d-g-4 d-wrap" style="margin-top:4px">
                    <span class="d-badge d-badge-gray" style="font-size:10px;padding:1px 6px">{{ p.category }}</span>
                    <span v-if="p.isNew" class="d-badge d-badge-green" style="font-size:10px;padding:1px 6px">新品</span>
                    <span v-if="p.isHot" class="d-badge d-badge-orange" style="font-size:10px;padding:1px 6px">热销</span>
                    <span v-if="p.aiScore < 60" class="d-badge d-badge-red" style="font-size:10px;padding:1px 6px">预警</span>
                  </div>
                </div>
              </td>
              <td style="vertical-align:middle">
                <span class="d-badge" :class="{
                  'd-badge-blue': p.source === 'self',
                  'd-badge-orange': p.source === '1688',
                  'd-badge-gray': p.source === 'supplier'
                }" style="font-size:11px;padding:2px 7px">{{ sourceLabel(p.source) }}</span>
              </td>
              <td style="vertical-align:middle">
                <div class="d-text-xs d-text-2 d-truncate" style="max-width:110px" :title="p.countries.map(c => countryName(c)).join('、')">{{ p.countries.map(c => countryName(c)).join('、') }}</div>
              </td>
              <td style="vertical-align:middle">
                <span style="font-weight:700;font-size:13px;color:var(--d-text)">{{ p.cPrice }}</span>
              </td>
              <td style="vertical-align:middle">
                <span class="d-text-2" style="font-size:12px">{{ p.bPrice }}</span>
              </td>
              <td style="vertical-align:middle">
                <span :style="{ fontWeight: 600, fontSize: '13px', color: p.stock === 0 ? 'var(--d-red)' : p.stock < 10 ? 'var(--d-orange)' : 'var(--d-text)' }">{{ p.stock }}</span>
                <span v-if="p.stock < 10" class="d-text-xs" style="color:var(--d-red);display:block;font-size:10px">预警</span>
              </td>
              <td style="vertical-align:middle">
                <span style="font-weight:600;font-size:13px;color:var(--d-text)">{{ p.sales7d.toLocaleString() }}</span>
                <div class="d-text-xs" :style="{ color: p.sales7d >= p.sales7dPrev ? 'var(--d-green)' : 'var(--d-red)' }">
                  {{ p.sales7d >= p.sales7dPrev ? '↑' : '↓' }}{{ Math.abs(p.sales7d - p.sales7dPrev) }}
                </div>
              </td>
              <td style="vertical-align:middle">
                <span style="font-weight:600;font-size:13px;color:var(--d-text)">¥{{ (p.sales7d * parseFloat(p.cPrice.replace(/[^0-9.]/g,''))).toLocaleString() }}</span>
              </td>
              <td style="vertical-align:middle">
                <div style="display:flex;align-items:center;gap:6px">
                  <div style="width:32px;height:32px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;position:relative" :style="{ background: aiColor(p.aiScore), color: '#fff' }">
                    {{ p.aiScore }}
                    <svg style="position:absolute;inset:0" viewBox="0 0 32 32" width="32" height="32">
                      <circle cx="16" cy="16" r="14" fill="none" stroke="rgba(255,255,255,0.2)" stroke-width="2.5" />
                      <circle cx="16" cy="16" r="14" fill="none" stroke="#fff" stroke-width="2.5" stroke-dasharray="87.96" :stroke-dashoffset="87.96 - (p.aiScore / 100 * 87.96)" stroke-linecap="round" transform="rotate(-90 16 16)" />
                    </svg>
                  </div>
                </div>
              </td>
              <td style="vertical-align:middle">
                <span :style="{ fontWeight: 600, fontSize: '13px', color: p.margin >= 20 ? 'var(--d-green)' : p.margin >= 10 ? 'var(--d-orange)' : 'var(--d-red)' }">{{ p.margin }}%</span>
              </td>
              <td style="vertical-align:middle">
                <span style="font-weight:600;font-size:13px;color:var(--d-text)">{{ p.convertRate }}%</span>
              </td>
              <td style="vertical-align:middle">
                <div style="position:relative;display:inline-block;font-size:11px;line-height:1;user-select:none">
                  <span style="color:#ddd">★★★★★</span>
                  <span style="position:absolute;left:0;top:0;color:#FFD700;overflow:hidden;white-space:nowrap" :style="{ width: Math.round(p.rating * 13) + 'px' }">★★★★★</span>
                </div>
                <div class="d-text-xs d-text-2">{{ p.rating }}</div>
              </td>
              <td style="vertical-align:middle">
                <button
                  class="d-btn d-btn-sm"
                  style="font-size:11px;padding:3px 8px;min-width:54px"
                  :style="{
                    background: p.cStatus === 'on' ? 'var(--d-green)' : 'transparent',
                    color: p.cStatus === 'on' ? '#fff' : 'var(--d-text-2)',
                    border: '1px solid ' + (p.cStatus === 'on' ? 'var(--d-green)' : 'var(--d-border2)'),
                  }"
                  @click="toggleCStatus(p)"
                >
                  {{ p.cStatus === 'on' ? '上架' : '下架' }}
                </button>
              </td>
              <td style="vertical-align:middle">
                <button
                  class="d-btn d-btn-sm"
                  style="font-size:11px;padding:3px 8px;min-width:54px"
                  :style="{
                    background: p.bStatus === 'on' ? 'var(--d-active)' : 'transparent',
                    color: p.bStatus === 'on' ? '#fff' : 'var(--d-text-2)',
                    border: '1px solid ' + (p.bStatus === 'on' ? 'var(--d-active)' : 'var(--d-border2)'),
                  }"
                  @click="toggleBStatus(p)"
                >
                  {{ p.bStatus === 'on' ? '上架' : '下架' }}
                </button>
              </td>
              <td style="vertical-align:middle">
                <div class="d-flex d-g-4">
                  <button class="d-btn d-btn-sm d-btn-outline" style="font-size:11px;padding:3px 8px" @click="openDetail(p)">编辑</button>
                  <button class="d-btn d-btn-sm d-btn-danger" style="font-size:11px;padding:3px 8px" @click="deleteProduct(p)">删</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- 分页 -->
      <div v-if="totalPages > 1" class="d-flex d-justify-between d-align-center" style="padding:16px 20px;border-top:1px solid var(--d-border)">
        <span class="d-text-sm d-text-2">共 {{ totalItems }} 条，第 {{ currentPage }}/{{ totalPages }} 页</span>
        <div class="d-pagination">
          <button class="d-page-btn" :disabled="currentPage === 1" @click="currentPage--">←</button>
          <button v-for="page in pageNumbers" :key="page" class="d-page-btn" :class="{ active: currentPage === page }" @click="currentPage = page">{{ page }}</button>
          <button class="d-page-btn" :disabled="currentPage === totalPages" @click="currentPage++">→</button>
        </div>
      </div>

      <!-- 空状态 -->
      <div v-if="filteredProducts.length === 0" class="d-empty">
        <div class="d-empty-icon">📦</div>
        <div class="d-empty-text">暂无商品数据</div>
        <button class="d-btn d-btn-primary d-mt-16" @click="showCreate = true">+ 发布商品</button>
      </div>
    </div>

    <!-- 创建/编辑抽屉 -->
    <div class="d-drawer-overlay" :class="{ on: showCreate }" @click="showCreate = false"></div>
    <div class="d-drawer" :class="{ on: showCreate }" style="width:600px">
      <div class="d-drawer-header">
        <h3>{{ editingProduct ? '编辑商品' : '发布商品' }}</h3>
        <button class="d-drawer-close" @click="showCreate = false">×</button>
      </div>
      <div class="d-drawer-body" style="padding:16px">

        <!-- 基本信息 -->
        <div class="d-mb-16">
          <div class="d-flex d-align-center d-mb-8" style="cursor:pointer" @click="secBasic=!secBasic">
            <span style="font-weight:600;font-size:13px;color:var(--d-text)">基本信息</span>
            <span style="margin-left:6px;font-size:10px;color:var(--d-text-3)">{{ secBasic?'收起 ▲':'展开 ▼' }}</span>
          </div>
          <div v-if="secBasic">
            <div class="d-form-group"><label class="d-label">商品标题 *</label><input v-model="form.name" class="d-input" placeholder="请输入商品标题" /></div>
            <div class="d-flex d-g-12">
              <div class="d-form-group" style="flex:1"><label class="d-label">SKU编码</label><input v-model="form.sku" class="d-input" placeholder="系统自动生成" /><button class="d-btn d-btn-sm d-btn-outline d-mt-4" @click="form.sku='SKU'+Date.now()">生成编码</button></div>
              <div class="d-form-group" style="flex:1"><label class="d-label">商品条码</label><input v-model="form.barcode" class="d-input" placeholder="选填，支持扫码" /></div>
            </div>
            <div class="d-form-group"><label class="d-label">商品分类</label><select v-model="form.category" class="d-select"><option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option></select></div>
            <div class="d-form-group"><label class="d-label">商品简介</label><textarea v-model="form.intro" class="d-textarea" placeholder="简短描述商品卖点，用于列表页展示" style="min-height:60px"></textarea></div>
          </div>
        </div>

        <!-- 价格与库存 -->
        <div class="d-mb-16 d-b-top d-pt-16">
          <div class="d-flex d-align-center d-mb-8" style="cursor:pointer" @click="secPrice=!secPrice">
            <span style="font-weight:600;font-size:13px;color:var(--d-text)">价格与库存</span>
            <span style="margin-left:6px;font-size:10px;color:var(--d-text-3)">{{ secPrice?'收起 ▲':'展开 ▼' }}</span>
          </div>
          <div v-if="secPrice">
            <div class="d-flex d-g-12">
              <div class="d-form-group" style="flex:1"><label class="d-label">成本价（管理端）</label><input v-model="form.costPrice" class="d-input" placeholder="¥" /><span class="d-text-xs d-text-2" style="display:block;margin-top:2px">仅管理端可见</span></div>
              <div class="d-form-group" style="flex:1"><label class="d-label">C端零售价 *</label><input v-model="form.cPrice" class="d-input" placeholder="¥" /></div>
              <div class="d-form-group" style="flex:1"><label class="d-label">B端批发价 *</label><input v-model="form.bPrice" class="d-input" placeholder="$" /></div>
            </div>
            <div class="d-form-group"><label class="d-label">库存信息</label><input v-model="form.stock" class="d-input" type="number" placeholder="库存数量" /></div>
          </div>
        </div>

        <!-- 上架国家 -->
        <div class="d-mb-16 d-b-top d-pt-16">
          <div class="d-flex d-align-center d-mb-8" style="cursor:pointer" @click="secCountry=!secCountry">
            <span style="font-weight:600;font-size:13px;color:var(--d-text)">上架国家</span>
            <span style="margin-left:6px;font-size:10px;color:var(--d-text-3)">{{ secCountry?'收起 ▲':'展开 ▼' }}</span>
            <span class="d-badge d-badge-blue d-ml-4" style="font-size:10px;padding:1px 6px">{{ form.countries ? form.countries.length : 0 }} 个</span>
          </div>
          <div v-if="secCountry">
            <div style="display:flex;flex-wrap:wrap;gap:6px">
              <label v-for="c in countriesList" :key="c.code" class="d-flex d-align-center d-g-4" style="padding:4px 8px;border-radius:6px;border:1px solid var(--d-border2);cursor:pointer;font-size:12px;color:var(--d-text-2);transition:all 0.15s" :style="form.countries&&form.countries.includes(c.code)?'border-color:var(--d-active);color:var(--d-active);background:var(--d-active-bg)':''">
                <input type="checkbox" class="d-checkbox" :checked="form.countries&&form.countries.includes(c.code)" @change="toggleCountry(c.code)" style="width:13px;height:13px" />
                {{ c.flag }} {{ c.name }}
              </label>
            </div>
          </div>
        </div>

        <!-- 物流与重量 -->
        <div class="d-mb-16 d-b-top d-pt-16">
          <div class="d-flex d-align-center d-mb-8" style="cursor:pointer" @click="secLogistics=!secLogistics">
            <span style="font-weight:600;font-size:13px;color:var(--d-text)">物流与配送</span>
            <span style="margin-left:6px;font-size:10px;color:var(--d-text-3)">{{ secLogistics?'收起 ▲':'展开 ▼' }}</span>
          </div>
          <div v-if="secLogistics">
            <div class="d-flex d-g-12 d-mb-8">
              <label class="d-flex d-align-center d-g-4" style="padding:6px 12px;border-radius:6px;border:1px solid var(--d-border2);cursor:pointer;font-size:13px;color:var(--d-text-2)" :style="form.freeShipping?'border-color:var(--d-active);color:var(--d-active);background:var(--d-active-bg)':''">
                <input type="checkbox" class="d-checkbox" v-model="form.freeShipping" style="width:14px;height:14px" />包邮
              </label>
              <label class="d-flex d-align-center d-g-4" style="padding:6px 12px;border-radius:6px;border:1px solid var(--d-border2);cursor:pointer;font-size:13px;color:var(--d-text-2)" :style="form.preSale?'border-color:var(--d-orange);color:var(--d-orange);background:rgba(255,122,69,0.1)':''">
                <input type="checkbox" class="d-checkbox" v-model="form.preSale" style="width:14px;height:14px" />预售
              </label>
            </div>
            <div class="d-flex d-g-12">
              <div class="d-form-group" style="flex:1"><label class="d-label">重量 (kg)</label><input v-model="form.weight" class="d-input" placeholder="0.5" type="number" step="0.01" /></div>
              <div class="d-form-group" style="flex:1"><label class="d-label">尺寸 (cm)</label><input v-model="form.dimensions" class="d-input" placeholder="长×宽×高" /></div>
            </div>
            <div class="d-form-group" v-if="!form.freeShipping"><label class="d-label">运费模板</label><select v-model="form.shippingFee" class="d-select"><option value="0">统一运费 ¥0</option><option value="10">统一运费 ¥10</option><option value="20">统一运费 ¥20</option><option value="template">按模板计算</option></select></div>
          </div>
        </div>

        <!-- 商品属性 -->
        <div class="d-mb-16 d-b-top d-pt-16">
          <div class="d-flex d-align-center d-mb-8" style="cursor:pointer" @click="secAttr=!secAttr">
            <span style="font-weight:600;font-size:13px;color:var(--d-text)">商品属性</span>
            <span style="margin-left:6px;font-size:10px;color:var(--d-text-3)">{{ secAttr?'收起 ▲':'展开 ▼' }}</span>
            <span v-if="attrCount > 0" class="d-badge d-badge-blue d-ml-4" style="font-size:10px">{{ attrCount }} 项</span>
          </div>
          <div v-if="secAttr">

            <!-- 分类选择 + 1688同步 -->
            <div class="d-flex d-g-12 d-mb-12">
              <div class="d-form-group" style="flex:1;margin-bottom:0">
                <label class="d-label">关联分类（自动加载预设属性）</label>
                <select v-model="form.attrCategory" class="d-select" @change="loadPresetAttrs">
                  <option value="">— 选择分类加载预设 —</option>
                  <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
                </select>
              </div>
              <div style="display:flex;align-items:flex-end;gap:6px;padding-bottom:6px">
                <button class="d-btn d-btn-outline d-btn-sm" @click="sync1688Attrs" title="从1688采集数据同步">🔄 1688同步</button>
                <button class="d-btn d-btn-outline d-btn-sm" @click="clearAllAttrs" title="清空所有属性">🗑 清空</button>
              </div>
            </div>

            <!-- 预设属性表格 -->
            <div v-if="Object.keys(currentPresetAttrs).length > 0 || Object.keys(form.customAttrs).length > 0" class="d-mb-12">
              <div style="font-size:12px;font-weight:600;color:var(--d-text-2);margin-bottom:6px">属性列表</div>
              <div class="d-card" style="border-radius:8px;overflow:hidden">
                <table style="width:100%;border-collapse:collapse;font-size:12px">
                  <thead>
                    <tr style="border-bottom:1px solid var(--d-border)">
                      <th style="padding:8px 12px;text-align:left;color:var(--d-text-2);font-weight:600;width:35%">属性名</th>
                      <th style="padding:8px 12px;text-align:left;color:var(--d-text-2);font-weight:600">属性值</th>
                      <th style="padding:8px 12px;text-align:center;color:var(--d-text-2);font-weight:600;width:50px">来源</th>
                      <th style="padding:8px 12px;text-align:center;color:var(--d-text-2);font-weight:600;width:50px">操作</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(val, key) in currentPresetAttrs" :key="key" style="border-bottom:1px solid var(--d-border)">
                      <td style="padding:8px 12px;color:var(--d-text)">{{ key }}</td>
                      <td style="padding:6px 10px">
                        <input v-model="currentPresetAttrs[key]" class="d-input" style="font-size:12px;padding:4px 8px" :placeholder="'请输入' + key" />
                      </td>
                      <td style="padding:8px 12px;text-align:center">
                        <span v-if="val && val.startsWith('[1688]')" class="d-badge d-badge-blue" style="font-size:10px">1688</span>
                        <span v-else-if="val" class="d-badge d-badge-gray" style="font-size:10px">预设</span>
                        <span v-else class="d-text-xs d-text-3">—</span>
                      </td>
                      <td style="padding:8px 12px;text-align:center">
                        <button @click="deletePresetAttr(key)" style="color:var(--d-red);background:none;border:none;cursor:pointer;font-size:14px">×</button>
                      </td>
                    </tr>
                    <tr v-for="(item, idx) in form.customAttrs" :key="'custom-' + idx" style="border-bottom:1px solid var(--d-border)">
                      <td style="padding:8px 12px">
                        <input v-model="item.key" class="d-input" style="font-size:12px;padding:4px 8px" placeholder="属性名" />
                      </td>
                      <td style="padding:6px 10px">
                        <input v-model="item.value" class="d-input" style="font-size:12px;padding:4px 8px" placeholder="属性值" />
                      </td>
                      <td style="padding:8px 12px;text-align:center">
                        <span class="d-badge d-badge-orange" style="font-size:10px">自定</span>
                      </td>
                      <td style="padding:8px 12px;text-align:center">
                        <button @click="removeCustomAttr(idx)" style="color:var(--d-red);background:none;border:none;cursor:pointer;font-size:14px">×</button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- 添加自定义属性 -->
            <div class="d-flex d-g-8 d-mb-12">
              <input v-model="newAttrKey" class="d-input" style="flex:1;font-size:12px;padding:5px 10px" placeholder="自定义属性名" />
              <input v-model="newAttrVal" class="d-input" style="flex:1;font-size:12px;padding:5px 10px" placeholder="属性值" />
              <button class="d-btn d-btn-outline d-btn-sm" @click="addCustomAttr" :disabled="!newAttrKey">+ 添加</button>
            </div>

            <!-- 业务标签 -->
            <div class="d-flex d-g-12">
              <label class="d-flex d-align-center d-g-4" style="padding:6px 12px;border-radius:6px;border:1px solid var(--d-border2);cursor:pointer;font-size:13px;color:var(--d-text-2)" :style="form.bundle?'border-color:var(--d-active);color:var(--d-active);background:var(--d-active-bg)':''">
                <input type="checkbox" class="d-checkbox" v-model="form.bundle" style="width:14px;height:14px" />捆绑销售
              </label>
              <label class="d-flex d-align-center d-g-4" style="padding:6px 12px;border-radius:6px;border:1px solid var(--d-border2);cursor:pointer;font-size:13px;color:var(--d-text-2)" :style="form.related?'border-color:var(--d-active);color:var(--d-active);background:var(--d-active-bg)':''">
                <input type="checkbox" class="d-checkbox" v-model="form.related" style="width:14px;height:14px" />关联推荐
              </label>
            </div>
          </div>
        </div>

        <!-- 主图管理 -->
        <div class="d-mb-16 d-b-top d-pt-16">
          <div class="d-flex d-align-center d-mb-8" style="cursor:pointer" @click="secMainImg=!secMainImg">
            <span style="font-weight:600;font-size:13px;color:var(--d-text)">主图管理</span>
            <span style="margin-left:6px;font-size:10px;color:var(--d-text-3)">{{ secMainImg?'收起 ▲':'展开 ▼' }}</span>
          </div>
          <div v-if="secMainImg">
            <div class="d-flex d-g-12">
              <!-- 主图预览区 -->
              <div style="flex:1">
                <label class="d-label">主图预览</label>
                <div v-if="form.mainImages && form.mainImages.length > 0">
                  <div class="d-flex d-g-8 d-wrap">
                    <div v-for="(img, idx) in form.mainImages.slice(0, 5)" :key="idx" class="d-flex d-flex-col d-align-center" style="width:80px">
                      <div style="width:72px;height:72px;border-radius:6px;overflow:hidden;border:2px solid var(--d-border);position:relative;cursor:pointer"
                           :style="form.mainImageIndex === idx ? 'border-color:var(--d-active)' : ''"
                           @click="form.mainImageIndex = idx">
                        <img :src="img" style="width:100%;height:100%;object-fit:cover" @error="removeMainImage(idx)" />
                        <div v-if="idx === 0" style="position:absolute;bottom:0;left:0;right:0;background:var(--d-active);color:#fff;font-size:10px;text-align:center;padding:2px 0">主图</div>
                        <button @click.stop="removeMainImage(idx)" style="position:absolute;top:2px;right:2px;width:18px;height:18px;border-radius:50%;background:var(--d-red);color:#fff;border:none;font-size:12px;cursor:pointer;line-height:1">×</button>
                      </div>
                    </div>
                    <!-- 添加主图按钮 -->
                    <div v-if="form.mainImages.length < 5" class="d-flex d-align-center d-justify-center" style="width:72px;height:72px;border:2px dashed var(--d-border2);border-radius:6px;cursor:pointer;color:var(--d-text-3)"
                         @click="triggerMainImageUpload">
                      <span style="font-size:24px">+</span>
                    </div>
                  </div>
                  <div class="d-text-xs d-text-2 d-mt-4">支持jpg/png/gif，最多5张，首图自动设为主图</div>
                </div>
                <!-- 空状态 -->
                <div v-else class="d-flex d-flex-col d-align-center d-justify-center" style="width:100%;padding:32px 0;border:2px dashed var(--d-border2);border-radius:8px;cursor:pointer" @click="triggerMainImageUpload">
                  <span style="font-size:32px;color:var(--d-text-3)">📷</span>
                  <span class="d-text-2 d-mt-8">点击上传主图</span>
                  <span class="d-text-xs d-text-3">支持 jpg/png/gif，最多5张</span>
                </div>
                <!-- 隐藏的文件输入 -->
                <input ref="mainImageInput" type="file" accept="image/*" style="display:none" @change="onMainImageSelected" />
              </div>

              <!-- 右侧：主图设置 -->
              <div style="width:200px">
                <label class="d-label">主图设置</label>
                <div class="d-card" style="padding:12px">
                  <div class="d-text-sm d-mb-8">当前主图: <span class="d-text-bold">{{ form.mainImageIndex !== undefined ? form.mainImageIndex + 1 : 1 }}</span></div>
                  <div class="d-text-xs d-text-2 d-mb-8">点击图片即可切换主图顺序</div>

                  <div v-if="form.mainImages && form.mainImages.length > 1" class="d-flex d-g-4">
                    <button class="d-btn d-btn-sm d-btn-outline" style="flex:1;font-size:11px;padding:3px 6px" @click="moveMainImage(-1)" :disabled="form.mainImageIndex === 0">上移</button>
                    <button class="d-btn d-btn-sm d-btn-outline" style="flex:1;font-size:11px;padding:3px 6px" @click="moveMainImage(1)" :disabled="form.mainImageIndex === form.mainImages.length - 1">下移</button>
                  </div>
                </div>

                <div class="d-card d-mt-8" style="padding:12px;background:var(--d-active-bg)">
                  <div class="d-text-sm d-text-bold" style="color:var(--d-active)">💡 主图技巧</div>
                  <div class="d-text-xs d-text-2 d-mt-4" style="line-height:1.5">• 第1张为主图，影响点击率<br/>• 建议尺寸 800×800 以上<br/>• 白底图更容易通过审核</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 详情图片管理 -->
        <div class="d-mb-16 d-b-top d-pt-16">
          <div class="d-flex d-align-center d-mb-8" style="cursor:pointer" @click="secDetailImg=!secDetailImg">
            <span style="font-weight:600;font-size:13px;color:var(--d-text)">详情图片管理</span>
            <span v-if="form.detailImages && form.detailImages.length > 0" class="d-badge d-badge-blue d-ml-4" style="font-size:10px">{{ form.detailImages.length }} 张</span>
            <span style="margin-left:6px;font-size:10px;color:var(--d-text-3)">{{ secDetailImg?'收起 ▲':'展开 ▼' }}</span>
          </div>

          <div v-if="secDetailImg">
            <!-- 批量输入 -->
            <div class="d-form-group">
              <label class="d-label">批量添加图片URL（每行一个）</label>
              <textarea v-model="form.detailImageBatch" class="d-textarea" placeholder="https://example.com/img1.jpg
https://example.com/img2.jpg" style="min-height:60px;font-size:12px"></textarea>
              <div class="d-flex d-justify-end d-mt-4">
                <button class="d-btn d-btn-sm d-btn-outline" @click="addDetailImagesBatch">📥 批量添加</button>
              </div>
            </div>

            <!-- 图片列表（1688风格拖拽排序） -->
            <div v-if="form.detailImages && form.detailImages.length > 0" class="d-mb-12">
              <label class="d-label">已添加的图片（拖拽可排序）</label>

              <div style="display:flex;flex-wrap:wrap;gap:8px">
                <div v-for="(img, idx) in form.detailImages" :key="idx"
                     class="d-flex d-flex-col"
                     style="width:100px;cursor:move;border:1px solid var(--d-border);border-radius:6px;overflow:hidden;background:var(--d-card)"
                     draggable="true"
                     @dragstart="dragStart(idx)"
                     @dragover.prevent
                     @drop="drop(idx)"
                >
                  <!-- 图片 -->
                  <div style="width:100px;height:100px;overflow:hidden;background:var(--d-bg);display:flex;align-items:center;justify-content:center">
                    <img :src="img" style="width:100%;height:100%;object-fit:cover" @error="removeDetailImage(idx)" draggable="false" />
                  </div>

                  <!-- 序号和操作 -->
                  <div style="padding:6px 8px;display:flex;justify-content:space-between;align-items:center;border-top:1px solid var(--d-border)">
                    <span style="font-size:11px;color:var(--d-text-2)">{{ idx + 1 }}</span>
                    <button @click="removeDetailImage(idx)" style="width:16px;height:16px;border-radius:50%;background:var(--d-red);color:#fff;border:none;font-size:10px;cursor:pointer;line-height:1;display:flex;align-items:center;justify-content:center">×</button>
                  </div>
                </div>

                <!-- 添加按钮 -->
                <div class="d-flex d-align-center d-justify-center" style="width:100px;height:100px;border:2px dashed var(--d-border2);border-radius:6px;cursor:pointer;color:var(--d-text-3);flex-direction:column"
                     @click="triggerDetailImageUpload"
                >
                  <span style="font-size:24px">+</span>
                  <span style="font-size:11px;margin-top:4px">添加图片</span>
                </div>
                <input ref="detailImageInput" type="file" accept="image/*" multiple style="display:none" @change="onDetailImageSelected" />
              </div>

              <div class="d-text-xs d-text-2 d-mt-8" style="line-height:1.5">
                💡 提示：拖拽图片可调整顺序，建议宽度750px以上，单张不超过2MB，支持jpg/png/gif
              </div>
            </div>

            <!-- 空状态 -->
            <div v-else class="d-flex d-flex-col d-align-center d-justify-center" style="width:100%;padding:40px 0;border:2px dashed var(--d-border2);border-radius:8px;cursor:pointer" @click="triggerDetailImageUpload">
              <span style="font-size:40px;color:var(--d-text-3)">🖼️</span>
              <span class="d-text-2 d-mt-12">点击添加详情图片</span>
              <span class="d-text-xs d-text-3">支持拖拽排序、批量上传、最多50张</span>
            </div>
          </div>
        </div>

        <!-- SEO优化 -->
        <div class="d-mb-16 d-b-top d-pt-16">
          <div class="d-flex d-align-center d-mb-8" style="cursor:pointer" @click="secSeo=!secSeo">
            <span style="font-weight:600;font-size:13px;color:var(--d-text)">SEO优化</span>
            <span style="margin-left:6px;font-size:10px;color:var(--d-text-3)">{{ secSeo?'收起 ▲':'展开 ▼' }}</span>
          </div>
          <div v-if="secSeo">
            <div class="d-form-group"><label class="d-label">Meta 标题</label><input v-model="form.metaTitle" class="d-input" placeholder="SEO标题，留空则使用商品标题" /></div>
            <div class="d-form-group"><label class="d-label">Meta 描述</label><textarea v-model="form.metaDesc" class="d-textarea" placeholder="SEO描述，控制在160字以内" style="min-height:60px"></textarea></div>
            <div class="d-form-group"><label class="d-label">关键词</label><input v-model="form.keywords" class="d-input" placeholder="用英文逗号分隔，如：手机,苹果,iphone" /></div>
          </div>
        </div>

        <!-- LLM 定价方案 -->
        <div class="d-mb-16 d-b-top d-pt-16">
          <div class="d-flex d-align-center d-mb-8" style="cursor:pointer" @click="secLlm=!secLlm">
            <span style="font-weight:600;font-size:13px">🤖 LLM 定价方案</span>
            <span style="margin-left:6px;font-size:10px;color:var(--d-text-3)">{{ secLlm?'收起 ▲':'展开 ▼' }}</span>
            <span v-if="llmCost && llmPrice" class="d-badge d-badge-blue d-ml-4" style="font-size:10px">推荐: {{ llmPrice }}</span>
          </div>
          <div v-if="secLlm">
            <div class="d-form-group"><label class="d-label">描述你的定价策略或目标利润</label><textarea v-model="form.llmPrompt" class="d-textarea" placeholder="例如：我想给美国市场定一个有竞争力的价格，目标利润率30%以上，考虑竞争对手价格和物流成本" style="min-height:60px"></textarea></div>
            <button class="d-btn d-btn-primary d-mb-12" style="width:100%" @click="llmPricing" :disabled="llmLoading">
              {{ llmLoading ? '🤖 LLM 分析中...' : '🚀 提交给 LLM 分析定价' }}
            </button>
            <div v-if="llmResult" class="d-text-sm d-text-2" style="background:var(--d-bg);border-radius:8px;padding:12px;line-height:1.7">{{ llmResult }}</div>
            <div v-if="llmCost && llmPrice" class="d-flex d-g-12 d-mt-8">
              <div class="d-flex d-align-center d-g-4"><span class="d-text-2 d-text-sm">成本:</span><span class="d-text-bold">{{ llmCost }}</span></div>
              <div class="d-flex d-align-center d-g-4"><span class="d-text-2 d-text-sm">推荐C端:</span><span class="d-text-bold d-text-primary">{{ llmPrice }}</span></div>
              <div class="d-flex d-align-center d-g-4"><span class="d-text-2 d-text-sm">利润率:</span><span class="d-text-bold d-text-success">{{ llmMargin }}</span></div>
            </div>
          </div>
        </div>

        <!-- 上架设置 -->
        <div class="d-b-top d-pt-16">
          <div class="d-form-group"><label class="d-label">上架设置</label>
            <div class="d-flex d-g-16">
              <label class="d-flex d-align-center d-g-4"><input v-model="form.cStatus" type="checkbox" true-value="on" false-value="off" class="d-checkbox" style="width:15px;height:15px" /> C端上架</label>
              <label class="d-flex d-align-center d-g-4"><input v-model="form.bStatus" type="checkbox" true-value="on" false-value="off" class="d-checkbox" style="width:15px;height:15px" /> B端上架</label>
            </div>
          </div>
        </div>

      </div>
      <div class="d-drawer-footer">
        <button class="d-btn d-btn-outline" @click="showCreate = false">取消</button>
        <button class="d-btn d-btn-primary" @click="saveProduct">保存</button>
      </div>
    </div>
  </div>
</template>
<script setup>
definePageMeta({ layout: 'admin' })
useHead({ title: '商品列表 - NFR 管理后台' })

// 状态 Tab
const statusTabs = [
  { label: '全部', value: 'all', count: 0 },
  { label: '在售', value: 'on', count: 0 },
  { label: '已下架', value: 'off', count: 0 },
  { label: '库存预警', value: 'warning', count: 0 },
  { label: 'AI预警', value: 'aiwarn', count: 0 },
]

const activeTab = ref('all')

// 搜索条件
const search = reactive({
  keyword: '', category: '', source: '',
  priceMin: '', priceMax: '', stock: '', aiScore: '', country: ''
})

const categories = ['数码电子', '家居生活', '服饰配件', '美妆护肤', '运动户外']

// 国家列表
const countriesList = [
  { code: 'US', name: '美国', flag: '🇺🇸' },
  { code: 'GB', name: '英国', flag: '🇬🇧' },
  { code: 'DE', name: '德国', flag: '🇩🇪' },
  { code: 'FR', name: '法国', flag: '🇫🇷' },
  { code: 'ES', name: '西班牙', flag: '🇪🇸' },
  { code: 'IT', name: '意大利', flag: '🇮🇹' },
  { code: 'JP', name: '日本', flag: '🇯🇵' },
  { code: 'KR', name: '韩国', flag: '🇰🇷' },
  { code: 'AU', name: '澳大利亚', flag: '🇦🇺' },
  { code: 'CA', name: '加拿大', flag: '🇨🇦' },
  { code: 'BR', name: '巴西', flag: '🇧🇷' },
  { code: 'MX', name: '墨西哥', flag: '🇲🇽' },
  { code: 'RU', name: '俄罗斯', flag: '🇷🇺' },
  { code: 'IN', name: '印度', flag: '🇮🇳' },
  { code: 'SA', name: '沙特', flag: '🇸🇦' },
  { code: 'AE', name: '阿联酋', flag: '🇦🇪' },
]

// 国旗
const countryFlag = (code) => {
  const map = {
    US:'🇺🇸', GB:'🇬🇧', DE:'🇩🇪', FR:'🇫🇷', ES:'🇪🇸', IT:'🇮🇹',
    JP:'🇯🇵', KR:'🇰🇷', AU:'🇦🇺', CA:'🇨🇦', BR:'🇧🇷', MX:'🇲🇽',
    RU:'🇷🇺', IN:'🇮🇳', SA:'🇸🇦', AE:'🇦🇪'
  }
  return map[code] || '🌐'
}

const countryNameMap = {
  US:'美国', GB:'英国', DE:'德国', FR:'法国', ES:'西班牙', IT:'意大利',
  JP:'日本', KR:'韩国', AU:'澳大利亚', CA:'加拿大', BR:'巴西', MX:'墨西哥',
  RU:'俄罗斯', IN:'印度', SA:'沙特阿拉伯', AE:'阿联酋', NL:'荷兰', PL:'波兰',
  TR:'土耳其', SE:'瑞典', NO:'挪威', DK:'丹麦', FI:'芬兰', BE:'比利时',
  AT:'奥地利', CH:'瑞士', PT:'葡萄牙', GR:'希腊', CZ:'捷克', HU:'匈牙利',
  RO:'罗马尼亚', UA:'乌克兰', EG:'埃及', NG:'尼日利亚', KE:'肯尼亚', TH:'泰国',
  VN:'越南', MY:'马来西亚', ID:'印度尼西亚', SG:'新加坡', PH:'菲律宾', PK:'巴基斯坦'
}

const countryName = (code) => countryNameMap[code] || code
const displayCountries = (arr) => {
  const all = arr.map(c => countryName(c))
  return all.length > 5 ? all.slice(0, 5).join('; ') + '...' : all.join('; ')
}

// 顶部统计
const stats = computed(() => {
  const list = products.value
  const onList = list.filter(p => p.cStatus === 'on')
  return {
    total: list.length,
    sales7d: '¥' + Math.round(onList.reduce((s, p) => s + p.sales7d * parseFloat(p.cPrice.replace(/[^0-9.]/g, '')), 0)).toLocaleString(),
    orders7d: onList.reduce((s, p) => s + p.sales7d, 0).toLocaleString() + ' 单',
    warning: list.filter(p => p.stock < 10).length,
    aiScoreAvg: Math.round(onList.reduce((s, p) => s + p.aiScore, 0) / (onList.length || 1))
  }
})

// 商品数据
const products = ref([
  {
    id: '10001', name: 'iPhone 15 Pro Max 256GB 钛金属原色', sku: 'IPH15PM-256-NA',
    category: '数码电子', source: 'self', cPrice: '¥9,999', bPrice: '$1,380',
    stock: 156, cStatus: 'on', bStatus: 'on', image: 'https://picsum.photos/seed/p10001/120/120',
    isNew: true, isHot: true, sales7d: 23, sales7dPrev: 18, aiScore: 91, margin: 28, convertRate: 12.5, rating: 4.8, reviews: 2847,
    countries: ['US', 'GB', 'DE', 'FR', 'JP', 'AU', 'CA']
  },
  {
    id: '10002', name: '索尼 WH-1000XM5 无线降噪耳机', sku: 'SONY-XM5-BLK',
    category: '数码电子', source: '1688', cPrice: '¥2,499', bPrice: '$340',
    stock: 8, cStatus: 'on', bStatus: 'off', image: 'https://picsum.photos/seed/p10002/120/120',
    isNew: false, isHot: true, sales7d: 45, sales7dPrev: 52, aiScore: 58, margin: 8, convertRate: 6.3, rating: 4.6, reviews: 1543,
    countries: ['US', 'GB', 'JP', 'KR', 'DE']
  },
  {
    id: '10003', name: 'Nike Air Force 1 纯白经典款', sku: 'NK-AF1-WHT-42',
    category: '运动户外', source: 'supplier', cPrice: '¥749', bPrice: '$95',
    stock: 0, cStatus: 'off', bStatus: 'off', image: 'https://picsum.photos/seed/p10003/120/120',
    isNew: false, isHot: false, sales7d: 0, sales7dPrev: 12, aiScore: 35, margin: 15, convertRate: 0, rating: 4.3, reviews: 892,
    countries: ['US', 'CA', 'GB', 'AU', 'DE', 'FR', 'IT', 'ES', 'BR', 'MX']
  },
  {
    id: '10004', name: '小米空气净化器 4 Pro', sku: 'MI-AIR4-PRO',
    category: '家居生活', source: 'self', cPrice: '¥1,299', bPrice: '$175',
    stock: 342, cStatus: 'on', bStatus: 'on', image: 'https://picsum.photos/seed/p10004/120/120',
    isNew: true, isHot: false, sales7d: 67, sales7dPrev: 45, aiScore: 88, margin: 32, convertRate: 9.1, rating: 4.7, reviews: 621,
    countries: ['US', 'DE', 'JP', 'KR', 'AU', 'CA', 'GB', 'FR']
  },
  {
    id: '10005', name: '雅诗兰黛小棕瓶精华 50ml', sku: 'EL-ANR-50ML',
    category: '美妆护肤', source: '1688', cPrice: '¥850', bPrice: '$115',
    stock: 5, cStatus: 'on', bStatus: 'on', image: 'https://picsum.photos/seed/p10005/120/120',
    isNew: false, isHot: true, sales7d: 89, sales7dPrev: 78, aiScore: 72, margin: 18, convertRate: 14.2, rating: 4.9, reviews: 3204,
    countries: ['US', 'GB', 'FR', 'CA', 'AU', 'DE', 'JP', 'SA', 'AE']
  },
  {
    id: '10006', name: '优衣库 HEATTECH 保暖内衣', sku: 'UNIQLO-HT-BLK-M',
    category: '服饰配件', source: 'supplier', cPrice: '¥99', bPrice: '$13',
    stock: 1200, cStatus: 'on', bStatus: 'on', image: 'https://picsum.photos/seed/p10006/120/120',
    isNew: false, isHot: false, sales7d: 234, sales7dPrev: 198, aiScore: 95, margin: 45, convertRate: 22.8, rating: 4.5, reviews: 1208,
    countries: ['US', 'GB', 'DE', 'FR', 'JP', 'KR', 'AU', 'CA', 'IT', 'ES', 'BR', 'MX', 'RU', 'IN', 'SA', 'AE']
  },
  {
    id: '10007', name: '戴森 V15 吸尘器', sku: 'DYS-V15-FLU',
    category: '家居生活', source: 'self', cPrice: '¥4,999', bPrice: '$680',
    stock: 23, cStatus: 'on', bStatus: 'on', image: 'https://picsum.photos/seed/p10007/120/120',
    isNew: false, isHot: true, sales7d: 15, sales7dPrev: 22, aiScore: 65, margin: 12, convertRate: 4.8, rating: 4.6, reviews: 456,
    countries: ['US', 'GB', 'DE', 'FR', 'JP', 'AU', 'CA']
  },
  {
    id: '10008', name: '华为 MatePad Pro 12.6', sku: 'HW-MPAD-PRO',
    category: '数码电子', source: '1688', cPrice: '¥3,299', bPrice: '$450',
    stock: 67, cStatus: 'on', bStatus: 'on', image: 'https://picsum.photos/seed/p10008/120/120',
    isNew: true, isHot: false, sales7d: 31, sales7dPrev: 28, aiScore: 82, margin: 22, convertRate: 8.5, rating: 4.7, reviews: 892,
    countries: ['US', 'GB', 'DE', 'JP', 'AU', 'CA', 'RU', 'SA', 'AE']
  }
])
// Tab 计数
watchEffect(() => {
  statusTabs[0].count = products.value.length
  statusTabs[1].count = products.value.filter(p => p.cStatus === 'on').length
  statusTabs[2].count = products.value.filter(p => p.cStatus === 'off').length
  statusTabs[3].count = products.value.filter(p => p.stock < 10).length
  statusTabs[4].count = products.value.filter(p => p.aiScore < 60).length
})

// 筛选
const filteredProducts = computed(() => {
  let list = products.value
  if (activeTab.value === 'on') list = list.filter(p => p.cStatus === 'on')
  else if (activeTab.value === 'off') list = list.filter(p => p.cStatus === 'off')
  else if (activeTab.value === 'warning') list = list.filter(p => p.stock < 10)
  else if (activeTab.value === 'aiwarn') list = list.filter(p => p.aiScore < 60)

  if (search.keyword) {
    const kw = search.keyword.toLowerCase()
    list = list.filter(p => p.name.toLowerCase().includes(kw) || p.sku.toLowerCase().includes(kw) || p.id.includes(kw))
  }
  if (search.category) list = list.filter(p => p.category === search.category)
  if (search.source) list = list.filter(p => p.source === search.source)
  if (search.stock === 'warning') list = list.filter(p => p.stock > 0 && p.stock < 10)
  else if (search.stock === 'out') list = list.filter(p => p.stock === 0)
  else if (search.stock === 'safe') list = list.filter(p => p.stock >= 10)
  if (search.aiScore === 'good') list = list.filter(p => p.aiScore >= 80)
  else if (search.aiScore === 'ok') list = list.filter(p => p.aiScore >= 60 && p.aiScore < 80)
  else if (search.aiScore === 'bad') list = list.filter(p => p.aiScore < 60)
  if (search.country) list = list.filter(p => p.countries.includes(search.country))
  return list
})

// 分页
const currentPage = ref(1)
const pageSize = 10
const totalItems = computed(() => filteredProducts.value.length)
const totalPages = computed(() => Math.ceil(totalItems.value / pageSize))
const pageNumbers = computed(() => {
  const pages = []
  for (let i = 1; i <= totalPages.value; i++) {
    if (i <= 5 || i > totalPages.value - 2 || (i >= currentPage.value - 1 && i <= currentPage.value + 1)) {
      pages.push(i)
    } else if (pages[pages.length - 1] !== '...') {
      pages.push('...')
    }
  }
  return pages
})

// 选择
const selectedIds = ref([])
const isAllSelected = computed(() => filteredProducts.value.length > 0 && filteredProducts.value.every(p => selectedIds.value.includes(p.id)))
const toggleSelect = (id) => { const idx = selectedIds.value.indexOf(id); idx > -1 ? selectedIds.value.splice(idx, 1) : selectedIds.value.push(id) }
const toggleSelectAll = () => { isAllSelected.value ? selectedIds.value = [] : selectedIds.value = filteredProducts.value.map(p => p.id) }
const clearSelection = () => { selectedIds.value = [] }

// 批量
const batchOnShelf = () => { products.value.forEach(p => { if (selectedIds.value.includes(p.id)) p.cStatus = 'on' }); clearSelection() }
const batchOffShelf = () => { products.value.forEach(p => { if (selectedIds.value.includes(p.id)) p.cStatus = 'off' }); clearSelection() }
const batchDelete = () => { if (!confirm(`确定删除 ${selectedIds.value.length} 个商品？`)) return; products.value = products.value.filter(p => !selectedIds.value.includes(p.id)); clearSelection() }

// 操作
const toggleCStatus = (p) => { p.cStatus = p.cStatus === 'on' ? 'off' : 'on' }
const toggleBStatus = (p) => { p.bStatus = p.bStatus === 'on' ? 'off' : 'on' }
const deleteProduct = (p) => { if (!confirm(`确定删除「${p.name}」？`)) return; products.value = products.value.filter(item => item.id !== p.id) }
const copyProduct = (p) => { products.value.unshift({ ...p, id: String(Date.now()), sku: p.sku + '-COPY', name: p.name + ' (复制)', isNew: false }) }
const sourceLabel = (s) => ({ self: '自营', '1688': '1688', supplier: '供应商' }[s] || s)

// AI 颜色
const aiColor = (score) => score >= 80 ? 'var(--d-green)' : score >= 60 ? 'var(--d-orange)' : 'var(--d-red)'

// 搜索
const handleSearch = () => { currentPage.value = 1 }
const resetSearch = () => { Object.assign(search, { keyword: '', category: '', source: '', priceMin: '', priceMax: '', stock: '', aiScore: '', country: '' }); currentPage.value = 1 }

// 抽屉
const showCreate = ref(false)
const editingProduct = ref(null)
const secBasic = ref(true)
const secPrice = ref(true)
const secCountry = ref(true)
const secLogistics = ref(false)
const secAttr = ref(true)
const secImg = ref(false)
const secMainImg = ref(true)
const secDetailImg = ref(true)
const secSeo = ref(false)
const secLlm = ref(true)
const llmLoading = ref(false)
const llmResult = ref('')
const llmCost = ref('')
const llmPrice = ref('')
const llmMargin = ref('')

const form = reactive({
  name: '', sku: '', barcode: '', category: '数码电子', intro: '',
  costPrice: '', cPrice: '', bPrice: '', stock: 100,
  cStatus: 'on', bStatus: 'on',
  countries: [],
  freeShipping: false, preSale: false, weight: '', dimensions: '', shippingFee: '0',
  attrs: '', bundle: false, related: false,
  attrCategory: '', customAttrs: [],
  image: '', detailImages: '',
  mainImages: [], mainImageIndex: 0, detailImageBatch: '',
  metaTitle: '', metaDesc: '', keywords: '',
  llmPrompt: '',
})

const toggleCountry = (code) => {
  if (!form.countries) form.countries = []
  const idx = form.countries.indexOf(code)
  if (idx > -1) form.countries.splice(idx, 1)
  else form.countries.push(code)
}

// 商品属性预设
const presetAttrsMap = {
  '数码电子': ['品牌', '型号', '内存', '存储容量', '颜色', 'CPU', '屏幕尺寸', '电池容量', '保修期', '产地'],
  '家居生活': ['品牌', '材质', '尺寸', '重量', '颜色', '适用空间', '风格', '保修期', '产地'],
  '服饰配件': ['品牌', '材质', '尺码', '颜色', '适用人群', '风格', '季节', '产地'],
  '美妆护肤': ['品牌', '规格', '适用肤质', '功效', '保质期', '产地', '主要成分'],
  '运动户外': ['品牌', '材质', '适用场景', '适用人群', '尺寸', '重量', '防水等级', '产地'],
}
const currentPresetAttrs = reactive({})
const newAttrKey = ref('')
const newAttrVal = ref('')

const loadPresetAttrs = () => {
  const keys = presetAttrsMap[form.attrCategory] || []
  Object.keys(currentPresetAttrs).forEach(k => delete currentPresetAttrs[k])
  keys.forEach(k => { currentPresetAttrs[k] = '' })
}

const sync1688Attrs = () => {
  const fake1688 = {
    '品牌': '[1688] 精选品牌',
    '材质': '[1688] 优质面料',
    '颜色': '[1688] 黑色/白色/灰色',
    '尺码': '[1688] S/M/L/XL',
    '产地': '[1688] 广东广州',
  }
  Object.keys(fake1688).forEach(k => {
    if (!currentPresetAttrs.hasOwnProperty(k)) currentPresetAttrs[k] = fake1688[k]
  })
}

const clearAllAttrs = () => {
  Object.keys(currentPresetAttrs).forEach(k => delete currentPresetAttrs[k])
  form.customAttrs = []
  form.attrCategory = ''
}

const deletePresetAttr = (key) => { delete currentPresetAttrs[key] }

const addCustomAttr = () => {
  if (!newAttrKey.value) return
  form.customAttrs.push({ key: newAttrKey.value, value: newAttrVal.value })
  newAttrKey.value = ''
  newAttrVal.value = ''
}

const removeCustomAttr = (idx) => form.customAttrs.splice(idx, 1)

const attrCount = computed(() => {
  const preset = Object.values(currentPresetAttrs).filter(v => v).length
  const custom = form.customAttrs.filter(a => a.key && a.value).length
  return preset + custom
})

// 图片管理
const mainImageInput = ref(null)
const detailImageInput = ref(null)
let dragFromIdx = -1

const triggerMainImageUpload = () => mainImageInput.value?.click()
const triggerDetailImageUpload = () => detailImageInput.value?.click()

const onMainImageSelected = (e) => {
  const file = e.target.files[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = (ev) => {
    if (!form.mainImages) form.mainImages = []
    if (form.mainImages.length < 5) form.mainImages.push(ev.target.result)
  }
  reader.readAsDataURL(file)
  e.target.value = ''
}

const onDetailImageSelected = (e) => {
  const files = Array.from(e.target.files)
  if (!files.length) return
  if (!form.detailImages) form.detailImages = []
  files.forEach(file => {
    if (form.detailImages.length >= 50) return
    const reader = new FileReader()
    reader.onload = (ev) => { form.detailImages.push(ev.target.result) }
    reader.readAsDataURL(file)
  })
  e.target.value = ''
}

const removeMainImage = (idx) => { form.mainImages.splice(idx, 1); if (form.mainImageIndex >= form.mainImages.length) form.mainImageIndex = Math.max(0, form.mainImages.length - 1) }
const removeDetailImage = (idx) => form.detailImages.splice(idx, 1)

const moveMainImage = (dir) => {
  const arr = form.mainImages
  const i = form.mainImageIndex
  const j = i + dir
  if (j < 0 || j >= arr.length) return
  ;[arr[i], arr[j]] = [arr[j], arr[i]]
  form.mainImageIndex = j
}

const addDetailImagesBatch = () => {
  if (!form.detailImageBatch) return
  const urls = form.detailImageBatch.split('\n').map(u => u.trim()).filter(u => u.startsWith('http'))
  if (!form.detailImages) form.detailImages = []
  urls.forEach(u => { if (form.detailImages.length < 50) form.detailImages.push(u) })
  form.detailImageBatch = ''
}

const dragStart = (idx) => { dragFromIdx = idx }
const drop = (idx) => {
  if (dragFromIdx < 0 || dragFromIdx === idx) return
  const arr = form.detailImages
  const [item] = arr.splice(dragFromIdx, 1)
  arr.splice(idx, 0, item)
  dragFromIdx = -1
}

const llmPricing = () => {
  if (!form.llmPrompt) return
  llmLoading.value = true
  llmResult.value = ''
  setTimeout(() => {
    const cost = parseFloat(form.costPrice) || 88
    const target = parseFloat(form.llmPrompt.match(/(\d+)%/)?.[1]) || 30
    const base = parseFloat(form.cPrice?.replace(/[^0-9.]/g, '')) || 999
    const rec = Math.round(cost * (1 + target / 100))
    llmCost.value = '¥' + cost
    llmPrice.value = '¥' + rec
    llmMargin.value = Math.round((rec - cost) / rec * 100) + '%'
    llmResult.value = `📊 LLM 分析报告\n\n基于您的定价策略（目标利润率 ${target}%）：\n• 当前成本：¥${cost}\n• 推荐C端售价：¥${rec}\n• 预期利润率：${llmMargin.value}\n• 相比竞品建议调整至 ¥${Math.round(rec * 0.95)}-${Math.round(rec * 1.05)} 区间\n• 建议B端定价：¥${Math.round(rec * 0.6)}（${Math.round((rec * 0.6 - cost) / (rec * 0.6) * 100)}% 利润）`
    llmLoading.value = false
  }, 1500)
}

const openDetail = (p) => {
  editingProduct.value = p
  Object.assign(form, {
    name: p.name, sku: p.sku, barcode: p.barcode || '', category: p.category,
    intro: p.intro || '', costPrice: p.costPrice || '', cPrice: p.cPrice, bPrice: p.bPrice,
    stock: p.stock, cStatus: p.cStatus, bStatus: p.bStatus,
    countries: p.countries ? [...p.countries] : [],
    freeShipping: p.freeShipping || false, preSale: p.preSale || false,
    weight: p.weight || '', dimensions: p.dimensions || '', shippingFee: p.shippingFee || '0',
    attrs: p.attrs || '', bundle: p.bundle || false, related: p.related || false,
    attrCategory: p.attrCategory || '', customAttrs: p.customAttrs ? [...p.customAttrs] : [],
    image: p.image || '', detailImages: p.detailImages || [],
    mainImages: p.mainImages || (p.image ? [p.image] : []), mainImageIndex: p.mainImageIndex || 0, detailImageBatch: '',
    metaTitle: p.metaTitle || '', metaDesc: p.metaDesc || '', keywords: p.keywords || '',
    llmPrompt: '',
  })
  llmResult.value = ''
  llmCost.value = ''
  llmPrice.value = ''
  llmMargin.value = ''
  // 重置预设属性
  Object.keys(currentPresetAttrs).forEach(k => delete currentPresetAttrs[k])
  showCreate.value = true
}

const saveProduct = () => {
  if (editingProduct.value) Object.assign(editingProduct.value, {
    ...form,
    countries: form.countries ? [...form.countries] : [],
  })
  else products.value.unshift({
    ...form, id: String(Date.now()), countries: form.countries ? [...form.countries] : [],
    image: form.image || 'https://picsum.photos/seed/new/120/120',
    isNew: true, isHot: false, sales7d: 0, sales7dPrev: 0, aiScore: 50,
    margin: 20, convertRate: 0, rating: 5.0, reviews: 0, cStatus: 'on', bStatus: 'on'
  })
  showCreate.value = false; editingProduct.value = null
}
</script>
