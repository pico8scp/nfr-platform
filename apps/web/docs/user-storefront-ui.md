# NFR 用户侧 UI 提纯与结构文档

更新时间：2026-04-27
适用范围：`apps/web` 用户侧前台商城，包括首页、登录/注册、搜索/分类结果页、商品详情页、公共头部、购物车/收藏浮层。

## 1. 目标

用户侧前台本质是给 CRMEB 套一套 PC 商城主题，但用户可见层不能暴露 CRMEB、接口、采集、供应商平台等技术字眼。用户看到的是 NFR 平台能力：跨境批发、零售、分类浏览、活动优惠、商品详情、收藏、购物车、登录注册。

本次提纯遵循三个原则：

- 用户可见文案业务化：将“已接入 CRMEB”“1688 分类树”等技术表达替换为“全站类目实时更新”“精选货源稳定供给”“平台分类”等业务表达。
- 结构不大改：保留现有首页、搜索/分类页、登录页、详情页的头部结构和数据调用方式，避免影响已对接的 CRMEB API。
- 便于后续移动端复用：将页面、组件、配置、API 数据流关系写清楚，后续移动端页面可以按同一结构承接。

## 2. 当前用户侧页面结构

```text
apps/web
├─ pages
│  ├─ index.vue              首页：头部、分类树、轮播、活动块、商品区、底部
│  ├─ login.vue              登录/注册页：沿用首页头部，主体为轮播宣传 + 登录注册表单
│  ├─ products.vue           搜索/分类结果页：沿用首页头部，主体为搜索结果、属性筛选、商品列表
│  └─ product/[id].vue       商品详情页：公共头部 + 商品主图、规格、营销、参数、详情模块
├─ components
│  ├─ StorefrontHeaderShell.vue 公共商城头部，商品详情页已使用
│  └─ SiteSearchBox.vue         搜索框与联想词入口
├─ composables
│  ├─ useHomePage.ts         首页装修、分类、商品、营销数据聚合
│  ├─ useCrmebSession.ts     登录状态、购物车、收藏状态聚合
│  ├─ useProductCatalog.ts   搜索/分类结果数据聚合
│  └─ useProductDetail.ts    商品详情数据聚合
├─ config
│  ├─ home.ts                首页展示数量、兜底图片、兜底商品
│  ├─ product.ts             商品详情展示配置
│  ├─ product-facets.ts      商品筛选属性规范化配置
│  ├─ crmeb-api.ts           CRMEB API 路径、代理、页面 ID 等内部配置
│  └─ auth.ts                登录注册验证码、安全限制等配置
└─ server
   ├─ api                    Nuxt 服务端 API 代理与页面接口
   └─ utils                  CRMEB 请求、商品目录、详情、筛选归一化工具
```

## 3. UI 风格规范

当前 PC 用户侧视觉以首页为基准，后续页面不得重写头部或另起一套视觉语言。

- 头部：所有用户侧页面应保持首页头部比例、间距、分类树、搜索框、购物车/收藏/登录入口一致。
- 色彩：以黑白、高对比、活动色点缀为主，不使用后台风格，不暴露系统维护语言。
- 字体：中文业务文案以简洁、直接为主，英文仅用于品牌化短词，不用技术英文。
- 分类入口：顶部“全部分类”悬停展示平台分类树；首页中部不再承担顶级分类树职责。
- 商品卡片：图片、标题、价格、销量、活动标签优先展示真实数据，兜底图只用于异常保护。
- 详情页：价格、规格、营销内容、服务承诺、规格参数、商品属性应围绕成交链路展示。

## 4. 用户可见文案规范

禁止在用户侧展示以下技术词：

- CRMEB
- API
- SDK
- 1688 分类树
- 采集
- 接口同步
- dry-run
- payload

允许在代码、配置、服务端代理、开发文档中保留这些词，因为它们是内部实现。

推荐替代表达：

| 技术表达 | 用户侧表达 |
| --- | --- |
| CRMEB 商品分类已接入 | 全站类目实时更新 |
| CRMEB 商品信息已接入 | 精选货源稳定供给 |
| 1688 分类树 | 平台分类 |
| 1688 Supply | NFR Supply |
| Flash Sale | 限时特惠 |
| B2B Wholesale | 企业批发 |
| Business Account | 企业账户 |
| CRMEB Cart / Wishlist | 购物车 / 收藏 |

## 5. 数据来源与调用边界

用户侧页面不直接访问 CRMEB 原始跨域地址，应通过 Nuxt 服务端代理和配置文件承接。

| 模块 | 前端入口 | 数据聚合 | 内部配置 |
| --- | --- | --- | --- |
| 首页 | `pages/index.vue` | `useHomePage.ts` | `config/home.ts`, `config/crmeb-api.ts` |
| 头部分类树 | 首页/结果页/详情页头部 | `useHomePage.ts` | `CRMEB_HOME_ENDPOINTS.category` |
| 搜索/分类结果 | `pages/products.vue` | `useProductCatalog.ts` | `config/product-facets.ts` |
| 商品详情 | `pages/product/[id].vue` | `useProductDetail.ts` | `config/product.ts` |
| 登录/注册 | `pages/login.vue` | `server/api/auth/*` | `config/auth.ts` |
| 收藏/购物车状态 | 头部与详情页 | `useCrmebSession.ts` | `CRMEB_USER_ENDPOINTS` |

## 6. 当前已提纯内容

- 顶部公告不再显示“已接入 CRMEB”，改为“全站类目实时更新”“精选货源稳定供给”。
- 分类悬停面板不再显示“1688 分类树”，改为“平台分类”。
- B2B 入口改为“企业批发 / 企业账户”。
- 限时活动入口从“Flash Sale”改为“限时特惠”。
- 购物车、收藏、登录、用户中心等入口改为中文业务表达。
- 空数据或降级提示不再出现 CRMEB 字样，改为“数据正在同步”。
- 首页页脚与商品详情页提示不再暴露后端系统名称。

## 7. 后续开发规范

1. 新增用户侧页面时，优先复用 `StorefrontHeaderShell.vue`，不得复制一份不一致的头部。
2. 如必须临时复制头部，必须在上线前回收为公共组件，避免首页、结果页、登录页比例漂移。
3. 新增配置必须放在 `apps/web/config`，不要把页面 ID、接口路径、展示数量硬编码到页面组件中。
4. 新增 API 调用必须走 `server/api` 或 `server/utils/crmeb-request.ts`，不要在页面直接拼接后端地址。
5. 用户侧文案必须业务化，内部系统名只允许出现在开发文档和代码变量中。
6. 商品属性筛选必须从搜索结果预查询或规范化配置生成，不能只针对服装类写死。
7. 图片只保存 URL，展示走图片代理或远程 CDN 兜底，不把商品图片下载到前台项目。
8. 任何 UI 改动涉及头部、详情页关键成交区、登录注册页主体布局时，需要先截图确认。

## 8. 验收清单

- 首页 `/`：顶部公告、分类树、活动区、商品区无技术字眼。
- 登录页 `/login`：头部与首页一致，登录注册文案面向用户，不解释内部系统。
- 搜索/分类页 `/products`：头部与首页一致，搜索结果、筛选、猜你想搜可正常显示。
- 商品详情 `/product/{id}`：头部一致，详情页文案围绕价格、规格、优惠、服务、参数展示。
- 购物车/收藏浮层：未登录提示、降级提示不出现 CRMEB 字样。
- 构建：`npm run build --workspace @nexus/web` 通过。

## 9. Git 备份说明

当前 `C:\Users\BO\nexus` 原本不是 Git 仓库。本次备份建议使用独立分支推送到已有远端仓库，避免覆盖 `nfr-platform` 主分支历史。

建议分支名：`backup/nexus-storefront-ui-20260427`

备份范围建议包含：

- `apps/web/pages`
- `apps/web/components`
- `apps/web/composables`
- `apps/web/config`
- `apps/web/server`
- `apps/web/docs`
- 根目录 `package.json`、`package-lock.json`、`tsconfig.json`、`vitest.config.*`

不建议纳入：

- `node_modules`
- `.nuxt`
- `.output`
- `*.tgz`
- 日志文件