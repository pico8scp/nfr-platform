<template>
  <div class="shein-home">

    <!-- ========== 1. 顶部政策条 ========== -->
    <div class="top-policy">
      <div class="policy-inner">
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12l5 5L20 7"/></svg>
          Free Shipping <em>*On orders $49+</em>
        </span>
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12a9 9 0 1 0 18 0 9 9 0 0 0-18 0"/><path d="M3 12l4-4m0 0l4 4m-4-4v8"/></svg>
          Free Returns <em>*T&amp;Cs apply</em>
        </span>
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          Secure Payment
        </span>
        <span class="policy-item">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 3"/></svg>
          No Hidden Fees <em>*Tariff FAQ</em>
        </span>
      </div>
    </div>

    <!-- ========== 2. 主导航头 (粘性) ========== -->
    <header class="main-header" :class="{ scrolled: isScrolled }">
      <div class="header-inner">
        <!-- Logo -->
        <a href="/b2c" class="logo">NFR</a>

        <!-- 🏭 B2B 尊贵批发按钮 -->
        <a href="/b2b" class="b2b-btn" title="B2B Wholesale - Business Account">
          <span class="b2b-icon">🏭</span>
          <span class="b2b-text">
            <span class="b2b-main">B2B Wholesale</span>
            <span class="b2b-sub">Business Account</span>
          </span>
          <span class="b2b-vip">VIP</span>
        </a>

        <!-- 搜索框 -->
        <div class="search-bar">
          <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
          <input type="text" placeholder="Search for 10,000+ products..." class="search-input" />
          <button class="search-btn">Search</button>
        </div>

        <!-- 用户操作区 -->
        <div class="header-actions">
          <button class="action-btn" title="Wishlist">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
            <span class="action-badge">0</span>
          </button>
          <button class="action-btn" title="Cart">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/></svg>
            <span class="action-badge">0</span>
          </button>
          <!-- 未登录状态 -->
          <button v-if="!isLoggedIn" class="signin-btn" title="Sign In">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            <span>Sign In</span>
          </button>
          <!-- 已登录状态：多重身份 -->
          <div v-else class="user-panel">
            <!-- 头像区 -->
            <div class="user-avatar-wrap">
              <img :src="user.avatar" class="user-avatar" :alt="user.name" />
              <!-- 身份徽章叠加 -->
              <div class="identity-badges">
                <span v-if="user.identities.includes('c')" class="id-badge id-c" title="C端会员">C</span>
                <span v-if="user.identities.includes('b')" class="id-badge id-b" title="B端批发商">B</span>
                <span v-if="user.identities.includes('d')" class="id-badge id-d" title="分销商">D</span>
              </div>
              <!-- 双重/三重身份光效 -->
              <div v-if="user.identities.length >= 2" class="avatar-glow" :class="`glow-${user.identities.length}`"></div>
            </div>
            <!-- 用户信息 -->
            <div class="user-info-col">
              <span class="user-name">{{ user.name }}</span>
              <div class="user-level">
                <span v-if="user.level === 'gold'" class="level-badge gold">金牌</span>
                <span v-else-if="user.level === 'silver'" class="level-badge silver">银牌</span>
                <span v-else class="level-badge bronze">铜牌</span>
                <span v-if="user.unread > 0" class="msg-dot">{{ user.unread }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- ========== 3. 分类导航横条 (含活动中心 + 分销商) ========== -->
    <nav class="category-nav">
      <div class="category-nav-inner">
        <button class="cat-item active">New In</button>
        <button class="cat-item">Sale</button>
        <button class="cat-item">Women</button>
        <button class="cat-item">Men</button>
        <button class="cat-item">Kids</button>
        <button class="cat-item">Beachwear</button>
        <button class="cat-item">Beauty</button>
        <button class="cat-item">Shoes &amp; Bags</button>
        <button class="cat-item">Home &amp; Living</button>
        <button class="cat-item">Electronics</button>
        <button class="cat-item">Sports</button>
        <button class="cat-item">Jewelry</button>
        <button class="cat-item">Curve &amp; Plus</button>
        <!-- 分隔线 -->
        <span class="nav-divider"></span>
        <!-- 活动中心 -->
        <button class="cat-item cat-special" @click="goActivity">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="margin-right:4px;vertical-align:middle"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
          活动中心
        </button>
        <!-- 分销商 -->
        <button class="cat-item cat-distributor" @click="goDistributor">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="margin-right:4px;vertical-align:middle"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          分销商
        </button>
        <button class="cat-item cat-item-sale">🔥 Hot</button>
      </div>
    </nav>

    <!-- ========== 4. 主内容区 ========== -->
    <main class="main-content">

      <!-- ===== 4a. Hero Banner + 侧边引流 ===== -->
      <section class="hero-section">
        <div class="hero-inner">

          <!-- 左侧引流卡片 -->
          <div class="hero-left">
            <!-- 活动引流卡 -->
            <a href="/activity" class="hero-side-banner promo-banner" @click.prevent>
              <img src="https://picsum.photos/seed/nfr-act/295/135" alt="Activity Center" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">🎉 LIMITED TIME</span>
                <span class="hero-side-title">Activity<br/>Center</span>
                <span class="hero-side-price">拼团·砍价·返现</span>
              </div>
              <span class="promo-badge">NEW</span>
            </a>
            <!-- 分销商引流卡 -->
            <a href="/distributor" class="hero-side-banner dist-banner" @click.prevent>
              <img src="https://picsum.photos/seed/nfr-dis/295/135" alt="Distributor" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">EARN COMMISSION</span>
                <span class="hero-side-title">Become a<br/>Distributor</span>
                <span class="hero-side-price">专属佣金 · 轻松赚钱</span>
              </div>
            </a>
            <!-- New Arrivals -->
            <a href="#" class="hero-side-banner" @click.prevent>
              <img src="https://picsum.photos/seed/nfr-hl1/295/135" alt="New Arrivals" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">NEW ARRIVALS</span>
                <span class="hero-side-title">Summer<br/>Collection</span>
                <span class="hero-side-price">From $5.99</span>
              </div>
            </a>
          </div>

          <!-- 中间轮播 -->
          <div class="hero-carousel">
            <div class="carousel-track" :style="{ transform: `translateX(-${currentSlide * 100}%)` }">
              <a href="#" class="carousel-slide" v-for="(slide, i) in slides" :key="i" @click.prevent>
                <img :src="slide.img" :alt="slide.alt" />
                <div class="carousel-content">
                  <span class="carousel-tag">{{ slide.tag }}</span>
                  <h2 class="carousel-title">{{ slide.title }}</h2>
                  <span class="carousel-sub">{{ slide.sub }}</span>
                  <button class="carousel-btn">{{ slide.btn }}</button>
                </div>
              </a>
            </div>
            <button class="carousel-arrow carousel-arrow-prev" @click="prevSlide">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M15 18l-6-6 6-6"/></svg>
            </button>
            <button class="carousel-arrow carousel-arrow-next" @click="nextSlide">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M9 18l6-6-6-6"/></svg>
            </button>
            <div class="carousel-dots">
              <button
                v-for="(_, i) in slides"
                :key="i"
                class="carousel-dot"
                :class="{ active: i === currentSlide }"
                @click="currentSlide = i"
              ></button>
            </div>
          </div>

          <!-- 右侧引流卡片 -->
          <div class="hero-right">
            <!-- 升级B端 -->
            <a href="/b2b" class="hero-side-banner upgrade-banner" @click.prevent>
              <img src="https://picsum.photos/seed/nfr-upg/295/135" alt="Upgrade to B2B" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">B2B WHOLESALE</span>
                <span class="hero-side-title">Upgrade to<br/>B2B Wholesale</span>
                <span class="hero-side-price">专享批发低价 · 专属客服</span>
              </div>
            </a>
            <!-- 活动专区 -->
            <a href="/activity" class="hero-side-banner activity-side-banner" @click.prevent>
              <img src="https://picsum.photos/seed/nfr-act2/295/135" alt="Activity" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">HOW TO SAVE MORE</span>
                <span class="hero-side-title">Invite &amp;<br/>Earn Cash</span>
                <span class="hero-side-price">砍价·拼团·邀请返现</span>
              </div>
            </a>
            <!-- Hot Sellers -->
            <a href="#" class="hero-side-banner" @click.prevent>
              <img src="https://picsum.photos/seed/nfr-hr1/295/135" alt="Hot Sellers" />
              <div class="hero-side-overlay"></div>
              <div class="hero-side-text">
                <span class="hero-side-tag">HOT SELLERS</span>
                <span class="hero-side-title">Up To<br/>70% Off</span>
                <span class="hero-side-price">Trending Now</span>
              </div>
            </a>
          </div>

        </div>
      </section>

      <!-- ===== 4b. 分类图标墙 ===== -->
      <section class="category-grid-section">
        <div class="section-inner">
          <div class="category-grid">
            <a href="#" class="cat-icon-item" v-for="cat in categories" :key="cat.name" @click.prevent>
              <div class="cat-icon-img">
                <img :src="cat.img" :alt="cat.name" />
              </div>
              <span class="cat-icon-name">{{ cat.name }}</span>
            </a>
          </div>
        </div>
      </section>

      <!-- ===== 4c. 今日活动三列 - 重新设计比例 ===== -->
      <section class="activity-section">
        <div class="section-inner">
          <div class="activity-grid-v2">

            <!-- Flash Sale - 主角，占更大空间 -->
            <div class="activity-card-v2 card-flash">
              <div class="card-header-v2">
                <div class="card-title-group">
                  <svg class="icon-flash" width="16" height="16" viewBox="0 0 24 24" fill="#e60023"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>
                  <span class="card-title">Flash Sale</span>
                </div>
                <div class="countdown-v2">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#e60023" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M12 6v6l4 2"/>
                  </svg>
                  <span>{{ countdown }}</span>
                </div>
              </div>

              <div class="flash-products-v2">
                <a href="#" class="flash-item" v-for="p in flashProducts" :key="p.name" @click.prevent>
                  <div class="flash-img-wrap">
                    <img :src="p.img" :alt="p.name" />
                    <span class="flash-off">-{{ p.off }}%</span>
                  </div>
                  <div class="flash-info">
                    <span class="flash-name">{{ p.name }}</span>
                    <span class="flash-price">${{ p.price }}</span>
                    <span class="flash-old">${{ (parseFloat(p.price) / (1 - parseInt(p.off)/100)).toFixed(2) }}</span>
                  </div>
                </a>
              </div>

              <a href="#" class="card-more-v2" @click.prevent>
                See More <span>→</span>
              </a>
            </div>

            <!-- #Trending 改为 平台最畅销产品目录 -->
            <div class="activity-card-v2 card-trending">
              <div class="card-header-v2">
                <div class="card-title-group">
                  <svg class="icon-trophy" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#c9a84c" stroke-width="2"><path d="M8 21h8M12 17v4M7 4h10v5a5 5 0 0 1-10 0V4zM5 4v3a7 7 0 0 0 14 0V4"/></svg>
                  <span class="card-title">平台最畅销</span>
                </div>
                <a href="#" class="card-see-all" @click.prevent>查看全部 →</a>
              </div>

              <div class="trending-list-v2">
                <a href="#" class="trending-row" v-for="(t, i) in bestSellers" :key="t.name" @click.prevent>
                  <span class="trend-rank" :class="{ top: i < 3 }">{{ i + 1 }}</span>
                  <img :src="t.img" :alt="t.name" />
                  <div class="trend-info">
                    <span class="trend-name">{{ t.name }}</span>
                    <span class="trend-sales">已售 {{ t.sold }} 件</span>
                    <span class="trend-price">${{ t.price }}</span>
                  </div>
                </a>
              </div>
            </div>

            <!-- Top Brands 改为 公开拼团入团链接 -->
            <div class="activity-card-v2 card-brands card-groupbuy">
              <div class="card-header-v2">
                <div class="card-title-group">
                  <svg class="icon-people" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e60023" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                  <span class="card-title">公开拼团</span>
                </div>
                <span class="groupbuy-live-tag">
                  <svg width="10" height="10" viewBox="0 0 24 24" fill="#fff"><circle cx="12" cy="12" r="6"/></svg>
                  进行中
                </span>
              </div>

              <div class="groupbuy-list-v2">
                <a href="#" class="groupbuy-row" v-for="g in groupBuys" :key="g.title" @click.prevent>
                  <div class="groupbuy-img-wrap">
                    <img :src="g.img" :alt="g.title" />
                    <span class="groupbuy-count">{{ g.members }}/{{ g.target }}人</span>
                  </div>
                  <div class="groupbuy-info">
                    <span class="groupbuy-title">{{ g.title }}</span>
                    <div class="groupbuy-price-row">
                      <span class="groupbuy-price">${{ g.price }}</span>
                      <span class="groupbuy-save">省${{ g.save }}</span>
                    </div>
                    <div class="groupbuy-progress">
                      <div class="groupbuy-bar" :style="{ width: Math.round(g.members / g.target * 100) + '%' }"></div>
                    </div>
                    <span class="groupbuy-status">
                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
                    <template v-if="g.members >= g.target">
                      成团，待发货
                    </template>
                    <template v-else>
                      剩余 {{ g.hours }}h {{ g.mins }}m
                    </template>
                  </span>
                  </div>
                  <button class="groupbuy-join-btn">加入</button>
                </a>
              </div>
            </div>

          </div>
        </div>
      </section>

      <!-- ===== 4d. 商品网格 (含B端引流按钮) ===== -->
      <section class="products-section">
        <div class="section-inner">
          <div class="section-title-row">
            <h3 class="section-title">Hot Sellers</h3>
            <a href="#" class="section-more" @click.prevent>View All →</a>
          </div>
          <div class="product-grid">
            <div class="product-card-wrap" v-for="p in products" :key="p.id">
              <a href="#" class="product-card" @click.prevent>
                <div class="product-img">
                  <img :src="p.img" :alt="p.name" />
                  <span v-if="p.tag" class="product-tag">{{ p.tag }}</span>
                  <button class="product-wish" @click.prevent="p.wishlisted = !p.wishlisted">
                    <svg width="14" height="14" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                        :fill="p.wishlisted ? '#e60023' : 'none'"/>
                    </svg>
                  </button>
                </div>
                <div class="product-info">
                  <p class="product-name">{{ p.name }}</p>
                  <div class="product-price-row">
                    <span class="product-price">${{ p.price }}</span>
                    <span v-if="p.oldPrice" class="product-old-price">${{ p.oldPrice }}</span>
                    <span v-if="p.off" class="product-off">{{ p.off }}%</span>
                  </div>
                </div>
              </a>
              <!-- 💰 B端最低批发价引流按钮 -->
              <a href="/b2b" class="b2b-price-btn" @click.prevent>
                <span class="b2b-price-icon">🏭</span>
                <span class="b2b-price-text">B端最低 <strong>${{ p.b2bPrice }}</strong></span>
                <span class="b2b-price-arrow">→</span>
              </a>
            </div>
          </div>
          <div class="load-more">
            <button class="load-more-btn">Load More</button>
          </div>
        </div>
      </section>

    </main>

    <!-- ========== 5. Footer (含分销商入口) ========== -->
    <footer class="main-footer">
      <div class="footer-inner">
        <div class="footer-grid">

          <!-- 公司信息 -->
          <div class="footer-col">
            <h4 class="footer-heading">Company Info</h4>
            <ul class="footer-links">
              <li><a href="#" @click.prevent>About Us</a></li>
              <li><a href="#" @click.prevent>Careers</a></li>
              <li><a href="#" @click.prevent>Press</a></li>
              <li><a href="#" @click.prevent>Affiliate Program</a></li>
              <!-- 👥 分销商 -->
              <li class="footer-distributor-link">
                <a href="/distributor" class="distributor-link" @click.prevent>
                  👥 Become a Distributor — Earn Commission
                </a>
              </li>
            </ul>
          </div>

          <!-- 客户服务 -->
          <div class="footer-col">
            <h4 class="footer-heading">Customer Service</h4>
            <ul class="footer-links">
              <li><a href="#" @click.prevent>Help Center</a></li>
              <li><a href="#" @click.prevent>Track Order</a></li>
              <li><a href="#" @click.prevent>Return Policy</a></li>
              <li><a href="#" @click.prevent>Privacy Policy</a></li>
              <li><a href="#" @click.prevent>Terms &amp; Conditions</a></li>
            </ul>
          </div>

          <!-- 社交媒体 -->
          <div class="footer-col">
            <h4 class="footer-heading">Find Us On</h4>
            <div class="footer-social">
              <a href="#" class="social-icon" @click.prevent title="Facebook">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
              </a>
              <a href="#" class="social-icon" @click.prevent title="Instagram">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/></svg>
              </a>
              <a href="#" class="social-icon" @click.prevent title="TikTok">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M19.59 6.69a4.83 4.83 0 0 1-3.77-4.25V2h-3.45v13.67a2.89 2.89 0 0 1-2.88 2.5 2.89 2.89 0 0 1-2.89-2.89 2.89 2.89 0 0 1 2.89-2.89c.28 0 .54.04.79.1V9.01a6.27 6.27 0 0 0-.79-.05 6.34 6.34 0 0 0-6.34 6.34 6.34 6.34 0 0 0 6.34 6.34 6.34 6.34 0 0 0 6.33-6.34V8.69a8.16 8.16 0 0 0 4.77 1.52V6.75a4.85 4.85 0 0 1-1-.06z"/></svg>
              </a>
              <a href="#" class="social-icon" @click.prevent title="Twitter/X">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg>
              </a>
            </div>
            <div class="footer-app">
              <p class="app-text">Download Our App</p>
              <div class="app-qr">QR Code</div>
            </div>
          </div>

          <!-- 邮件订阅 -->
          <div class="footer-col">
            <h4 class="footer-heading">Stay Updated</h4>
            <p class="footer-sub-text">Subscribe for exclusive deals &amp; new arrivals</p>
            <div class="footer-subscribe">
              <input type="email" placeholder="Enter your email" class="subscribe-input" />
              <button class="subscribe-btn">Subscribe</button>
            </div>
          </div>

          <!-- 支付方式 -->
          <div class="footer-col">
            <h4 class="footer-heading">Payment Methods</h4>
            <div class="payment-icons">
              <span class="payment-icon">VISA</span>
              <span class="payment-icon">MasterCard</span>
              <span class="payment-icon">PayPal</span>
              <span class="payment-icon">Stripe</span>
            </div>
            <h4 class="footer-heading" style="margin-top: 20px;">Shipping Partners</h4>
            <div class="shipping-partners">
              <span class="partner-tag">DHL</span>
              <span class="partner-tag">FedEx</span>
              <span class="partner-tag">UPS</span>
            </div>
          </div>

        </div>

        <div class="footer-bottom">
          <p class="copyright">© 2026 NFR Platform. All rights reserved.</p>
          <p class="footer-note">NFR — Your gateway to global trade. B2B Wholesale &amp; B2C Retail.</p>
        </div>
      </div>
    </footer>

  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'

// ===== 滚动检测 =====
const isScrolled = ref(false)
const handleScroll = () => { isScrolled.value = window.scrollY > 20 }
onMounted(() => window.addEventListener('scroll', handleScroll, { passive: true }))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))

// ===== 模拟登录状态（实际替换为真实用户数据）=====
const isLoggedIn = ref(false) // 切换 true/false 查看效果
const user = ref({
  name: 'Sarah Chen',
  avatar: 'https://picsum.photos/seed/avatar1/80/80',
  level: 'gold', // bronze | silver | gold
  identities: ['c', 'b', 'd'], // c=C端 b=B端 d=分销商
  unread: 3,
})

// ===== 轮播 =====
const currentSlide = ref(0)
const totalSlides = 4
const slides = [
  { img: 'https://picsum.photos/seed/nfr-slide1/900/400', alt: 'Summer Sale', tag: 'SUMMER SALE', title: 'Up to 70% Off', sub: 'Free shipping on orders $49+', btn: 'Shop Now' },
  { img: 'https://picsum.photos/seed/nfr-slide2/900/400', alt: 'New Arrivals', tag: 'LIMITED TIME', title: 'Invite & Earn Cash!', sub: '拼团·砍价·邀请返现 三合一活动', btn: 'Join Now' },
  { img: 'https://picsum.photos/seed/nfr-slide3/900/400', alt: 'Flash Deal', tag: 'FLASH DEAL', title: 'Kids Collection', sub: 'Up to 50% off everything', btn: 'Shop Kids' },
  { img: 'https://picsum.photos/seed/nfr-slide4/900/400', alt: 'Beauty', tag: 'DISTRIBUTOR PROGRAM', title: 'Earn Money with NFR', sub: '专属推广链接 · 高额佣金 · 轻松赚钱', btn: 'Learn More' },
]
const prevSlide = () => { currentSlide.value = (currentSlide.value - 1 + totalSlides) % totalSlides }
const nextSlide = () => { currentSlide.value = (currentSlide.value + 1) % totalSlides }
let autoSlide = setInterval(nextSlide, 4000)
onUnmounted(() => clearInterval(autoSlide))

// ===== 倒计时 =====
const countdownSecs = ref(8 * 3600 + 32 * 60 + 15)
const countdown = computed(() => {
  const h = String(Math.floor(countdownSecs.value / 3600)).padStart(2, '0')
  const m = String(Math.floor((countdownSecs.value % 3600) / 60)).padStart(2, '0')
  const s = String(countdownSecs.value % 60).padStart(2, '0')
  return `${h}:${m}:${s}`
})
let countdownTimer = null
onMounted(() => { countdownTimer = setInterval(() => { if (countdownSecs.value > 0) countdownSecs.value-- }, 1000) })
onUnmounted(() => { clearInterval(countdownTimer) })

// ===== 导航跳转 =====
const goActivity = () => { navigateTo('/activity') }
const goDistributor = () => { navigateTo('/distributor') }

// ===== 分类图标 =====
const categories = [
  { name: 'Women', img: 'https://picsum.photos/seed/nfr-cat1/200/200' },
  { name: 'Men', img: 'https://picsum.photos/seed/nfr-cat2/200/200' },
  { name: 'Kids', img: 'https://picsum.photos/seed/nfr-cat3/200/200' },
  { name: 'Beauty', img: 'https://picsum.photos/seed/nfr-cat4/200/200' },
  { name: 'Shoes', img: 'https://picsum.photos/seed/nfr-cat5/200/200' },
  { name: 'Bags', img: 'https://picsum.photos/seed/nfr-cat6/200/200' },
  { name: 'Home', img: 'https://picsum.photos/seed/nfr-cat7/200/200' },
  { name: 'Electronics', img: 'https://picsum.photos/seed/nfr-cat8/200/200' },
  { name: 'Sports', img: 'https://picsum.photos/seed/nfr-cat9/200/200' },
  { name: 'Jewelry', img: 'https://picsum.photos/seed/nfr-cat10/200/200' },
]

// ===== 最畅销产品 =====
const bestSellers = [
  { name: 'Women Boho Floral Maxi Dress', img: 'https://picsum.photos/seed/nfr-p1/200/200', price: '19.99', sold: '2.4k' },
  { name: 'Wireless Earbuds Bluetooth 5.3', img: 'https://picsum.photos/seed/nfr-p9/200/200', price: '29.99', sold: '1.8k' },
  { name: 'Kids Unicorn Pajama Set', img: 'https://picsum.photos/seed/nfr-p3/200/200', price: '14.99', sold: '1.5k' },
  { name: 'Women Sneakers Platform Shoes', img: 'https://picsum.photos/seed/nfr-p5/200/200', price: '24.99', sold: '1.2k' },
  { name: 'Gold Plated Jewelry Set', img: 'https://picsum.photos/seed/nfr-p10/200/200', price: '7.99', sold: '980' },
]

// ===== 公开拼团 =====
const groupBuys = [
  { title: 'Floral Maxi Dress — Women Summer Beach', img: 'https://picsum.photos/seed/nfr-g1/200/200', members: 8, target: 10, price: '12.99', save: '6.00', hours: 3, mins: 42 },
  { title: 'Kids Pajama Set 2pcs — Soft Cotton', img: 'https://picsum.photos/seed/nfr-g2/200/200', members: 5, target: 8, price: '9.99', save: '4.51', hours: 1, mins: 18 },
  { title: 'Athletic Joggers — Men Sports Running', img: 'https://picsum.photos/seed/nfr-g3/200/200', members: 3, target: 6, price: '10.50', save: '5.49', hours: 5, mins: 55 },
]

// ===== 活动产品 =====
const flashProducts = [
  { name: 'Floral Dress', img: 'https://picsum.photos/seed/nfr-flash1/200/200', price: '12.99', off: '35' },
  { name: 'Basic Tee Pack', img: 'https://picsum.photos/seed/nfr-flash2/200/200', price: '8.99', off: '25' },
  { name: 'Yoga Mat 6mm', img: 'https://picsum.photos/seed/nfr-flash3/200/200', price: '9.99', off: '40' },
]
const trendingItems = [
  { tag: '#ElevatedAthleisure', img: 'https://picsum.photos/seed/nfr-trend1/200/200', price: '12.99' },
  { tag: '#RetroStreetwear', img: 'https://picsum.photos/seed/nfr-trend2/200/200', price: '18.99' },
  { tag: '#SummerVibes', img: 'https://picsum.photos/seed/nfr-trend3/200/200', price: '9.99' },
  { tag: '#MinimalistChic', img: 'https://picsum.photos/seed/nfr-trend4/200/200', price: '15.99' },
  { tag: '#CoastalGrandmother', img: 'https://picsum.photos/seed/nfr-trend5/200/200', price: '22.99' },
]
const brands = [
  { name: 'StyleCo', img: 'https://picsum.photos/seed/nfr-brand1/200/100', disc: '40% OFF' },
  { name: 'LuxeLine', img: 'https://picsum.photos/seed/nfr-brand2/200/100', disc: '30% OFF' },
  { name: 'UrbanFit', img: 'https://picsum.photos/seed/nfr-brand3/200/100', disc: '25% OFF' },
  { name: 'EcoWear', img: 'https://picsum.photos/seed/nfr-brand4/200/100', disc: '35% OFF' },
]

// ===== 商品列表 (含B端价格) =====
const products = [
  { id: 1, name: 'Floral Print V-Neck Maxi Dress — Summer Beach Style', img: 'https://picsum.photos/seed/nfr-p1/300/400', price: '18.99', oldPrice: '39.90', off: '52', tag: null, wishlisted: false, b2bPrice: '11.50' },
  { id: 2, name: 'Basic Crew Neck T-Shirt Pack of 2 — 100% Cotton', img: 'https://picsum.photos/seed/nfr-p2/300/400', price: '11.99', off: '30', tag: null, wishlisted: false, b2bPrice: '7.80' },
  { id: 3, name: 'Kids Unisex Pajama Set — Soft Cotton Sleepwear 2pc', img: 'https://picsum.photos/seed/nfr-p3/300/400', price: '14.50', oldPrice: '24.99', off: '42', tag: null, wishlisted: false, b2bPrice: '9.20' },
  { id: 4, name: 'High Waist Bikini Set — 2pcs Beach Swimwear', img: 'https://picsum.photos/seed/nfr-p4/300/400', price: '8.49', off: '50', tag: null, wishlisted: false, b2bPrice: '4.99' },
  { id: 5, name: 'Casual Platform Sneakers — Comfort Walking Shoes Women', img: 'https://picsum.photos/seed/nfr-p5/300/400', price: '22.99', oldPrice: '44.90', off: '49', tag: null, wishlisted: false, b2bPrice: '14.80' },
  { id: 6, name: 'Athletic Jogger Pants — Quick-Dry Sports Running Men', img: 'https://picsum.photos/seed/nfr-p6/300/400', price: '15.99', off: '28', tag: null, wishlisted: false, b2bPrice: '10.20' },
  { id: 7, name: 'Square Frame Sunglasses — UV400 Protection Fashion', img: 'https://picsum.photos/seed/nfr-p7/300/400', price: '5.49', oldPrice: '12.99', off: '58', tag: null, wishlisted: false, b2bPrice: '3.20' },
  { id: 8, name: 'Ceramic Vase Set — Modern Home Decor 3pcs', img: 'https://picsum.photos/seed/nfr-p8/300/400', price: '12.99', off: '35', tag: null, wishlisted: false, b2bPrice: '7.90' },
  { id: 9, name: 'TWS Bluetooth Earbuds — Active Noise Cancelling 5.3', img: 'https://picsum.photos/seed/nfr-p9/300/400', price: '28.99', oldPrice: '59.99', off: '52', tag: null, wishlisted: false, b2bPrice: '18.50' },
  { id: 10, name: 'Gold Plated Jewelry Set — Necklace + Earrings + Bracelet', img: 'https://picsum.photos/seed/nfr-p10/300/400', price: '7.29', off: '55', tag: null, wishlisted: false, b2bPrice: '4.10' },
  { id: 11, name: 'Non-Slip Yoga Mat — 6mm Thick Exercise Fitness', img: 'https://picsum.photos/seed/nfr-p11/300/400', price: '16.49', oldPrice: '29.99', off: '45', tag: null, wishlisted: false, b2bPrice: '10.80' },
  { id: 12, name: 'PU Leather Crossbody Bag — Women Shoulder Bag 2024', img: 'https://picsum.photos/seed/nfr-p12/300/400', price: '13.50', off: '32', tag: null, wishlisted: false, b2bPrice: '8.50' },
]
</script>

<style scoped>
* { box-sizing: border-box; }

.shein-home {
  min-height: 100vh;
  background: #fff;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  color: #222;
}

/* ========== 1. 顶部政策条 ========== */
.top-policy {
  background: #fff;
  border-bottom: 1px solid #eee;
}
.policy-inner {
  max-width: 1446px;
  margin: 0 auto;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 38px;
}
.policy-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 0 32px;
  font-size: 12px;
  color: #555;
  white-space: nowrap;
  border-right: 1px solid #eee;
  letter-spacing: 0.2px;
}
.policy-item:last-child { border-right: none; }
.policy-item svg { color: #222; flex-shrink: 0; }
.policy-item em { color: #999; font-style: normal; font-size: 11px; }

/* ========== 2. 主导航头 ========== */
.main-header {
  background: #fff;
  border-bottom: 1px solid #eee;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
}
.main-header.scrolled { box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
.header-inner {
  max-width: 1446px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 12px 0;
}

/* Logo */
.logo {
  font-size: 28px;
  font-weight: 900;
  color: #111;
  text-decoration: none;
  letter-spacing: -2px;
  flex-shrink: 0;
  font-style: italic;
}

/* 🏭 B2B 尊贵按钮 */
.b2b-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 7px 16px;
  background: #fff;
  border: 1.5px solid #c9a84c;
  border-radius: 4px;
  text-decoration: none;
  flex-shrink: 0;
  transition: all 0.2s;
  box-shadow: 0 1px 3px rgba(201,168,76,0.15);
}
.b2b-btn:hover {
  background: #fffdf5;
  box-shadow: 0 2px 8px rgba(201,168,76,0.25);
  transform: translateY(-1px);
}
.b2b-icon { font-size: 18px; }
.b2b-text {
  display: flex;
  flex-direction: column;
  line-height: 1.2;
}
.b2b-main {
  font-size: 12px;
  font-weight: 800;
  color: #111;
  letter-spacing: 0.3px;
}
.b2b-sub {
  font-size: 9px;
  color: #777;
  font-weight: 500;
}
.b2b-vip {
  font-size: 8px;
  font-weight: 900;
  color: #c9a84c;
  background: #f9f7f0;
  padding: 2px 5px;
  border-radius: 3px;
  letter-spacing: 1px;
  border: 1px solid #e8d89a;
  align-self: flex-start;
  margin-top: -2px;
}

/* 搜索框 */
.search-bar {
  flex: 1;
  display: flex;
  align-items: center;
  background: #f7f7f7;
  border: 1px solid #eee;
  border-radius: 4px;
  padding: 0 4px 0 14px;
  max-width: 520px;
  height: 38px;
  transition: border-color 0.2s;
}
.search-bar:focus-within {
  border-color: #ccc;
  background: #fff;
}
.search-icon { color: #999; flex-shrink: 0; }
.search-input {
  flex: 1;
  border: none;
  background: transparent;
  padding: 0 10px;
  font-size: 13px;
  outline: none;
  color: #333;
}
.search-input::placeholder { color: #bbb; }
.search-btn {
  background: #111;
  color: #fff;
  border: none;
  padding: 8px 18px;
  border-radius: 3px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
  height: 30px;
  letter-spacing: 0.3px;
}
.search-btn:hover { background: #333; }

/* 用户操作区 */
.header-actions {
  display: flex;
  align-items: center;
  gap: 2px;
  flex-shrink: 0;
  margin-left: auto;
}
.action-btn {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 38px;
  height: 38px;
  background: none;
  border: none;
  cursor: pointer;
  color: #444;
  border-radius: 4px;
  transition: background 0.2s, color 0.2s;
}
.action-btn:hover { background: #f5f5f5; color: #111; }
.action-badge {
  position: absolute;
  top: 4px;
  right: 4px;
  background: #111;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  min-width: 16px;
  height: 16px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 3px;
}
.signin-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background: #111;
  color: #fff;
  border: none;
  border-radius: 3px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  margin-left: 6px;
  letter-spacing: 0.3px;
  height: 38px;
}
.signin-btn:hover { background: #333; }

/* 已登录用户面板 */
.user-panel {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 4px 12px 4px 4px;
  background: #fafafa;
  border: 1px solid #eee;
  border-radius: 28px;
  cursor: pointer;
  transition: all 0.2s;
  margin-left: 4px;
}
.user-panel:hover { background: #f0f0f0; border-color: #ddd; }
.user-avatar-wrap {
  position: relative;
  flex-shrink: 0;
}
.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #f0f0f0;
}
/* 身份徽章叠加 */
.identity-badges {
  position: absolute;
  bottom: -3px;
  right: -5px;
  display: flex;
  flex-direction: row-reverse;
  gap: 1px;
}
.id-badge {
  font-size: 8px;
  font-weight: 800;
  width: 14px;
  height: 14px;
  border-radius: 3px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(0,0,0,0.15);
  line-height: 1;
}
.id-c { background: #e76f51; color: #fff; }
.id-b { background: linear-gradient(135deg, #c9a84c, #f0d68a); color: #4a3000; }
.id-d { background: #6c5ce7; color: #fff; }
/* 双重/三重身份光效 */
.avatar-glow {
  position: absolute;
  inset: -3px;
  border-radius: 50%;
  pointer-events: none;
}
.glow-2 {
  background: #c9a84c;
  opacity: 0.4;
  filter: blur(3px);
}
.glow-3 {
  background: linear-gradient(135deg, #c9a84c, #6c5ce7);
  opacity: 0.4;
  filter: blur(3px);
}

.user-info-col {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.user-name {
  font-size: 12px;
  font-weight: 600;
  color: #222;
  max-width: 80px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.user-level {
  display: flex;
  align-items: center;
  gap: 5px;
}
.level-badge {
  font-size: 10px;
  font-weight: 700;
}
.level-badge.gold { color: #c9a84c; }
.level-badge.silver { color: #adb5bd; }
.level-badge.bronze { color: #cd7f32; }
.msg-dot {
  background: #e60023;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  min-width: 15px;
  height: 15px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 3px;
}

/* ========== 3. 分类导航横条 ========== */
.category-nav {
  background: #fff;
  border-bottom: 2px solid #111;
  overflow-x: auto;
  scrollbar-width: none;
}
.category-nav::-webkit-scrollbar { display: none; }
.category-nav-inner {
  max-width: 1446px;
  margin: 0 auto;
  display: flex;
  align-items: center;
}
.cat-item {
  padding: 12px 22px;
  font-size: 13px;
  font-weight: 500;
  color: #555;
  background: none;
  border: none;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
  white-space: nowrap;
  letter-spacing: 0.2px;
}
.cat-item:hover { color: #111; }
.cat-item.active { color: #111; border-bottom-color: #111; font-weight: 600; }
.cat-item-sale { color: #e60023; font-weight: 600; }

/* 特殊导航按钮 */
.nav-divider {
  width: 1px;
  height: 18px;
  background: #ddd;
  margin: 0 6px;
  flex-shrink: 0;
}
.cat-special {
  background: #e60023;
  color: #fff !important;
  border-radius: 3px;
  padding: 5px 14px;
  margin: 0 4px;
  font-size: 12px;
  font-weight: 600;
  border-bottom: none !important;
  letter-spacing: 0.3px;
}
.cat-special:hover { background: #c5001e; }
.cat-special svg { vertical-align: middle; }
.cat-distributor {
  background: #2a2a6a;
  color: #fff !important;
  border-radius: 3px;
  padding: 5px 14px;
  margin: 0 4px;
  font-size: 12px;
  font-weight: 600;
  border-bottom: none !important;
  letter-spacing: 0.3px;
}
.cat-distributor:hover { background: #1a1a50; }
.cat-distributor svg { vertical-align: middle; }

/* ========== 4. 主内容区 ========== */
.main-content {
  max-width: 1446px;
  margin: 0 auto;
  padding: 0 0;
  background: #fff;
}

/* ===== 4a. Hero Banner ===== */
.hero-section { padding: 20px 0; background: #fff; }
.hero-inner {
  display: flex;
  gap: 14px;
  align-items: stretch;
  height: 300px;
}
.hero-left, .hero-right {
  width: 280px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.hero-side-banner {
  position: relative;
  flex: 1;
  border-radius: 4px;
  overflow: hidden;
  text-decoration: none;
  display: block;
  background: #f0f0f0;
}
.hero-side-banner img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}
.hero-side-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.6) 0%, rgba(0,0,0,0.05) 50%, transparent 100%);
}
.hero-side-text {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 12px 14px;
  color: #fff;
  z-index: 1;
}
.hero-side-tag { font-size: 9px; font-weight: 700; letter-spacing: 1.5px; opacity: 0.85; display: block; }
.hero-side-title { font-size: 14px; font-weight: 800; display: block; line-height: 1.25; margin: 3px 0 2px; letter-spacing: 0.3px; }
.hero-side-price { font-size: 11px; font-weight: 500; display: block; opacity: 0.9; }

/* 活动引流卡 */
.promo-banner {
  border: 1px solid #eee;
}
/* 促销徽章 */
.promo-badge {
  position: absolute;
  top: 8px;
  right: 8px;
  background: #e60023;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 2px;
  z-index: 2;
  letter-spacing: 0.5px;
}

/* 轮播 */
.hero-carousel {
  flex: 1;
  position: relative;
  border-radius: 4px;
  overflow: hidden;
}
.carousel-track {
  display: flex;
  transition: transform 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  height: 100%;
}
.carousel-slide {
  min-width: 100%;
  position: relative;
  display: block;
  height: 100%;
  text-decoration: none;
}
.carousel-slide img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}
.carousel-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 24px 32px;
  background: linear-gradient(to top, rgba(0,0,0,0.65), transparent);
  color: #fff;
}
.carousel-tag { font-size: 10px; font-weight: 700; letter-spacing: 2px; opacity: 0.9; display: block; }
.carousel-title { font-size: 28px; font-weight: 800; margin: 6px 0 6px; line-height: 1.1; letter-spacing: -0.5px; }
.carousel-sub { font-size: 13px; opacity: 0.85; display: block; margin-bottom: 12px; }
.carousel-btn {
  background: #fff;
  color: #111;
  border: none;
  padding: 8px 20px;
  border-radius: 3px;
  font-size: 12px;
  font-weight: 700;
  cursor: pointer;
  letter-spacing: 0.5px;
}
.carousel-arrow {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  background: rgba(255,255,255,0.95);
  border: none;
  width: 36px;
  height: 36px;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #333;
  z-index: 5;
  box-shadow: 0 1px 4px rgba(0,0,0,0.1);
}
.carousel-arrow-prev { left: 12px; }
.carousel-arrow-next { right: 12px; }
.carousel-dots {
  position: absolute;
  bottom: 12px;
  right: 20px;
  display: flex;
  gap: 5px;
  z-index: 5;
}
.carousel-dot {
  width: 6px;
  height: 6px;
  border-radius: 3px;
  background: rgba(255,255,255,0.5);
  border: none;
  cursor: pointer;
  transition: all 0.3s;
  padding: 0;
}
.carousel-dot.active { background: #fff; width: 20px; }

/* ===== 4b. 分类图标墙 ===== */
.category-grid-section { padding: 24px 0; background: #fff; border-bottom: 1px solid #f0f0f0; }
.section-inner { max-width: 1446px; margin: 0 auto; padding: 0 16px; }
.category-grid {
  display: grid;
  grid-template-columns: repeat(10, 1fr);
  gap: 16px;
}
.cat-icon-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  text-decoration: none;
  color: #333;
  cursor: pointer;
}
.cat-icon-img {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  overflow: hidden;
  background: #f5f5f5;
  border: 2px solid #eee;
}
.cat-icon-img img { width: 100%; height: 100%; object-fit: cover; }
.cat-icon-name { font-size: 11px; font-weight: 500; text-align: center; color: #444; letter-spacing: 0.2px; }

/* ===== 4c. 活动三列区 v2 ===== */
.activity-section { padding: 24px 0; background: #fafafa; }
.activity-section .section-inner { max-width: 1446px; margin: 0 auto; padding: 0 16px; }

/* 三列：Flash 45% / 畅销 30% / 拼团 25% */
.activity-grid-v2 {
  display: grid;
  grid-template-columns: 45fr 30fr 25fr;
  gap: 16px;
  align-items: stretch;
}

.activity-card-v2 {
  background: #fff;
  border-radius: 4px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  border: 1px solid #eee;
  min-height: 400px;
}

/* 卡片头部 */
.card-header-v2 {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 16px 12px;
  border-bottom: 1px solid #f0f0f0;
}
.card-title-group {
  display: flex;
  align-items: center;
  gap: 8px;
}
.card-title {
  font-size: 14px;
  font-weight: 700;
  color: #111;
  letter-spacing: 0.3px;
}
.countdown-v2 {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  color: #e60023;
  font-weight: 600;
  background: #fff0f0;
  padding: 4px 10px;
  border-radius: 3px;
}
.flash-products-v2 {
  display: flex;
  gap: 16px;
  padding: 16px;
  flex: 1;
  align-items: flex-start;
}
.flash-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
  text-decoration: none;
}
.flash-img-wrap {
  position: relative;
  aspect-ratio: 1;
  border-radius: 4px;
  overflow: hidden;
  background: #f5f5f5;
}
.flash-img-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.flash-off {
  position: absolute;
  top: 6px;
  left: 6px;
  background: #e60023;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  padding: 2px 5px;
  border-radius: 2px;
}
.flash-info { display: flex; flex-direction: column; gap: 3px; }
.flash-name {
  font-size: 11px;
  color: #444;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.4;
}
.flash-price { font-size: 15px; font-weight: 700; color: #111; }
.flash-old { font-size: 11px; color: #999; text-decoration: line-through; }
.card-more-v2 {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  padding: 12px;
  font-size: 12px;
  font-weight: 600;
  color: #e60023;
  text-decoration: none;
  border-top: 1px solid #f0f0f0;
  margin-top: auto;
  letter-spacing: 0.3px;
}
.card-more-v2:hover { background: #fff8f8; }

/* Trending */
.card-trending { }
.trending-list-v2 {
  display: flex;
  flex-direction: column;
  gap: 0;
  padding: 8px 0;
  flex: 1;
}
.trending-row {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 16px;
  text-decoration: none;
  transition: background 0.2s;
}
.trending-row:hover { background: #fafafa; }
.trend-rank {
  font-size: 14px;
  font-weight: 800;
  color: #ccc;
  min-width: 20px;
  text-align: center;
}
.trend-rank.top { color: #e60023; }
.trending-row img {
  width: 44px;
  height: 44px;
  border-radius: 6px;
  object-fit: cover;
  background: #f5f5f5;
  flex-shrink: 0;
}
.trend-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 0;
}
.trend-tag {
  font-size: 11px;
  font-weight: 600;
  color: #333;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.trend-price { font-size: 13px; font-weight: 800; color: #222; }
.card-see-all {
  font-size: 11px;
  font-weight: 600;
  color: #e60023;
  text-decoration: none;
}
.card-see-all:hover { text-decoration: underline; }

/* Brands */
.card-brands { }
.brands-list-v2 {
  display: flex;
  flex-direction: column;
  gap: 0;
  padding: 8px 0;
  flex: 1;
}
.brand-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 16px;
  text-decoration: none;
  transition: background 0.2s;
}
.brand-row:hover { background: #fafafa; }
.brand-row img {
  width: 52px;
  height: 36px;
  border-radius: 6px;
  object-fit: cover;
  background: #f5f5f5;
  flex-shrink: 0;
}
.brand-info-v2 {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.brand-name-v2 { font-size: 13px; font-weight: 700; color: #222; }
.brand-disc-v2 { font-size: 12px; font-weight: 800; color: #e60023; }

/* 拼团卡片 */
.card-groupbuy {
  border: 1px solid #e0e0e0;
}
.groupbuy-live-tag {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 10px;
  font-weight: 700;
  color: #fff;
  background: #e60023;
  padding: 3px 8px;
  border-radius: 3px;
}
.groupbuy-list-v2 {
  display: flex;
  flex-direction: column;
  gap: 0;
  padding: 8px 0;
  flex: 1;
  overflow: hidden;
}
.groupbuy-row {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 16px;
  text-decoration: none;
  transition: background 0.2s;
  border-bottom: 1px solid #f5f5f5;
}
.groupbuy-row:last-child { border-bottom: none; }
.groupbuy-row:hover { background: #fff5f5; }
.groupbuy-img-wrap {
  position: relative;
  flex-shrink: 0;
  width: 52px;
  height: 52px;
  border-radius: 6px;
  overflow: hidden;
  background: #f5f5f5;
}
.groupbuy-img-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.groupbuy-count {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(0,0,0,0.6);
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  text-align: center;
  padding: 2px;
}
.groupbuy-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
  min-width: 0;
}
.groupbuy-title {
  font-size: 11px;
  font-weight: 600;
  color: #333;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.groupbuy-price-row {
  display: flex;
  align-items: center;
  gap: 6px;
}
.groupbuy-price { font-size: 13px; font-weight: 800; color: #e60023; }
.groupbuy-save { font-size: 10px; color: #999; font-weight: 500; }
.groupbuy-progress {
  height: 3px;
  background: #f0f0f0;
  border-radius: 2px;
  overflow: hidden;
  margin: 2px 0;
}
.groupbuy-bar {
  height: 100%;
  background: #e60023;
  border-radius: 2px;
}
.groupbuy-status {
  display: flex;
  align-items: center;
  gap: 3px;
  font-size: 10px;
  color: #666;
}
.groupbuy-join-btn {
  flex-shrink: 0;
  padding: 5px 10px;
  background: #e60023;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 600;
  cursor: pointer;
}
.groupbuy-join-btn:hover { background: #c5001e; }

/* 畅销列表样式 */
.trend-name {
  font-size: 11px;
  font-weight: 600;
  color: #333;
  display: -webkit-box;
  -webkit-line-clamp: 1;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.trend-sales { font-size: 10px; color: #999; font-weight: 500; }
.trend-tag { font-size: 11px; font-weight: 600; color: #333; }

/* ===== 4d. 商品网格 ===== */
.products-section { padding: 28px 0 40px; background: #fff; }
.section-title-row {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 20px;
  border-bottom: 1px solid #eee;
  padding-bottom: 12px;
}
.section-title { font-size: 18px; font-weight: 700; color: #111; letter-spacing: 0.3px; }
.section-more { font-size: 13px; font-weight: 500; color: #666; text-decoration: none; }
.section-more:hover { color: #111; }
.product-grid {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 16px;
}
.product-card-wrap {
  display: flex; flex-direction: column; min-height: 460px; height: 460px;
}
.product-card {
  display: flex;
  flex-direction: column;
  text-decoration: none;
  color: #222;
  cursor: pointer;
  flex: 1;
}
.product-img {
  position: relative;
  background: #f5f5f5;
  border-radius: 4px;
  overflow: hidden;
  aspect-ratio: 3/4;
}
.product-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}
.product-tag {
  position: absolute;
  top: 8px;
  left: 8px;
  background: #111;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 2px;
  letter-spacing: 0.5px;
}
.product-wish {
  position: absolute;
  top: 8px;
  right: 8px;
  background: rgba(255,255,255,0.95);
  border: none;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}
.product-info { padding: 10px 2px 0; flex: 1; min-height: 0; display: flex; flex-direction: column; margin-top: auto; }
.product-name {
  font-size: 12px;
  color: #333;
  margin-bottom: 6px;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.product-price-row { display: flex; align-items: baseline; gap: 6px; flex-wrap: wrap; }
.product-price { font-size: 15px; font-weight: 700; color: #111; }
.product-old-price { font-size: 12px; color: #aaa; text-decoration: line-through; }
.product-off { font-size: 11px; font-weight: 600; color: #e60023; }

/* B端批发价引流按钮 */
.b2b-price-btn { height: 36px; padding: 0 8px; margin-top: 0; flex-shrink: 0;
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 6px 8px;
  margin-top: 6px;
  background: #fff;
  border: 1px solid #d4c87a;
  border-radius: 3px;
  text-decoration: none;
  cursor: pointer;
  font-size: 11px;
  color: #555;
}
.b2b-price-btn:hover { background: #fffdf5; }
.b2b-price-icon { font-size: 13px; }
.b2b-price-text { flex: 1; font-weight: 500; }
.b2b-price-text strong {
  font-weight: 700;
  color: #111;
  font-size: 12px;
}
.b2b-price-arrow { font-size: 12px; color: #c9a84c; font-weight: 700; }

.load-more { text-align: center; margin-top: 32px; }
.load-more-btn {
  background: #fff;
  color: #111;
  border: 1.5px solid #111;
  padding: 12px 48px;
  border-radius: 3px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  letter-spacing: 0.5px;
}
.load-more-btn:hover { background: #111; color: #fff; }

/* ========== 5. Footer ========== */
.main-footer {
  background: #111;
  color: #888;
  margin-top: 40px;
}
.footer-inner {
  max-width: 1446px;
  margin: 0 auto;
  padding: 40px 0 24px;
}
.footer-grid {
  display: grid;
  grid-template-columns: 1.2fr 1.2fr 1.2fr 1.4fr 1.4fr;
  gap: 40px;
  padding: 0 16px;
}
.footer-heading {
  font-size: 12px;
  font-weight: 700;
  color: #fff;
  margin-bottom: 16px;
  letter-spacing: 1px;
  text-transform: uppercase;
}
.footer-links {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.footer-links a {
  font-size: 12px;
  color: #888;
  text-decoration: none;
}
.footer-links a:hover { color: #fff; }

/* 分销商链接 */
.footer-distributor-link { margin-top: 6px; }
.distributor-link {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 5px 10px;
  background: rgba(74,64,212,0.12);
  border: 1px solid rgba(74,64,212,0.3);
  border-radius: 3px;
  color: #8888cc !important;
  font-weight: 600;
  font-size: 11px !important;
  letter-spacing: 0.3px;
}
.distributor-link:hover { background: rgba(74,64,212,0.2); color: #aaa !important; }

.footer-social {
  display: flex;
  gap: 10px;
  margin-bottom: 16px;
}
.social-icon {
  width: 34px;
  height: 34px;
  border-radius: 4px;
  background: #222;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #888;
  text-decoration: none;
}
.social-icon:hover { background: #333; color: #fff; }
.footer-app { margin-top: 8px; }
.app-text { font-size: 12px; color: #888; margin-bottom: 8px; }
.app-qr {
  width: 80px;
  height: 80px;
  background: #fff;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 9px;
  color: #999;
  font-weight: 600;
}
.footer-sub-text {
  font-size: 12px;
  color: #888;
  margin-bottom: 12px;
  line-height: 1.5;
}
.footer-subscribe {
  display: flex;
  border-radius: 3px;
  overflow: hidden;
  border: 1px solid #333;
}
.subscribe-input {
  flex: 1;
  padding: 9px 12px;
  border: none;
  background: #1a1a1a;
  color: #fff;
  font-size: 12px;
  outline: none;
}
.subscribe-input::placeholder { color: #555; }
.subscribe-btn {
  padding: 9px 14px;
  background: #e60023;
  color: #fff;
  border: none;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
}
.subscribe-btn:hover { background: #c5001e; }
.payment-icons {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.payment-icon {
  padding: 4px 10px;
  background: #1a1a1a;
  border-radius: 3px;
  font-size: 10px;
  font-weight: 700;
  color: #888;
  letter-spacing: 0.5px;
}
.shipping-partners {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.partner-tag {
  padding: 3px 10px;
  background: #1a1a1a;
  border-radius: 3px;
  font-size: 10px;
  font-weight: 600;
  color: #666;
}
.footer-bottom {
  border-top: 1px solid #222;
  padding: 20px 16px 0;
  margin-top: 24px;
  text-align: center;
}
.copyright { font-size: 12px; color: #555; margin-bottom: 4px; }
.footer-note { font-size: 11px; color: #444; }

/* ========== 响应式 ========== */
@media (max-width: 1400px) {
  .product-grid { grid-template-columns: repeat(5, 1fr); }
  .footer-grid { grid-template-columns: repeat(3, 1fr); }
  .activity-grid-v2 { gap: 12px; }
}
@media (max-width: 1200px) {
  .activity-grid-v2 { grid-template-columns: 1fr 1fr; }
  .card-brands { display: none; }
  .card-trending { border-radius: 10px 10px 0 0; }
  .card-flash { border-radius: 10px 10px 0 0; }
}
@media (max-width: 1100px) {
  .hero-left, .hero-right { width: 260px; }
  .product-grid { grid-template-columns: repeat(4, 1fr); }
  .category-grid { grid-template-columns: repeat(5, 1fr); }
}
@media (max-width: 900px) {
  .hero-left, .hero-right { display: none; }
  .hero-inner { height: auto; }
  .hero-carousel { min-height: 300px; }
  .product-grid { grid-template-columns: repeat(3, 1fr); gap: 12px; }
  .activity-grid-v2 { grid-template-columns: 1fr; }
  .card-trending { display: none; }
  .footer-grid { grid-template-columns: repeat(2, 1fr); }
  .b2b-btn { display: none; }
}
@media (max-width: 600px) {
  /* 政策条 */
  .policy-inner { flex-wrap: wrap; height: auto; padding: 4px 0; }
  .policy-item { padding: 4px 12px; border-right: none; border-bottom: 1px solid #eee; flex: 1 1 50%; font-size: 11px; }

  /* 导航头 */
  .header-inner { flex-wrap: wrap; gap: 8px; padding: 8px 12px; }
  .logo { font-size: 24px; }
  .b2b-btn { display: none; }
  .search-bar { max-width: 100%; order: 3; width: 100%; }
  .header-actions { gap: 2px; }
  .action-btn { width: 32px; height: 32px; }
  .signin-btn { padding: 6px 12px; font-size: 12px; }
  .user-panel { padding: 2px 8px 2px 2px; }
  .user-name { font-size: 11px; max-width: 60px; }

  /* 分类导航 */
  .category-nav-inner { padding: 0 8px; }
  .cat-item { padding: 10px 12px; font-size: 12px; }
  .cat-special, .cat-distributor { padding: 5px 10px; font-size: 11px; }
  .nav-divider { margin: 0 4px; }

  /* Hero轮播 */
  .hero-section { padding: 8px 0; }
  .hero-carousel { min-height: 220px; }
  .carousel-title { font-size: 18px; }
  .carousel-content { padding: 12px 16px; }

  /* 分类图标墙 */
  .category-grid-section { padding: 12px 0; }
  .category-grid { grid-template-columns: repeat(5, 1fr); gap: 8px; }
  .cat-icon-img { width: 48px; height: 48px; }
  .cat-icon-name { font-size: 10px; }

  /* 活动三列 - 手机全宽堆叠 */
  .activity-section { padding: 12px 0; }
  .activity-section .section-inner { padding: 0 12px; }
  .activity-grid-v2 { grid-template-columns: 1fr; gap: 10px; }
  .card-flash { min-height: auto; }
  .card-trending, .card-brands { display: flex; min-height: auto; }
  .flash-products-v2 { padding: 10px 12px; gap: 8px; }
  .trending-list-v2, .brands-list-v2 { max-height: none; }

  /* 商品网格 */
  .products-section { padding: 16px 0 20px; }
  .section-title { font-size: 16px; }
  .product-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
  .product-card-wrap { }
  .product-name { font-size: 11px; }
  .product-price { font-size: 13px; }
  .b2b-price-btn { height: 36px; padding: 4px 6px; margin-top: 0; flex-shrink: 0; font-size: 10px; }
  .b2b-price-text strong { font-size: 11px; }
  .load-more { margin-top: 16px; }
  .load-more-btn { padding: 10px 32px; font-size: 12px; }

  /* Footer */
  .footer-inner { padding: 24px 0 16px; }
  .footer-grid { grid-template-columns: 1fr; gap: 20px; padding: 0 12px; }
  .footer-heading { font-size: 12px; margin-bottom: 10px; }
  .footer-links { gap: 6px; }
  .footer-links a { font-size: 11px; }
  .footer-bottom { padding: 12px 12px 0; }
  .copyright, .footer-note { font-size: 10px; }
}
</style>
