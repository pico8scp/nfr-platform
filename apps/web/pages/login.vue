<template>
  <div class="shein-home">
    <div class="top-policy">
      <div class="policy-inner">
        <span class="policy-item">{{ homePage.topNotice }}</span>
        <span class="policy-item">全站类目实时更新</span>
        <span class="policy-item">精选货源稳定供给</span>
        <span class="policy-item">{{ homePage.siteName }}</span>
      </div>
    </div>

    <header class="main-header" :class="{ scrolled: isScrolled }">
      <div class="header-inner">
        <button class="logo-button" type="button" @click="goTo('/')">
          <span class="logo">NFR</span>
        </button>

        <button class="b2b-btn" type="button" title="企业批发 - 企业账户" @click="goTo('/b2b')">
          <span class="b2b-icon">🏭</span>
          <span class="b2b-text">
            <span class="b2b-main">企业批发</span>
            <span class="b2b-sub">企业账户</span>
          </span>
          <span class="b2b-vip">VIP</span>
        </button>

        <div class="header-search">
          <SiteSearchBox
            v-model="searchKeyword"
            placeholder="Search products, categories, activities..."
            button-text="Search"
            @submit="handleSearch"
          />
        </div>

        <div class="header-actions">
          <button class="action-btn" type="button" title="收藏" @click="goTo('/wishlist')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
            </svg>
            <span class="action-badge">0</span>
          </button>
          <button class="action-btn" type="button" title="购物车" @click="goTo('/cart')">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="9" cy="21" r="1" />
              <circle cx="20" cy="21" r="1" />
              <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6" />
            </svg>
            <span class="action-badge">{{ homePage.cartCount }}</span>
          </button>
          <button class="signin-btn" type="button" title="登录" @click="goTo('/login')">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
              <circle cx="12" cy="7" r="4" />
            </svg>
            <span>登录</span>
          </button>
        </div>
      </div>
    </header>

    <nav class="category-nav">
      <div class="category-nav-inner">
        <div
          class="all-category-entry"
          @mouseenter="openCategoryMenu()"
          @mouseleave="closeCategoryMenu()"
        >
          <button class="cat-item cat-item-all" type="button" @click="goTo('/products')">
            <span class="cat-item-all-icon">☰</span>
            <span>全部分类</span>
            <span class="cat-item-all-arrow">▾</span>
          </button>

          <div v-if="categoryMenuOpen && activeCategoryRoot" class="category-mega-menu">
            <div class="category-root-list">
              <div class="category-root-list-head">
                <span class="category-root-list-kicker">NFR Supply</span>
                <strong class="category-root-list-title">核心类目</strong>
              </div>
              <button
                v-for="root in categoryMenuRoots"
                :key="root.id"
                type="button"
                class="category-root-item"
                :class="{ active: root.id === activeCategoryRoot?.id }"
                @mouseenter="setActiveCategoryRoot(root.id)"
                @click="goToCategory(root)"
              >
                <span class="category-root-item-main">
                  <span class="category-root-name">{{ root.name }}</span>
                  <span class="category-root-meta">{{ root.children.length }} 个子分类</span>
                </span>
                <span class="category-root-arrow">›</span>
              </button>
            </div>

            <div class="category-panel-content">
              <div class="category-panel-header">
                <div class="category-panel-header-main">
                  <span class="category-panel-kicker">平台分类</span>
                  <button class="category-panel-title" type="button" @click="goToCategory(activeCategoryRoot)">
                    {{ activeCategoryRoot.name }}
                  </button>
                  <p class="category-panel-subtitle">
                    当前类目下共有 {{ activeCategoryRoot.children.length }} 组细分频道。
                  </p>
                </div>
                <button class="category-panel-all" type="button" @click="goToCategory(activeCategoryRoot)">查看类目</button>
              </div>

              <div class="category-panel-groups">
                <div
                  v-for="child in activeCategoryRoot.children.slice(0, 18)"
                  :key="child.id"
                  class="category-panel-group"
                >
                  <div class="category-panel-group-head">
                    <button class="category-panel-group-title" type="button" @click="goToCategory(child)">
                      {{ child.name }}
                    </button>
                    <span class="category-panel-group-count">{{ child.children.length || 0 }} 项</span>
                  </div>
                  <div v-if="child.children.length" class="category-panel-links">
                    <button
                      v-for="grand in child.children.slice(0, 10)"
                      :key="grand.id"
                      type="button"
                      class="category-panel-link"
                      @click="goToCategory(grand)"
                    >
                      <span>{{ grand.name }}</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <button class="cat-item active" type="button" @click="goTo('/')">Home</button>
        <button
          v-for="item in primaryNavItems"
          :key="item.id"
          type="button"
          class="cat-item"
          @click="goToCategory(item)"
        >
          {{ item.name }}
        </button>
        <span class="nav-divider"></span>
        <button class="cat-item cat-special" type="button" @click="goTo('/activity')">活动中心</button>
        <button class="cat-item cat-distributor" type="button" @click="goTo('/distribution')">分销商</button>
        <button class="cat-item cat-item-sale" type="button" @click="goTo('/seckill')">限时特惠</button>
      </div>
    </nav>

    <main class="login-main">
      <section class="login-stage">
        <div class="login-stage-inner">
          <div class="promo-panel">
            <div class="promo-status-row">
              <span class="promo-status-badge">Account Center</span>
              <span class="promo-status-copy">头部沿用首页，主体改成登录注册承接区</span>
            </div>

            <div class="promo-carousel">
              <div class="promo-track" :style="promoTrackStyle">
                <article
                  v-for="slide in promoSlides"
                  :key="slide.id"
                  class="promo-slide"
                >
                  <img
                    class="promo-slide-image"
                    :src="slide.image"
                    :alt="slide.title"
                    @error="handleImageError($event, slide.fallbackImage)"
                  />
                  <div class="promo-slide-overlay"></div>
                  <div class="promo-slide-content">
                    <span class="promo-slide-tag">{{ slide.tag }}</span>
                    <h1 class="promo-slide-title">{{ slide.title }}</h1>
                    <p class="promo-slide-summary">{{ slide.summary }}</p>

                    <div class="promo-slide-highlights">
                      <span v-for="item in slide.highlights" :key="item" class="promo-highlight">
                        {{ item }}
                      </span>
                    </div>

                    <div class="promo-slide-footer">
                      <button class="promo-primary" type="button" @click="goTo(slide.link)">
                        {{ slide.cta }}
                      </button>
                      <div class="promo-stat">
                        <strong>{{ slide.metric }}</strong>
                        <span>{{ slide.metricLabel }}</span>
                      </div>
                    </div>
                  </div>
                </article>
              </div>

              <button class="promo-arrow promo-arrow-prev" type="button" @click="previousPromoSlide">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M15 18l-6-6 6-6" />
                </svg>
              </button>
              <button class="promo-arrow promo-arrow-next" type="button" @click="nextPromoSlide">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M9 18l6-6-6-6" />
                </svg>
              </button>

              <div class="promo-dots">
                <button
                  v-for="(slide, index) in promoSlides"
                  :key="slide.id"
                  type="button"
                  class="promo-dot"
                  :class="{ active: index === activePromoSlide }"
                  @click="activePromoSlide = index"
                ></button>
              </div>
            </div>

            <div class="promo-insights">
              <button class="promo-insight-card promo-insight-action" type="button" @click="goTo('/activity')">
                <span class="promo-insight-label">活动中心</span>
                <strong>进入活动中心</strong>
                <p>查看平台活动、专题会场与限时促销入口。</p>
                <span class="promo-insight-action-link">前往活动中心</span>
              </button>
              <button class="promo-insight-card promo-insight-action" type="button" @click="goTo('/distribution')">
                <span class="promo-insight-label">渠道合作</span>
                <strong>申请分销商资格</strong>
                <p>提交资料后开通。</p>
                <span class="promo-insight-action-link">前往分销申请</span>
              </button>
              <button class="promo-insight-card promo-insight-action accent" type="button" @click="goTo('/b2b')">
                <span class="promo-insight-label">企业采购</span>
                <strong>申请企业客户账号</strong>
                <p>提交资料后开通。</p>
                <span class="promo-insight-action-link">前往企业申请</span>
              </button>
            </div>

          </div>

          <div class="auth-panel">
            <div class="auth-shell">
              <div class="auth-tabs">
                <button
                  type="button"
                  class="auth-tab"
                  :class="{ active: authTab === 'login' }"
                  @click="selectAuthTab('login')"
                >
                  &#x8d26;&#x53f7;&#x767b;&#x5f55;
                </button>
                <button
                  type="button"
                  class="auth-tab"
                  :class="{ active: authTab === 'register' }"
                  @click="selectAuthTab('register')"
                >
                  &#x8d26;&#x6237;&#x6ce8;&#x518c;
                </button>
              </div>

              <div v-if="authTab === 'login'" class="auth-body">
                <div class="auth-header">
                  <span class="auth-kicker">&#x5b89;&#x5168;&#x767b;&#x5f55;</span>
                  <h2>&#x767b;&#x5f55;&#x60a8;&#x7684;&#x8d26;&#x6237;</h2>
                  <p>&#x4f7f;&#x7528;&#x8d26;&#x53f7;&#x3001;&#x624b;&#x673a;&#x53f7;&#x6216;&#x90ae;&#x7bb1;&#x767b;&#x5f55;&#xff0c;&#x56fe;&#x7247;&#x9a8c;&#x8bc1;&#x7801;&#x4e0e;&#x57fa;&#x7840;&#x9632;&#x62a4;&#x5df2;&#x542f;&#x7528;&#x3002;</p>
                </div>

                <form class="auth-form" @submit.prevent="submitLogin">
                  <input
                    v-model="loginForm.website"
                    class="bot-trap-input"
                    type="text"
                    tabindex="-1"
                    autocomplete="off"
                    aria-hidden="true"
                  />

                  <label class="field">
                    <span class="field-label">&#x8d26;&#x53f7; / &#x624b;&#x673a;&#x53f7; / &#x90ae;&#x7bb1;</span>
                    <input
                      v-model="loginForm.account"
                      type="text"
                      autocomplete="username"
                      placeholder="&#x8bf7;&#x8f93;&#x5165;&#x8d26;&#x53f7;&#x3001;&#x624b;&#x673a;&#x53f7;&#x6216;&#x90ae;&#x7bb1;"
                    />
                  </label>

                  <label class="field">
                    <span class="field-label">&#x767b;&#x5f55;&#x5bc6;&#x7801;</span>
                    <input
                      v-model="loginForm.password"
                      type="password"
                      autocomplete="current-password"
                      placeholder="&#x8bf7;&#x8f93;&#x5165;&#x767b;&#x5f55;&#x5bc6;&#x7801;"
                    />
                  </label>

                  <div class="field-group auth-captcha-row">
                    <label class="field">
                      <span class="field-label">&#x56fe;&#x7247;&#x9a8c;&#x8bc1;&#x7801;</span>
                      <input
                        v-model="loginForm.securityCode"
                        type="text"
                        autocomplete="off"
                        inputmode="text"
                        maxlength="6"
                        placeholder="&#x8bf7;&#x8f93;&#x5165;&#x56fe;&#x7247;&#x9a8c;&#x8bc1;&#x7801;"
                      />
                    </label>

                    <button
                      class="captcha-trigger"
                      type="button"
                      :disabled="securityCaptchaLoading"
                      @click="loadSecurityCaptcha()"
                    >
                      <img v-if="securityCaptchaImage" :src="securityCaptchaImage" alt="&#x56fe;&#x7247;&#x9a8c;&#x8bc1;&#x7801;" class="captcha-image" />
                      <span v-else>{{ securityCaptchaLoading ? '&#x52a0;&#x8f7d;&#x4e2d;...' : '&#x70b9;&#x51fb;&#x5237;&#x65b0;&#x9a8c;&#x8bc1;&#x7801;' }}</span>
                    </button>
                  </div>

                  <div class="auth-note">
                    <strong>&#x5b89;&#x5168;&#x63d0;&#x793a;</strong>
                    <span>&#x82e5;&#x9a8c;&#x8bc1;&#x7801;&#x770b;&#x4e0d;&#x6e05;&#xff0c;&#x53ef;&#x70b9;&#x51fb;&#x56fe;&#x7247;&#x5237;&#x65b0;&#x3002;</span>
                  </div>

                  <div v-if="loginFeedback.message" class="auth-feedback" :class="loginFeedback.type">
                    {{ loginFeedback.message }}
                  </div>

                  <button class="primary-action" type="submit" :disabled="loginSubmitting">
                    {{ loginSubmitLabel }}
                  </button>
                </form>

                <p class="auth-footnote">
                  &#x767b;&#x5f55;&#x8fc7;&#x7a0b;&#x4f1a;&#x542f;&#x7528; Cookie &#x4e0e;&#x98ce;&#x63a7;&#x6821;&#x9a8c;&#xff0c;&#x7528;&#x4e8e;&#x4fdd;&#x62a4;&#x4f1a;&#x8bdd;&#x5b89;&#x5168;&#x4e0e;&#x9632;&#x6b62;&#x6ee5;&#x7528;&#x3002;                </p>
              </div>

              <div v-else class="auth-body">
                <div class="auth-header">
                  <span class="auth-kicker">手机号注册</span>
                  <h2>&#x8d26;&#x6237;&#x6ce8;&#x518c;</h2>
                  <p>&#x4ec5;&#x5f00;&#x653e;&#x666e;&#x901a;&#x4f1a;&#x5458;&#x6ce8;&#x518c;&#x3002;</p>
                </div>

                <form class="auth-form" @submit.prevent="submitRegisterSafe">
                  <input
                    v-model="registerForm.website"
                    class="bot-trap-input"
                    type="text"
                    tabindex="-1"
                    autocomplete="off"
                    aria-hidden="true"
                  />

                  <div class="field-grid two-columns">
                    <label class="field">
                      <span class="field-label">&#x624b;&#x673a;&#x53f7;&#x7801;</span>
                      <input
                        v-model="registerForm.phone"
                        type="tel"
                        inputmode="numeric"
                        autocomplete="tel"
                        placeholder="&#x8bf7;&#x8f93;&#x5165;&#x624b;&#x673a;&#x53f7;&#x7801;"
                      />
                    </label>

                    <label class="field">
                      <span class="field-label">&#x60a8;&#x7684;&#x59d3;&#x540d;</span>
                      <input
                        v-model="registerForm.contact"
                        type="text"
                        autocomplete="name"
                        placeholder="&#x8bf7;&#x8f93;&#x5165;&#x60a8;&#x7684;&#x59d3;&#x540d;"
                      />
                    </label>
                  </div>

                  <div class="auth-note register-login-note">
                    <strong>&#x6ce8;&#x518c;&#x987b;&#x77e5;</strong>
                    <span>&#x5148;&#x5b8c;&#x6210;&#x77ed;&#x4fe1;&#x9a8c;&#x8bc1;&#xff0c;&#x518d;&#x63d0;&#x4ea4;&#x6ce8;&#x518c;&#x4fe1;&#x606f;&#x3002;</span>
                  </div>

                  <label class="field">
                    <span class="field-label">&#x767b;&#x5f55;&#x5bc6;&#x7801;</span>
                    <input
                      v-model="registerForm.password"
                      type="password"
                      autocomplete="new-password"
                      placeholder="&#x8bf7;&#x8f93;&#x5165; 6-32 &#x4f4d;&#x767b;&#x5f55;&#x5bc6;&#x7801;"
                    />
                  </label>

                  <label class="field">
                    <span class="field-label">&#x786e;&#x8ba4;&#x767b;&#x5f55;&#x5bc6;&#x7801;</span>
                    <input
                      v-model="registerForm.passwordConfirm"
                      type="password"
                      autocomplete="new-password"
                      placeholder="&#x8bf7;&#x518d;&#x6b21;&#x8f93;&#x5165;&#x767b;&#x5f55;&#x5bc6;&#x7801;"
                    />
                  </label>

                  <div class="field-group auth-captcha-row">
                    <label class="field">
                      <span class="field-label">&#x56fe;&#x7247;&#x9a8c;&#x8bc1;&#x7801;</span>
                      <input
                        v-model="registerForm.securityCode"
                        type="text"
                        autocomplete="off"
                        inputmode="text"
                        maxlength="6"
                        placeholder="&#x8bf7;&#x8f93;&#x5165;&#x56fe;&#x7247;&#x9a8c;&#x8bc1;&#x7801;"
                      />
                    </label>

                    <button
                      class="captcha-trigger"
                      type="button"
                      :disabled="securityCaptchaLoading"
                      @click="loadSecurityCaptcha()"
                    >
                      <img v-if="securityCaptchaImage" :src="securityCaptchaImage" alt="&#x56fe;&#x7247;&#x9a8c;&#x8bc1;&#x7801;" class="captcha-image" />
                      <span v-else>{{ securityCaptchaLoading ? '&#x52a0;&#x8f7d;&#x4e2d;...' : '&#x70b9;&#x51fb;&#x5237;&#x65b0;&#x9a8c;&#x8bc1;&#x7801;' }}</span>
                    </button>
                  </div>

                  <div class="behavior-captcha-status" :class="{ verified: behaviorCaptchaVerified }">
                    <div class="behavior-captcha-status-copy">
                      <span class="field-label">&#x884c;&#x4e3a;&#x9a8c;&#x8bc1;</span>
                      <p>{{ behaviorCaptchaVerified ? '&#x9a8c;&#x8bc1;&#x5df2;&#x901a;&#x8fc7;&#xff0c;&#x73b0;&#x5728;&#x53ef;&#x4ee5;&#x53d1;&#x9001;&#x77ed;&#x4fe1;&#x9a8c;&#x8bc1;&#x7801;&#x3002;' : '&#x53d1;&#x9001;&#x77ed;&#x4fe1;&#x524d;&#x9700;&#x5148;&#x5b8c;&#x6210;&#x884c;&#x4e3a;&#x9a8c;&#x8bc1;&#x3002;' }}</p>
                    </div>

                    <button
                      class="secondary-action compact"
                      type="button"
                      :disabled="behaviorCaptchaLoading || behaviorCaptchaVerifying"
                      @click="openBehaviorCaptchaModal(true)"
                    >
                      {{ behaviorCaptchaVerified ? '&#x91cd;&#x65b0;&#x9a8c;&#x8bc1;' : '&#x5f00;&#x59cb;&#x9a8c;&#x8bc1;' }}
                    </button>
                  </div>

                  <div
                    v-if="behaviorCaptchaModalOpen"
                    class="behavior-captcha-card behavior-captcha-modal-card"
                    :class="{ verified: behaviorCaptchaVerified }"
                  >
                    <div class="behavior-captcha-head">
                      <div class="behavior-captcha-copy">
                        <span class="field-label">&#x5b89;&#x5168;&#x9a8c;&#x8bc1;</span>
                        <span class="behavior-captcha-modal-title">&#x5b89;&#x5168;&#x9a8c;&#x8bc1;</span>
                        <p>{{ behaviorCaptchaDisplayHint }}</p>
                      </div>
                      <button
                        class="behavior-captcha-close"
                        type="button"
                        :disabled="behaviorCaptchaVerifying"
                        @click="closeBehaviorCaptchaModal"
                      >
                        x                      </button>
                      <button
                        class="behavior-captcha-refresh"
                        type="button"
                        :disabled="behaviorCaptchaLoading || behaviorCaptchaVerifying"
                        @click="refreshBehaviorCaptchaModal()"
                      >
                        {{ behaviorCaptchaRefreshLabel }}
                      </button>
                    </div>

                    <div
                      v-if="behaviorCaptchaOriginalImage"
                      ref="behaviorCaptchaStage"
                      class="behavior-captcha-stage"
                    >
                      <img
                        class="behavior-captcha-background"
                        :src="behaviorCaptchaOriginalImage"
                        alt="&#x9a8c;&#x8bc1;&#x80cc;&#x666f;"
                        @load="handleBehaviorCaptchaBackgroundLoad"
                      />
                      <img
                        v-if="behaviorCaptchaPieceImage"
                        class="behavior-captcha-piece"
                        :src="behaviorCaptchaPieceImage"
                        alt="&#x9a8c;&#x8bc1;&#x62fc;&#x56fe;"
                        :style="behaviorCaptchaPieceStyle"
                        @load="handleBehaviorCaptchaPieceLoad"
                      />
                      <div v-if="behaviorCaptchaVerifying" class="behavior-captcha-overlay">
                        &#x6b63;&#x5728;&#x6821;&#x9a8c;&#xff0c;&#x8bf7;&#x7a0d;&#x5019;...
                      </div>
                    </div>

                    <div v-else-if="behaviorCaptchaLoading || behaviorCaptchaState === 'idle'" class="behavior-captcha-empty">
                      正在加载验证图片，请稍候...
                    </div>

                    <div v-else class="behavior-captcha-empty">
                      &#x9a8c;&#x8bc1;&#x56fe;&#x7247;&#x52a0;&#x8f7d;&#x5931;&#x8d25;&#xff0c;&#x8bf7;&#x5237;&#x65b0;&#x540e;&#x91cd;&#x8bd5;&#x3002;                    </div>

                    <div class="behavior-captcha-slider" :class="{ verified: behaviorCaptchaVerified }">
                      <div class="behavior-captcha-track">
                        <div class="behavior-captcha-progress" :style="behaviorCaptchaProgressStyle"></div>
                        <button
                          class="behavior-captcha-thumb"
                          type="button"
                          :disabled="!behaviorCaptchaInteractive"
                          :style="behaviorCaptchaThumbStyle"
                          @pointerdown="startBehaviorCaptchaDrag"
                        >
                          <span>{{ behaviorCaptchaVerified ? 'OK' : '>>' }}</span>
                        </button>
                        <span class="behavior-captcha-track-text">{{ behaviorCaptchaDisplayTrackLabel }}</span>
                      </div>
                    </div>
                  </div>

                  <div class="field-group">
                    <label class="field">
                      <span class="field-label">&#x77ed;&#x4fe1;&#x9a8c;&#x8bc1;&#x7801;</span>
                      <input
                        v-model="registerForm.smsCode"
                        type="text"
                        placeholder="&#x8bf7;&#x8f93;&#x5165;&#x77ed;&#x4fe1;&#x9a8c;&#x8bc1;&#x7801;"
                      />
                    </label>

                    <button
                      class="secondary-action compact"
                      type="button"
                      :disabled="smsSending || smsCooldown > 0"
                      @click="handleRegisterCodeActionSafe"
                    >
                      {{ registerCodeActionLabel }}
                    </button>
                  </div>

                  <div v-if="registerFeedback.message" class="auth-feedback" :class="registerFeedback.type">
                    {{ registerFeedback.message }}
                  </div>

                  <button class="primary-action" type="submit" :disabled="registerSubmitting">
                    {{ registerSubmitLabel }}
                  </button>
                </form>

              </div>

            </div>
          </div>
        </div>
      </section>
    </main>
  </div>
</template>

<script setup lang="ts">
import {
  AUTH_BEHAVIOR_RELOAD_DELAY_MS,
  AUTH_CAPTCHA_TYPE,
  AUTH_PROMO_FALLBACK_IMAGES,
  AUTH_SMS_COOLDOWN_SECONDS,
  AUTH_SPREAD_QUERY_KEY,
  AUTH_STORAGE_KEYS,
} from '~/config/auth'
import { resolveApiPath } from '~/config/crmeb-api'

definePageMeta({
  layout: 'home',
})

useHead({
  title: 'NFR 登录 / 注册',
})

interface CrmebResponse<T> {
  status?: number
  msg?: string
  data?: T
}

interface SecurityCaptchaPayload {
  image?: string
  expiresIn?: number
}

interface BehaviorCaptchaPayload {
  originalImageBase64?: string
  jigsawImageBase64?: string
  secretKey?: string
  token?: string
}

interface BehaviorCheckPayload {
  captchaVerification?: string
  rateLimited?: boolean
  retryAfterSeconds?: number
}

interface LoginPayload {
  token?: string
  expires_time?: string | number
  [key: string]: unknown
}

interface PromoSlide {
  id: string
  tag: string
  title: string
  summary: string
  cta: string
  link: string
  image: string
  fallbackImage: string
  metric: string
  metricLabel: string
  highlights: string[]
}

type FeedbackType = 'info' | 'success' | 'error'
type AuthTab = 'login' | 'register'

const router = useRouter()
const route = useRoute()
const config = useRuntimeConfig()
const apiBase = config.public.apiBase
const tokenCookie = useCookie<string | null>(AUTH_STORAGE_KEYS.tokenCookie, { sameSite: 'lax' })
const authCookie = useCookie<Record<string, unknown> | null>(AUTH_STORAGE_KEYS.authCookie, { sameSite: 'lax' })

const searchKeyword = ref('')
const isScrolled = ref(false)
const categoryMenuOpen = ref(false)
const activeCategoryRootId = ref<number | null>(null)
const activePromoSlide = ref(0)
const authTab = ref<AuthTab>('login')
const loginSubmitting = ref(false)
const registerSubmitting = ref(false)
const smsSending = ref(false)
const smsCooldown = ref(0)
const behaviorCaptchaLoading = ref(false)
const behaviorCaptchaState = ref<'idle' | 'ready' | 'error'>('idle')
const securityCaptchaImage = ref('')
const securityCaptchaLoading = ref(false)
const smsCooldownTimer = ref<ReturnType<typeof setInterval> | null>(null)
const loginFeedback = reactive({ type: 'info' as FeedbackType, message: '' })
const registerFeedback = reactive({ type: 'info' as FeedbackType, message: '' })
const registerSecurityPassed = ref(false)
const fallbackPromoImages = AUTH_PROMO_FALLBACK_IMAGES

const loginForm = reactive({
  account: '',
  password: '',
  securityCode: '',
  website: '',
})

const registerForm = reactive({
  phone: '',
  contact: '',
  password: '',
  passwordConfirm: '',
  securityCode: '',
  smsCode: '',
  captchaType: AUTH_CAPTCHA_TYPE,
  captchaVerification: '',
  website: '',
})

const behaviorCaptchaStage = ref<HTMLElement | null>(null)
const behaviorCaptchaToken = ref('')
const behaviorCaptchaSecretKey = ref('')
const behaviorCaptchaOriginalImage = ref('')
const behaviorCaptchaPieceImage = ref('')
const behaviorCaptchaOffset = ref(0)
const behaviorCaptchaStageWidth = ref(0)
const behaviorCaptchaNaturalWidth = ref(0)
const behaviorCaptchaPieceNaturalWidth = ref(0)
const behaviorCaptchaDragging = ref(false)
const behaviorCaptchaVerified = ref(false)
const behaviorCaptchaVerifying = ref(false)
const behaviorCaptchaModalOpen = ref(false)
const behaviorCaptchaDragPointerOffset = ref(0)
const behaviorCaptchaNotice = ref('')
const behaviorCaptchaKnobSize = 48
const authDeviceIdStorageKey = AUTH_STORAGE_KEYS.authDeviceId
let behaviorCaptchaReloadTimer: ReturnType<typeof setTimeout> | null = null
let authDeviceId = ''

const { homePage, loadHomePage } = useHomePage()

const categoryMenuRoots = computed(() => homePage.value.categoryTreeRoots)
const activeCategoryRoot = computed(() => {
  return categoryMenuRoots.value.find((item) => item.id === activeCategoryRootId.value) ?? categoryMenuRoots.value[0] ?? null
})
const primaryNavItems = computed(() => {
  return homePage.value.navItems
    .filter((item) => !item.link.includes('category_id=') && !['/activity', '/distribution', '/seckill'].includes(item.link))
    .slice(0, 8)
})
const loginSubmitLabel = computed(() => {
  return loginSubmitting.value ? '登录中...' : '账号登录'
})
const registerSubmitLabel = computed(() => {
  return registerSubmitting.value ? '提交中...' : '提交注册'
})
const promoSlides = computed<PromoSlide[]>(() => [
  {
    id: 'promo-b2b',
    tag: 'B2B WHOLESALE',
    title: '企业采购、批发询价与平台招商统一入口',
    summary: '围绕 B2B 采购场景承接大客户询盘、批量报价与合作洽谈。',
    cta: '进入 B2B 入口',
    link: '/b2b',
    image: homePage.value.banners[0]?.image || fallbackPromoImages[0],
    fallbackImage: fallbackPromoImages[0],
    metric: String(categoryMenuRoots.value.length),
    metricLabel: '顶级类目',
    highlights: ['B2B 批发', '采购询盘', '稳定供给'],
  },
  {
    id: 'promo-distributor',
    tag: 'CHANNEL PARTNER',
    title: '分销合作与渠道伙伴申请入口',
    summary: '为渠道合作、区域分销与多角色协同提供统一承接。',
    cta: '查看合作入口',
    link: '/distribution',
    image: homePage.value.banners[1]?.image || homePage.value.featuredProducts[0]?.image || fallbackPromoImages[1],
    fallbackImage: fallbackPromoImages[1],
    metric: String(homePage.value.featuredProducts.length),
    metricLabel: '推荐商品',
    highlights: ['渠道合作', '伙伴招募', '专属支持'],
  },
  {
    id: 'promo-1688',
    tag: '1688 SUPPLY',
    title: '1688 供货能力与前台账号体系联动',
    summary: '为后续 1688 类目采集、商品同步与供应链联调保留稳定入口。',
    cta: '浏览首页分类',
    link: '/products',
    image: homePage.value.banners[2]?.image || homePage.value.dealProducts[0]?.image || fallbackPromoImages[2],
    fallbackImage: fallbackPromoImages[2],
    metric: behaviorCaptchaState.value === 'error' ? '待检查' : '可用',
    metricLabel: '验证状态',
    highlights: ['1688 供货', '统一账户', '移动端复用'],
  },
])
const promoTrackStyle = computed(() => ({ transform: `translateX(-${activePromoSlide.value * 100}%)` }))
const authHealthLabel = computed(() => {
  return behaviorCaptchaState.value === 'error' ? '服务异常' : '服务正常'
})
const behaviorCaptchaHeadline = computed(() => {
  if (behaviorCaptchaState.value === 'ready') {
    return '行为验证已就绪。'
  }

  if (behaviorCaptchaNotice.value) {
    return behaviorCaptchaNotice.value
  }

  if (behaviorCaptchaState.value === 'error') {
    return '行为验证服务暂不可用，请刷新后重试。'
  }

  return '请完成人机校验后再继续操作。'
})

const behaviorCaptchaInteractive = computed(() => {
  return behaviorCaptchaState.value === 'ready'
    && !behaviorCaptchaLoading.value
    && !behaviorCaptchaVerifying.value
    && !behaviorCaptchaVerified.value
    && Boolean(behaviorCaptchaOriginalImage.value)
    && Boolean(behaviorCaptchaPieceImage.value)
    && behaviorCaptchaStageWidth.value > 0
})
const behaviorCaptchaPieceDisplayWidth = computed(() => {
  if (!behaviorCaptchaNaturalWidth.value || !behaviorCaptchaPieceNaturalWidth.value || !behaviorCaptchaStageWidth.value) {
    return 56
  }

  return Math.max(
    44,
    Math.round((behaviorCaptchaStageWidth.value * behaviorCaptchaPieceNaturalWidth.value) / behaviorCaptchaNaturalWidth.value),
  )
})
const behaviorCaptchaMaxOffset = computed(() => {
  return Math.max(behaviorCaptchaStageWidth.value - behaviorCaptchaPieceDisplayWidth.value, 0)
})
const behaviorCaptchaPieceStyle = computed(() => ({
  transform: `translate3d(${behaviorCaptchaOffset.value}px, 0, 0)`,
  top: '0',
  width: `${behaviorCaptchaPieceDisplayWidth.value}px`,
}))
const behaviorCaptchaThumbStyle = computed(() => ({
  transform: `translate3d(${behaviorCaptchaOffset.value}px, -50%, 0)`,
}))
const behaviorCaptchaProgressStyle = computed(() => ({
  width: `${Math.min(behaviorCaptchaOffset.value + behaviorCaptchaKnobSize, behaviorCaptchaStageWidth.value)}px`,
}))
const behaviorCaptchaHint = computed(() => {
  if (behaviorCaptchaVerifying.value) {
    return '正在校验滑块结果，请稍候。'
  }

  if (behaviorCaptchaVerified.value) {
    return '验证已通过，可以继续操作。'
  }

  if (behaviorCaptchaLoading.value) {
    return '正在加载验证图片...'
  }

  if (behaviorCaptchaState.value === 'error') {
    return '验证服务暂不可用，请稍后重试。'
  }

  return '拖动滑块完成行为验证。'
})
const behaviorCaptchaTrackLabel = computed(() => {
  if (behaviorCaptchaVerified.value) {
    return '验证已通过'
  }

  if (behaviorCaptchaVerifying.value) {
    return '正在校验...'
  }

  return '按住滑块，拖动到缺口位置'
})
const canSendRegisterCode = computed(() => {
  return behaviorCaptchaState.value === 'ready'
    && behaviorCaptchaVerified.value
    && Boolean(registerForm.captchaVerification.trim())
})
const registerCodeButtonLabel = computed(() => {
  if (smsCooldown.value > 0) {
    return `${smsCooldown.value}s 后可重发`
  }

  if (smsSending.value) {
    return '发送中...'
  }

  if (behaviorCaptchaLoading.value || behaviorCaptchaVerifying.value) {
    return '等待验证完成...'
  }

  if (behaviorCaptchaState.value === 'error') {
    return '验证服务异常'
  }

  if (!behaviorCaptchaVerified.value) {
    return '请先完成人机验证'
  }

  return '发送短信验证码'
})
const behaviorCaptchaDisplayHint = computed(() => {
  if (behaviorCaptchaVerifying.value) {
    return '正在校验滑块结果...'
  }
  if (behaviorCaptchaVerified.value) {
    return '验证已通过，现在可以发送短信验证码。'
  }
  if (behaviorCaptchaLoading.value) {
    return '正在加载验证图片...'
  }
  if (behaviorCaptchaNotice.value) {
    return behaviorCaptchaNotice.value
  }
  if (behaviorCaptchaState.value === 'error') {
    return '验证服务暂不可用，请稍后重试。'
  }
  return '拖动滑块，将拼图移动到缺口位置。'
})
const behaviorCaptchaDisplayTrackLabel = computed(() => {
  if (behaviorCaptchaVerified.value) {
    return '验证已通过'
  }

  if (behaviorCaptchaVerifying.value) {
    return '正在校验，请稍候'
  }

  return '按住滑块拖动到缺口处'
})
const behaviorCaptchaRefreshLabel = computed(() => {
  return behaviorCaptchaLoading.value ? '加载中...' : '刷新验证'
})
const registerCodeActionLabel = computed(() => {
  if (smsCooldown.value > 0) {
    return `${smsCooldown.value}s 后可重发`
  }

  if (smsSending.value) {
    return '发送中...'
  }

  return '发送验证码'
})
const authStorageKey = AUTH_STORAGE_KEYS.authStorage
const registerDraftStorageKey = AUTH_STORAGE_KEYS.registerDraft
let promoTimer: ReturnType<typeof setInterval> | null = null

function normalizeSpreadUid(value: unknown): string {
  const normalized = Array.isArray(value) ? String(value[0] ?? '').trim() : String(value ?? '').trim()
  return /^\d+$/.test(normalized) && Number(normalized) > 0 ? normalized : ''
}

const registerSpreadUid = computed(() => {
  return normalizeSpreadUid(route.query[AUTH_SPREAD_QUERY_KEY])
})

function setFeedback(target: typeof loginFeedback | typeof registerFeedback, type: FeedbackType, message: string): void {
  target.type = type
  target.message = message
}

function handleImageError(event: Event, fallbackSrc: string): void {
  const image = event.target as HTMLImageElement | null
  if (!image || !fallbackSrc || image.dataset.fallbackApplied === '1') {
    return
  }

  image.dataset.fallbackApplied = '1'
  image.src = fallbackSrc
}

function nextPromoSlide(): void {
  if (!promoSlides.value.length) {
    return
  }

  activePromoSlide.value = (activePromoSlide.value + 1) % promoSlides.value.length
}

function previousPromoSlide(): void {
  if (!promoSlides.value.length) {
    return
  }

  activePromoSlide.value = (activePromoSlide.value - 1 + promoSlides.value.length) % promoSlides.value.length
}

function startPromoRotation(): void {
  if (promoTimer) {
    clearInterval(promoTimer)
  }

  promoTimer = setInterval(() => {
    nextPromoSlide()
  }, 4500)
}

function persistRegisterDraft(): void {
  if (!process.client) {
    return
  }

  window.localStorage.setItem(registerDraftStorageKey, JSON.stringify({
    phone: registerForm.phone.trim(),
    contact: registerForm.contact.trim(),
  }))
}

function restoreRegisterDraft(): void {
  if (!process.client) {
    return
  }

  const raw = window.localStorage.getItem(registerDraftStorageKey)
  if (!raw) {
    return
  }

  try {
    const parsed = JSON.parse(raw) as Partial<Record<'phone' | 'contact', string>>
    registerForm.phone = String(parsed.phone ?? '')
    registerForm.contact = String(parsed.contact ?? '')
  } catch {
    window.localStorage.removeItem(registerDraftStorageKey)
  }
}

async function requestCrmeb<T>(path: string, options?: Parameters<typeof $fetch<T>>[1]): Promise<CrmebResponse<T>> {
  try {
    return await $fetch<CrmebResponse<T>>(resolveApiPath(apiBase, path), options)
  } catch (error) {
    const fetchError = error as {
      data?: { msg?: string; message?: string }
      message?: string
    }

    throw new Error(fetchError.data?.msg || fetchError.data?.message || fetchError.message || '请求失败，请稍后重试。')
  }
}

async function requestProtected<T>(path: string, options?: Parameters<typeof $fetch<T>>[1]): Promise<CrmebResponse<T>> {
  try {
    return await $fetch<CrmebResponse<T>>(path, options)
  } catch (error) {
    const fetchError = error as {
      data?: { msg?: string; message?: string; rateLimited?: boolean; retryAfterSeconds?: number }
      message?: string
      statusCode?: number
    }

    throw Object.assign(new Error(fetchError.data?.msg || fetchError.data?.message || fetchError.message || '请求失败，请稍后重试。'), { data: fetchError.data, statusCode: fetchError.statusCode })
  }
}

function ensureAuthDeviceId(): string {
  if (authDeviceId) {
    return authDeviceId
  }

  if (!process.client) {
    authDeviceId = 'server-render'
    return authDeviceId
  }

  const existing = window.localStorage.getItem(authDeviceIdStorageKey)?.trim()
  if (existing) {
    authDeviceId = existing
    return authDeviceId
  }

  authDeviceId = typeof window.crypto?.randomUUID === 'function'
    ? window.crypto.randomUUID()
    : `nfr-${Date.now()}-${Math.random().toString(16).slice(2, 10)}`
  window.localStorage.setItem(authDeviceIdStorageKey, authDeviceId)
  return authDeviceId
}

function clearBehaviorCaptchaReloadTimer(): void {
  if (behaviorCaptchaReloadTimer) {
    clearTimeout(behaviorCaptchaReloadTimer)
    behaviorCaptchaReloadTimer = null
  }
}

function scheduleBehaviorCaptchaReload(delayMs = AUTH_BEHAVIOR_RELOAD_DELAY_MS): void {
  clearBehaviorCaptchaReloadTimer()
  behaviorCaptchaReloadTimer = setTimeout(() => {
    behaviorCaptchaReloadTimer = null
    if (behaviorCaptchaModalOpen.value && !behaviorCaptchaVerified.value) {
      void loadBehaviorCaptchaChallengeFixed(true)
    }
  }, delayMs)
}

function normalizeBehaviorCaptchaImage(input: string): string {
  const trimmed = input.trim()
  if (!trimmed) {
    return ''
  }

  if (trimmed.startsWith('data:')) {
    return trimmed
  }

  return `data:image/png;base64,${trimmed}`
}

function syncBehaviorCaptchaStageWidth(): void {
  behaviorCaptchaStageWidth.value = behaviorCaptchaStage.value?.clientWidth || 0
}

function clearBehaviorCaptchaSession(clearImages = false): void {
  clearBehaviorCaptchaReloadTimer()
  behaviorCaptchaDragging.value = false
  behaviorCaptchaVerifying.value = false
  behaviorCaptchaVerified.value = false
  behaviorCaptchaOffset.value = 0
  behaviorCaptchaNotice.value = ''
  registerForm.captchaVerification = ''

  if (clearImages) {
    behaviorCaptchaToken.value = ''
    behaviorCaptchaSecretKey.value = ''
    behaviorCaptchaOriginalImage.value = ''
    behaviorCaptchaPieceImage.value = ''
    behaviorCaptchaNaturalWidth.value = 0
    behaviorCaptchaPieceNaturalWidth.value = 0
    behaviorCaptchaStageWidth.value = 0
  }
}

function clearRegisterSecurityState(clearBehaviorImages = false): void {
  registerSecurityPassed.value = false
  clearBehaviorCaptchaSession(clearBehaviorImages)
}

async function resetRegisterSecurityFlow(clearBehaviorImages = false): Promise<void> {
  clearRegisterSecurityState(clearBehaviorImages)
  await loadSecurityCaptcha()
}

function normalizeRegisterSecurityMessage(message: string): string {
  if (message.includes('参数错误')) {
    return '安全验证已失效，请重新完成图片验证码和行为验证。'
  }

  return message
}

function clampBehaviorCaptchaOffset(value: number): number {
  return Math.min(Math.max(value, 0), behaviorCaptchaMaxOffset.value)
}

function stopBehaviorCaptchaDrag(): void {
  behaviorCaptchaDragging.value = false
  window.removeEventListener('pointermove', handleBehaviorCaptchaDragMove)
  window.removeEventListener('pointerup', handleBehaviorCaptchaDragEnd)
  window.removeEventListener('pointercancel', handleBehaviorCaptchaDragEnd)
}

function handleBehaviorCaptchaBackgroundLoad(event: Event): void {
  const image = event.target as HTMLImageElement | null
  if (!image) {
    return
  }

  behaviorCaptchaNaturalWidth.value = image.naturalWidth
  syncBehaviorCaptchaStageWidth()
}

function handleBehaviorCaptchaPieceLoad(event: Event): void {
  const image = event.target as HTMLImageElement | null
  if (!image) {
    return
  }

  behaviorCaptchaPieceNaturalWidth.value = image.naturalWidth
}

function startBehaviorCaptchaDrag(event: PointerEvent): void {
  if (!behaviorCaptchaInteractive.value) {
    return
  }

  behaviorCaptchaNotice.value = ''
  syncBehaviorCaptchaStageWidth()
  behaviorCaptchaDragging.value = true
  behaviorCaptchaDragPointerOffset.value = event.clientX - behaviorCaptchaOffset.value
  window.addEventListener('pointermove', handleBehaviorCaptchaDragMove)
  window.addEventListener('pointerup', handleBehaviorCaptchaDragEnd)
  window.addEventListener('pointercancel', handleBehaviorCaptchaDragEnd)
}

function handleBehaviorCaptchaDragMove(event: PointerEvent): void {
  if (!behaviorCaptchaDragging.value) {
    return
  }

  behaviorCaptchaOffset.value = clampBehaviorCaptchaOffset(event.clientX - behaviorCaptchaDragPointerOffset.value)
}

async function handleBehaviorCaptchaDragEnd(): Promise<void> {
  if (!behaviorCaptchaDragging.value) {
    return
  }

  stopBehaviorCaptchaDrag()

  if (behaviorCaptchaOffset.value <= 0) {
    return
  }

  await verifyBehaviorCaptchaPositionFixed()
}

async function loadSecurityCaptcha(): Promise<void> {
  securityCaptchaLoading.value = true

  try {
    const response = await requestProtected<SecurityCaptchaPayload>('/api/auth/captcha')
    if (!response.data?.image) {
      throw new Error(response.msg || '图片验证码加载失败，请稍后重试。')
    }

    securityCaptchaImage.value = String(response.data.image)
    loginForm.securityCode = ''
    registerForm.securityCode = ''
  } catch (error) {
    const message = error instanceof Error ? error.message : '图片验证码加载失败，请稍后重试。'
    setFeedback(authTab.value === 'register' ? registerFeedback : loginFeedback, 'error', message)
  } finally {
    securityCaptchaLoading.value = false
  }
}

function extractTokenPayload(payload: LoginPayload | null | undefined): { token: string; expiresTime: string } {
  const token = String(payload?.token ?? '').trim()
  const expiresTime = String(payload?.expires_time ?? '').trim()

  if (!token) {
    throw new Error('登录成功，但系统未返回有效凭证。')
  }

  return {
    token,
    expiresTime,
  }
}

function persistAuth(payload: LoginPayload): void {
  const auth = extractTokenPayload(payload)
  tokenCookie.value = auth.token
  authCookie.value = {
    token: auth.token,
    expiresTime: auth.expiresTime,
    savedAt: Date.now(),
  }

  if (process.client) {
    window.localStorage.setItem(authStorageKey, JSON.stringify(authCookie.value))
  }
}

function goAfterAuth(): void {
  const redirect = typeof route.query.redirect === 'string' && route.query.redirect.startsWith('/')
    ? route.query.redirect
    : '/'
  router.push(redirect)
}

function goTo(path: string): void {
  categoryMenuOpen.value = false
  router.push(path)
}

async function selectAuthTab(nextTab: AuthTab): Promise<void> {
  if (authTab.value === nextTab) {
    return
  }

  authTab.value = nextTab
  loginFeedback.message = ''
  registerFeedback.message = ''
  await loadSecurityCaptcha()

  if (nextTab === 'register') {
    await nextTick()
    syncBehaviorCaptchaStageWidth()
    if (!behaviorCaptchaOriginalImage.value || behaviorCaptchaState.value === 'error') {
      await loadBehaviorCaptchaChallengeFixed(true)
    }
  }
}

function goToCategory(item: { link?: string; id?: number }): void {
  categoryMenuOpen.value = false
  if (item.link) {
    router.push(item.link)
    return
  }

  router.push(`/products?category_id=${item.id ?? ''}`)
}

function openCategoryMenu(rootId?: number): void {
  categoryMenuOpen.value = true
  if (rootId) {
    activeCategoryRootId.value = rootId
    return
  }

  if (!activeCategoryRootId.value && categoryMenuRoots.value.length) {
    activeCategoryRootId.value = categoryMenuRoots.value[0].id
  }
}

function closeCategoryMenu(): void {
  categoryMenuOpen.value = false
}

function setActiveCategoryRoot(rootId: number): void {
  activeCategoryRootId.value = rootId
}

function handleSearch(value?: string): void {
  const keyword = String(value ?? searchKeyword.value).trim()
  if (!keyword) {
    return
  }

  searchKeyword.value = keyword
  router.push(`/products?keyword=${encodeURIComponent(keyword)}`)
}

function handleScroll(): void {
  isScrolled.value = window.scrollY > 20
}

function isPhoneNumber(value: string): boolean {
  return /^1\d{10}$/.test(value.trim())
}

function startSmsCooldown(seconds = AUTH_SMS_COOLDOWN_SECONDS): void {
  smsCooldown.value = seconds

  if (smsCooldownTimer.value) {
    clearInterval(smsCooldownTimer.value)
  }

  smsCooldownTimer.value = setInterval(() => {
    smsCooldown.value = Math.max(0, smsCooldown.value - 1)
    if (smsCooldown.value === 0 && smsCooldownTimer.value) {
      clearInterval(smsCooldownTimer.value)
      smsCooldownTimer.value = null
    }
  }, 1000)
}

async function checkBehaviorCaptchaService(silent = false): Promise<void> {
  behaviorCaptchaLoading.value = true

  try {
    const response = await requestCrmeb<Record<string, unknown>>(`/ajcaptcha?captchaType=${AUTH_CAPTCHA_TYPE}`)
    if (Number(response.status ?? 200) !== 200) {
      throw new Error(response.msg || '行为验证服务暂不可用。')
    }

    if (!silent) {
      setFeedback(registerFeedback, 'success', '行为验证服务可用。')
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : '行为验证服务暂不可用。'
    setFeedback(registerFeedback, 'error', `行为验证服务异常：${message}`)
  } finally {
    behaviorCaptchaLoading.value = false
  }
}

async function loadBehaviorCaptchaChallenge(silent = false): Promise<void> {
  await loadBehaviorCaptchaChallengeFixed(silent)
}

function closeBehaviorCaptchaModal(): void {
  if (behaviorCaptchaVerifying.value) {
    return
  }

  clearBehaviorCaptchaReloadTimer()
  behaviorCaptchaModalOpen.value = false
}

async function loadBehaviorCaptchaChallengeFixed(silent = false): Promise<void> {
  clearBehaviorCaptchaReloadTimer()
  behaviorCaptchaNotice.value = ''
  behaviorCaptchaLoading.value = true

  try {
    clearBehaviorCaptchaSession(true)
    const response = await requestCrmeb<BehaviorCaptchaPayload>(`/ajcaptcha?captchaType=${AUTH_CAPTCHA_TYPE}`)
    const payload = response.data

    if (
      Number(response.status ?? 200) !== 200
      || !payload?.originalImageBase64
      || !payload?.jigsawImageBase64
      || !payload?.token
      || !payload?.secretKey
    ) {
      throw new Error(response.msg || '拼图验证加载失败，请稍后重试。')
    }

    behaviorCaptchaState.value = 'ready'
    behaviorCaptchaToken.value = String(payload.token)
    behaviorCaptchaSecretKey.value = String(payload.secretKey)
    behaviorCaptchaOriginalImage.value = normalizeBehaviorCaptchaImage(String(payload.originalImageBase64))
    behaviorCaptchaPieceImage.value = normalizeBehaviorCaptchaImage(String(payload.jigsawImageBase64))
    await nextTick()
    syncBehaviorCaptchaStageWidth()

    if (!silent) {
      setFeedback(registerFeedback, 'info', '请完成行为验证后，再发送短信验证码。')
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : '拼图验证加载失败，请稍后重试。'
    behaviorCaptchaState.value = 'error'
    clearBehaviorCaptchaSession(true)
    behaviorCaptchaNotice.value = message
    setFeedback(registerFeedback, 'error', message)
  } finally {
    behaviorCaptchaLoading.value = false
  }
}

async function refreshBehaviorCaptchaModal(): Promise<void> {
  await loadBehaviorCaptchaChallengeFixed(true)
}

async function openBehaviorCaptchaModal(forceRefresh = false): Promise<void> {
  clearBehaviorCaptchaReloadTimer()
  behaviorCaptchaModalOpen.value = true
  await nextTick()
  syncBehaviorCaptchaStageWidth()

  if (
    forceRefresh
    || behaviorCaptchaState.value === 'error'
    || !behaviorCaptchaOriginalImage.value
    || !behaviorCaptchaPieceImage.value
  ) {
    await loadBehaviorCaptchaChallengeFixed(true)
  }
}

async function verifyBehaviorCaptchaPositionFixed(): Promise<void> {
  if (!behaviorCaptchaToken.value || !behaviorCaptchaSecretKey.value || !behaviorCaptchaStageWidth.value || !behaviorCaptchaNaturalWidth.value) {
    return
  }
  clearBehaviorCaptchaReloadTimer()
  behaviorCaptchaNotice.value = ''
  behaviorCaptchaVerifying.value = true
  try {
    const response = await requestProtected<BehaviorCheckPayload>('/api/auth/behavior-check', {
      method: 'POST',
      body: {
        token: behaviorCaptchaToken.value,
        secretKey: behaviorCaptchaSecretKey.value,
        captchaType: registerForm.captchaType.trim() || AUTH_CAPTCHA_TYPE,
        deviceId: ensureAuthDeviceId(),
        point: {
          x: Math.round((behaviorCaptchaOffset.value * behaviorCaptchaNaturalWidth.value) / behaviorCaptchaStageWidth.value),
          y: 5,
        },
        website: registerForm.website.trim(),
      },
    })
    if (Number(response.status ?? 200) !== 200 || !response.data?.captchaVerification) {
      throw new Error(response.msg || '拼图验证失败，请重试。')
    }
    registerForm.captchaVerification = String(response.data.captchaVerification)
    behaviorCaptchaVerified.value = true
    behaviorCaptchaNotice.value = ''
    behaviorCaptchaModalOpen.value = false
    setFeedback(registerFeedback, 'success', '行为验证通过，现在可以发送短信验证码。')
  } catch (error) {
    const fetchError = error as Error & { data?: BehaviorCheckPayload; statusCode?: number }
    const isRateLimited = Boolean(fetchError.data?.rateLimited) || fetchError.statusCode === 429
    const retryAfterSeconds = Math.max(1, Number(fetchError.data?.retryAfterSeconds ?? 60))
    const message = isRateLimited
      ? `验证尝试过于频繁，请在 ${retryAfterSeconds} 秒后重试。`
      : (error instanceof Error ? error.message : '拼图验证失败，请重试。')
    behaviorCaptchaNotice.value = message
    setFeedback(registerFeedback, 'error', message)
    if (!isRateLimited) {
      scheduleBehaviorCaptchaReload()
    }
  } finally {
    behaviorCaptchaVerifying.value = false
  }
}
async function handleRegisterCodeAction(): Promise<void> {
  await handleRegisterCodeActionSafe()
}

async function submitLogin(): Promise<void> {
  const account = loginForm.account.trim()
  const password = loginForm.password.trim()
  const captcha = loginForm.securityCode.trim()

  if (!account || !password) {
    setFeedback(loginFeedback, 'error', '请输入账号和登录密码。')
    return
  }

  if (!captcha) {
    setFeedback(loginFeedback, 'error', '请输入图片验证码。')
    return
  }

  loginSubmitting.value = true

  try {
    const response = await requestProtected<LoginPayload>('/api/auth/login', {
      method: 'POST',
      body: {
        account,
        password,
        captcha,
        website: loginForm.website.trim(),
      },
    })

    if (Number(response.status ?? 200) !== 200 || !response.data) {
      throw new Error(response.msg || '登录失败，请检查账号信息后重试。')
    }

    setFeedback(loginFeedback, 'success', response.msg || '登录成功，正在跳转。')
    persistAuth(response.data)
    goAfterAuth()
  } catch (error) {
    const message = error instanceof Error ? error.message : '登录失败，请稍后重试。'
    setFeedback(loginFeedback, 'error', message)
  } finally {
    loginSubmitting.value = false
  }
}

async function submitRegister(): Promise<void> {
  await submitRegisterSafe()
}

async function handleRegisterCodeActionSafe(): Promise<void> {
  if (!isPhoneNumber(registerForm.phone.trim())) {
    setFeedback(registerFeedback, 'error', '请输入正确的 11 位手机号码。')
    return
  }

  if (!registerForm.securityCode.trim()) {
    setFeedback(registerFeedback, 'error', '请输入图片验证码。')
    return
  }

  if (!canSendRegisterCode.value) {
    await openBehaviorCaptchaModal(!behaviorCaptchaOriginalImage.value || behaviorCaptchaState.value === 'error')
    return
  }

  smsSending.value = true

  try {
    const response = await requestProtected<null>('/api/auth/register-code', {
      method: 'POST',
      body: {
        phone: registerForm.phone.trim(),
        type: 'register',
        captcha: registerForm.securityCode.trim(),
        captchaType: registerForm.captchaType.trim() || AUTH_CAPTCHA_TYPE,
        captchaVerification: registerForm.captchaVerification.trim(),
        website: registerForm.website.trim(),
      },
    })

    if (Number(response.status ?? 200) !== 200) {
      throw new Error(response.msg || '短信验证码发送失败，请稍后重试。')
    }

    registerSecurityPassed.value = true
    setFeedback(registerFeedback, 'success', response.msg || '短信验证码已发送，请填写短信验证码后提交注册。')
    startSmsCooldown(AUTH_SMS_COOLDOWN_SECONDS)
  } catch (error) {
    const message = normalizeRegisterSecurityMessage(error instanceof Error ? error.message : '短信验证码发送失败，请稍后重试。')
    clearRegisterSecurityState(message.includes('安全验证已失效'))
    setFeedback(registerFeedback, 'error', message)
    await loadSecurityCaptcha()
  } finally {
    smsSending.value = false
  }
}

async function submitRegisterSafe(): Promise<void> {
  if (!registerSecurityPassed.value) {
    setFeedback(registerFeedback, 'error', '请先完成安全验证并发送短信验证码。')
    return
  }

  if (!isPhoneNumber(registerForm.phone.trim())) {
    setFeedback(registerFeedback, 'error', '请输入正确的 11 位手机号码。')
    return
  }

  if (registerForm.password.trim().length < 6 || registerForm.password.trim().length > 32) {
    setFeedback(registerFeedback, 'error', '登录密码长度需在 6 到 32 位之间。')
    return
  }

  if (!registerForm.passwordConfirm.trim()) {
    setFeedback(registerFeedback, 'error', '请再次输入登录密码。')
    return
  }

  if (registerForm.password !== registerForm.passwordConfirm) {
    setFeedback(registerFeedback, 'error', '两次输入的登录密码不一致。')
    return
  }

  if (!registerForm.smsCode.trim()) {
    setFeedback(registerFeedback, 'error', '请输入短信验证码。')
    return
  }

  persistRegisterDraft()
  registerSubmitting.value = true

  try {
    const response = await requestProtected<null>('/api/auth/register', {
      method: 'POST',
      body: {
        account: registerForm.phone.trim(),
        captcha: registerForm.securityCode.trim(),
        smsCode: registerForm.smsCode.trim(),
        password: registerForm.password.trim(),
        spread: registerSpreadUid.value,
        website: registerForm.website.trim(),
      },
    })

    if (Number(response.status ?? 200) !== 200) {
      throw new Error(response.msg || '注册提交失败，请稍后重试。')
    }

    clearRegisterSecurityState(true)
    setFeedback(registerFeedback, 'success', response.msg || '注册提交成功，请使用刚刚填写的账号登录。')
    loginForm.account = registerForm.phone.trim()
    loginForm.password = registerForm.password.trim()
    authTab.value = 'login'
    setFeedback(loginFeedback, 'success', '注册成功，请输入图片验证码后登录。')
    await loadSecurityCaptcha()
  } catch (error) {
    const message = normalizeRegisterSecurityMessage(error instanceof Error ? error.message : '注册提交失败，请稍后重试。')
    await resetRegisterSecurityFlow(true)
    setFeedback(registerFeedback, 'error', message)
  } finally {
    registerSubmitting.value = false
  }
}

watch(promoSlides, (slides) => {
  if (!slides.length) {
    activePromoSlide.value = 0
    return
  }

  if (activePromoSlide.value >= slides.length) {
    activePromoSlide.value = 0
  }
}, { immediate: true })

watch(() => [
  registerForm.phone,
  registerForm.contact,
], () => {
  persistRegisterDraft()
})

watch(() => registerForm.phone, (value, previous) => {
  if (value.trim() !== String(previous ?? '').trim() && behaviorCaptchaVerified.value) {
    clearBehaviorCaptchaSession()
  }
})

watch(() => [
  registerForm.phone,
  registerForm.contact,
  registerForm.password,
], (values, previousValues) => {
  if (!previousValues) {
    return
  }

  const changed = values.some((value, index) => value.trim() !== String(previousValues[index] ?? '').trim())
  if (!changed) {
    return
  }

  if (registerSecurityPassed.value || behaviorCaptchaVerified.value || registerForm.captchaVerification.trim()) {
    clearRegisterSecurityState()
    registerForm.securityCode = ''
    setFeedback(registerFeedback, 'info', '注册信息已变更，请重新完成安全验证并发送短信验证码。')
    void loadSecurityCaptcha()
  }
})

watch(categoryMenuRoots, (roots) => {
  if (!roots.length) {
    activeCategoryRootId.value = null
    return
  }

  if (!roots.some((item) => item.id === activeCategoryRootId.value)) {
    activeCategoryRootId.value = roots[0].id
  }
}, { immediate: true })

onMounted(async () => {
  ensureAuthDeviceId()
  await loadHomePage(true)
  restoreRegisterDraft()
  await loadSecurityCaptcha()
  await loadBehaviorCaptchaChallengeFixed(true)
  registerFeedback.message = ''
  startPromoRotation()
  syncBehaviorCaptchaStageWidth()
  window.addEventListener('scroll', handleScroll, { passive: true })
  window.addEventListener('resize', syncBehaviorCaptchaStageWidth, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  window.removeEventListener('resize', syncBehaviorCaptchaStageWidth)
  clearBehaviorCaptchaReloadTimer()
  stopBehaviorCaptchaDrag()

  if (promoTimer) {
    clearInterval(promoTimer)
  }

  if (smsCooldownTimer.value) {
    clearInterval(smsCooldownTimer.value)
  }
})
</script>

<style scoped>
* {
  box-sizing: border-box;
}

button,
input,
select {
  font: inherit;
}

button {
  border: none;
  background: none;
  padding: 0;
}

.shein-home {
  min-height: 100vh;
  background: #fff;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  color: #222;
}

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
.policy-item em { color: #999; font-style: normal; font-size: 11px; }

.main-header {
  background: #fff;
  border-bottom: 1px solid #eee;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
}

.main-header.scrolled { box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08); }

.header-inner {
  max-width: 1446px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 12px 0;
}

.logo-button {
  cursor: pointer;
}

.logo {
  font-size: 28px;
  font-weight: 900;
  color: #111;
  letter-spacing: -2px;
  flex-shrink: 0;
  font-style: italic;
}

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
  box-shadow: 0 1px 3px rgba(201, 168, 76, 0.15);
  cursor: pointer;
}

.b2b-btn:hover {
  background: #fffdf5;
  box-shadow: 0 2px 8px rgba(201, 168, 76, 0.25);
  transform: translateY(-1px);
}

.b2b-icon { font-size: 18px; }
.b2b-text { display: flex; flex-direction: column; line-height: 1.2; }
.b2b-main { font-size: 12px; font-weight: 800; color: #111; letter-spacing: 0.3px; }
.b2b-sub { font-size: 9px; color: #777; font-weight: 500; }
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

.header-search {
  flex: 1;
  max-width: 520px;
}

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
  border-radius: 3px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  margin-left: 6px;
  letter-spacing: 0.3px;
  height: 38px;
}

.signin-btn:hover { background: #333; }

.category-nav {
  background: #fff;
  border-bottom: 2px solid #111;
  overflow: visible;
}

.category-nav::-webkit-scrollbar { display: none; }

.category-nav-inner {
  max-width: 1446px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  position: relative;
}

.all-category-entry {
  position: relative;
  flex-shrink: 0;
  margin-right: 10px;
}

.cat-item {
  padding: 12px 22px;
  font-size: 13px;
  font-weight: 500;
  color: #555;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
  white-space: nowrap;
  letter-spacing: 0.2px;
}

.cat-item:hover { color: #111; }
.cat-item.active { color: #111; border-bottom-color: #111; font-weight: 600; }
.cat-item-all {
  display: flex;
  align-items: center;
  gap: 8px;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  color: #fff;
  font-weight: 700;
  border-bottom: none !important;
  margin-bottom: 0;
  padding: 12px 18px;
  border-radius: 0 0 10px 10px;
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.08);
}
.cat-item-all:hover { color: #fff; background: linear-gradient(135deg, #111827 0%, #1f2937 100%); }
.cat-item-all-icon,
.cat-item-all-arrow {
  font-size: 12px;
  opacity: 0.9;
}
.cat-item-sale { color: #e60023; font-weight: 600; }
.nav-divider { width: 1px; height: 18px; background: #ddd; margin: 0 6px; flex-shrink: 0; }

.category-mega-menu {
  position: absolute;
  top: calc(100% + 2px);
  left: 0;
  width: min(1120px, calc(100vw - 32px));
  min-height: 500px;
  display: grid;
  grid-template-columns: 240px 1fr;
  background:
    radial-gradient(circle at top right, rgba(255, 244, 230, 0.85), transparent 34%),
    linear-gradient(180deg, #ffffff 0%, #fffdfa 100%);
  border: 1px solid rgba(148, 163, 184, 0.22);
  border-radius: 0 22px 22px 22px;
  box-shadow: 0 28px 70px rgba(15, 23, 42, 0.22);
  z-index: 40;
  overflow: hidden;
}

.category-root-list {
  padding: 14px 0 10px;
  background:
    radial-gradient(circle at top left, rgba(251, 191, 36, 0.12), transparent 30%),
    linear-gradient(180deg, #111827 0%, #172033 52%, #1f2937 100%);
  border-right: 1px solid rgba(255, 255, 255, 0.08);
  max-height: 560px;
  overflow-y: auto;
}

.category-root-list::-webkit-scrollbar,
.category-panel-content::-webkit-scrollbar {
  width: 10px;
}

.category-root-list::-webkit-scrollbar-thumb,
.category-panel-content::-webkit-scrollbar-thumb {
  background: rgba(148, 163, 184, 0.35);
  border-radius: 999px;
  border: 2px solid transparent;
  background-clip: padding-box;
}

.category-root-list-head {
  padding: 0 16px 14px;
  margin: 0 14px 10px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.category-root-list-kicker {
  display: block;
  margin-bottom: 6px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1.4px;
  text-transform: uppercase;
  color: #fbbf24;
}

.category-root-list-title {
  display: block;
  font-size: 18px;
  font-weight: 800;
  letter-spacing: 0.2px;
  color: #f8fafc;
}

.category-root-item {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 13px 16px;
  margin: 0 10px;
  border-radius: 14px;
  color: rgba(226, 232, 240, 0.94);
  cursor: pointer;
  text-align: left;
  transition: background 0.18s ease, transform 0.18s ease, color 0.18s ease, box-shadow 0.18s ease;
}

.category-root-item:hover,
.category-root-item.active {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.12), rgba(251, 191, 36, 0.1));
  color: #fff;
  transform: translateX(3px);
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.08);
}

.category-root-item.active {
  font-weight: 700;
}

.category-root-item-main {
  display: flex;
  flex: 1;
  min-width: 0;
  flex-direction: column;
  gap: 4px;
}

.category-root-name {
  min-width: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.category-root-meta {
  font-size: 10px;
  letter-spacing: 0.3px;
  color: rgba(148, 163, 184, 0.92);
}

.category-root-arrow {
  color: rgba(251, 191, 36, 0.92);
  font-size: 15px;
}

.category-panel-content {
  padding: 26px 28px 28px;
  overflow-y: auto;
  max-height: 560px;
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.96), rgba(248, 250, 252, 0.9));
}

.category-panel-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 22px;
}

.category-panel-header-main {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.category-panel-kicker {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.6px;
  text-transform: uppercase;
  color: #b45309;
}

.category-panel-title {
  font-size: 26px;
  font-weight: 800;
  color: #111827;
  cursor: pointer;
  line-height: 1.1;
}

.category-panel-subtitle {
  margin: 0;
  font-size: 13px;
  line-height: 1.6;
  color: #64748b;
}

.category-panel-all {
  flex-shrink: 0;
  padding: 10px 16px;
  border-radius: 999px;
  background: #111827;
  color: #fff;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.2px;
  cursor: pointer;
  box-shadow: 0 10px 24px rgba(15, 23, 42, 0.14);
}

.category-panel-groups {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px 18px;
}

.category-panel-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px 16px 14px;
  border: 1px solid #e5e7eb;
  border-radius: 18px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.95), rgba(248, 250, 252, 0.92));
  box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05);
}

.category-panel-group-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.category-panel-group-title {
  font-size: 15px;
  font-weight: 700;
  color: #111827;
  cursor: pointer;
  text-align: left;
  line-height: 1.35;
}

.category-panel-group-count {
  flex-shrink: 0;
  padding: 4px 8px;
  border-radius: 999px;
  background: #fff7ed;
  color: #b45309;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.2px;
}

.category-panel-links {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.category-panel-link {
  padding: 7px 10px;
  border-radius: 999px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  font-size: 12px;
  color: #475569;
  line-height: 1.2;
  cursor: pointer;
  transition: border-color 0.18s ease, background 0.18s ease, color 0.18s ease, transform 0.18s ease;
}

.category-panel-all:hover {
  background: #e60023;
}

.category-panel-link:hover,
.category-panel-group-title:hover,
.category-panel-title:hover {
  color: #e60023;
}

.category-panel-link:hover {
  background: #fff1f2;
  border-color: #fecdd3;
  transform: translateY(-1px);
}

.cat-special,
.cat-distributor {
  color: #fff !important;
  border-radius: 3px;
  padding: 5px 14px;
  margin: 0 4px;
  font-size: 12px;
  font-weight: 600;
  border-bottom: none !important;
  letter-spacing: 0.3px;
}

.cat-special { background: #e60023; }
.cat-special:hover { background: #c5001e; }
.cat-distributor { background: #2a2a6a; }
.cat-distributor:hover { background: #1a1a50; }

.login-main {
  max-width: 1446px;
  margin: 0 auto;
  background: #fff;
  padding: 28px 0 52px;
}

.login-stage-inner {
  display: grid;
  grid-template-columns: minmax(0, 1.18fr) minmax(420px, 520px);
  gap: 30px;
  align-items: start;
}

.promo-panel,
.auth-shell {
  position: relative;
  overflow: hidden;
  border-radius: 34px;
  border: 1px solid rgba(226, 232, 240, 0.88);
  box-shadow: 0 28px 70px rgba(15, 23, 42, 0.1);
}

.promo-panel {
  display: grid;
  gap: 22px;
  padding: 24px;
  align-self: start;
  background:
    radial-gradient(circle at top left, rgba(251, 191, 36, 0.18), transparent 26%),
    radial-gradient(circle at bottom right, rgba(249, 115, 22, 0.18), transparent 24%),
    linear-gradient(145deg, #0f172a 0%, #14243c 52%, #2b1d0e 100%);
  color: #fff;
}

.promo-status-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.promo-status-badge,
.auth-kicker {
  display: inline-flex;
  align-items: center;
  padding: 8px 14px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.14);
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 1.6px;
  text-transform: uppercase;
}

.promo-status-copy {
  color: rgba(226, 232, 240, 0.78);
  font-size: 13px;
  line-height: 1.6;
}

.promo-carousel {
  position: relative;
  min-height: 560px;
  border-radius: 28px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.12);
  background: rgba(15, 23, 42, 0.3);
}

.promo-track {
  display: flex;
  height: 100%;
  transition: transform 0.35s ease;
}

.promo-slide {
  position: relative;
  flex: 0 0 100%;
  min-width: 100%;
  min-height: 560px;
  cursor: default;
}

.promo-slide-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.promo-slide-overlay {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(180deg, rgba(15, 23, 42, 0.16) 0%, rgba(15, 23, 42, 0.42) 36%, rgba(15, 23, 42, 0.82) 100%);
}

.promo-slide-content {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  gap: 18px;
  padding: 34px;
  z-index: 1;
}

.promo-slide-tag {
  width: fit-content;
  padding: 8px 14px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.16);
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 1.5px;
  text-transform: uppercase;
}

.promo-slide-title {
  margin: 0;
  max-width: 520px;
  font-size: 46px;
  line-height: 1.04;
  font-weight: 900;
  letter-spacing: -1.4px;
}

.promo-slide-summary {
  margin: 0;
  max-width: 560px;
  color: rgba(241, 245, 249, 0.9);
  font-size: 15px;
  line-height: 1.8;
}

.promo-slide-highlights {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.promo-highlight {
  padding: 8px 12px;
  border-radius: 999px;
  background: rgba(15, 23, 42, 0.28);
  border: 1px solid rgba(255, 255, 255, 0.14);
  color: #fff;
  font-size: 12px;
  font-weight: 700;
}

.promo-slide-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.promo-primary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 164px;
  height: 52px;
  padding: 0 22px;
  border-radius: 16px;
  background: linear-gradient(135deg, #fff 0%, #fff7ed 100%);
  color: #111827;
  font-size: 14px;
  font-weight: 800;
  box-shadow: 0 16px 30px rgba(15, 23, 42, 0.22);
  cursor: pointer;
  transition: transform 0.18s ease, box-shadow 0.18s ease;
}

.promo-primary:hover,
.primary-action:hover,
.secondary-action:hover,
.identity-pill:hover,
.promo-arrow:hover {
  transform: translateY(-1px);
}

.promo-stat {
  min-width: 128px;
  display: grid;
  gap: 4px;
  padding: 14px 16px;
  border-radius: 20px;
  background: rgba(15, 23, 42, 0.32);
  border: 1px solid rgba(255, 255, 255, 0.12);
  text-align: right;
}

.promo-stat strong {
  font-size: 28px;
  line-height: 1;
}

.promo-stat span {
  color: rgba(226, 232, 240, 0.78);
  font-size: 12px;
}

.promo-arrow {
  position: absolute;
  top: 50%;
  z-index: 2;
  width: 44px;
  height: 44px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 999px;
  background: rgba(15, 23, 42, 0.38);
  color: #fff;
  backdrop-filter: blur(10px);
  cursor: pointer;
  transition: transform 0.18s ease, background 0.18s ease;
}

.promo-arrow:hover {
  background: rgba(15, 23, 42, 0.58);
}

.promo-arrow-prev {
  left: 18px;
}

.promo-arrow-next {
  right: 18px;
}

.promo-dots {
  position: absolute;
  left: 34px;
  bottom: 26px;
  z-index: 2;
  display: flex;
  gap: 8px;
}

.promo-dot {
  width: 10px;
  height: 10px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.34);
  cursor: pointer;
  transition: width 0.18s ease, background 0.18s ease;
}

.promo-dot.active {
  width: 28px;
  background: #fff;
}

.promo-insights {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

.promo-insight-card {
  padding: 20px 20px 18px;
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.12);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.04);
}

.promo-insight-card.accent {
  background: linear-gradient(145deg, rgba(255, 237, 213, 0.16), rgba(251, 191, 36, 0.12));
}

.promo-insight-action {
  display: grid;
  gap: 10px;
  text-align: left;
  cursor: pointer;
  transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease, background 0.18s ease;
}

.promo-insight-action:hover {
  transform: translateY(-1px);
  border-color: rgba(251, 191, 36, 0.36);
  box-shadow: 0 16px 32px rgba(15, 23, 42, 0.16);
  background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(251, 191, 36, 0.1));
}

.promo-insight-label {
  display: block;
  color: rgba(226, 232, 240, 0.72);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.3px;
}

.promo-insight-card strong {
  display: block;
  margin-top: 10px;
  font-size: 30px;
  line-height: 1;
}

.promo-insight-card p {
  margin: 12px 0 0;
  color: rgba(241, 245, 249, 0.8);
  font-size: 13px;
  line-height: 1.7;
}

.promo-insight-action-link {
  display: inline-flex;
  align-items: center;
  width: fit-content;
  padding: 8px 12px;
  border-radius: 999px;
  background: rgba(255, 247, 237, 0.18);
  color: #fde68a;
  font-size: 12px;
  font-weight: 800;
}

.auth-shell {
  min-height: 760px;
  display: flex;
  flex-direction: column;
  background:
    radial-gradient(circle at top left, rgba(251, 191, 36, 0.16), transparent 24%),
    linear-gradient(180deg, #ffffff 0%, #fffaf4 100%);
}

.auth-tabs {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  padding: 12px 12px 0;
  gap: 8px;
}

.auth-tab {
  height: 52px;
  border-radius: 18px;
  font-size: 14px;
  font-weight: 800;
  color: #64748b;
}

.auth-tab.active {
  background: #111827;
  color: #fff;
  box-shadow: 0 14px 28px rgba(15, 23, 42, 0.16);
}

.auth-body {
  flex: 1;
  min-height: 684px;
  padding: 24px 28px 32px;
  display: grid;
  gap: 18px;
}

.auth-kicker {
  width: fit-content;
  color: #92400e;
  background: #fff7ed;
  border-color: rgba(251, 191, 36, 0.26);
}

.auth-header h2 {
  margin: 0;
  font-size: 30px;
  font-weight: 900;
  color: #0f172a;
  letter-spacing: -0.6px;
}

.auth-header p {
  margin: 10px 0 0;
  color: #64748b;
  line-height: 1.7;
}

.identity-switch {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 10px;
}

.identity-pill {
  display: grid;
  gap: 5px;
  padding: 14px 14px 13px;
  border-radius: 20px;
  background: #fff;
  border: 1px solid #e2e8f0;
  cursor: pointer;
  text-align: left;
  transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease;
}

.identity-pill strong {
  color: #0f172a;
  font-size: 13px;
  font-weight: 800;
}

.identity-pill span {
  color: #64748b;
  font-size: 12px;
  line-height: 1.5;
}

.identity-pill.active {
  border-color: rgba(249, 115, 22, 0.35);
  background: linear-gradient(180deg, #fff7ed 0%, #ffffff 100%);
  box-shadow: 0 14px 28px rgba(249, 115, 22, 0.12);
}

.auth-form {
  display: grid;
  gap: 18px;
}

.bot-trap-input {
  position: absolute;
  left: -9999px;
  width: 1px;
  height: 1px;
  opacity: 0;
  pointer-events: none;
}

.field,
.field-grid {
  display: grid;
  gap: 8px;
}

.two-columns {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.field-label {
  font-size: 13px;
  font-weight: 700;
  color: #334155;
}

.field input,
.field select {
  width: 100%;
  height: 52px;
  padding: 0 16px;
  border-radius: 16px;
  border: 1px solid #dbe4ee;
  background: #fff;
  color: #0f172a;
  outline: none;
  transition: border-color 0.18s ease, box-shadow 0.18s ease, transform 0.18s ease;
}

.field input:focus,
.field select:focus {
  border-color: #fb923c;
  box-shadow: 0 0 0 4px rgba(251, 146, 60, 0.12);
}

.auth-note {
  display: grid;
  gap: 6px;
  padding: 16px 18px;
  border-radius: 18px;
  background: linear-gradient(180deg, #fff7ed 0%, #ffffff 100%);
  border: 1px solid #fed7aa;
}

.auth-note strong {
  color: #9a3412;
  font-size: 13px;
}

.auth-note span {
  color: #9a3412;
  font-size: 12px;
  line-height: 1.7;
}

.register-login-note {
  height: 100%;
  align-content: start;
}

.behavior-captcha-status {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 12px;
  align-items: center;
  padding: 14px 16px;
  border-radius: 18px;
  border: 1px solid #fed7aa;
  background: linear-gradient(180deg, #fff7ed 0%, #ffffff 100%);
}

.behavior-captcha-status.verified {
  border-color: rgba(22, 163, 74, 0.22);
  background: linear-gradient(180deg, #f0fdf4 0%, #ffffff 100%);
}

.behavior-captcha-status-copy {
  display: grid;
  gap: 6px;
}

.behavior-captcha-status-copy p {
  margin: 0;
  color: #7c2d12;
  font-size: 12px;
  line-height: 1.7;
}

.behavior-captcha-status.verified .behavior-captcha-status-copy p {
  color: #166534;
}

.behavior-captcha-card {
  display: grid;
  gap: 14px;
  padding: 18px;
  border-radius: 22px;
  border: 1px solid #fed7aa;
  background: linear-gradient(180deg, #fff7ed 0%, #ffffff 100%);
}

.behavior-captcha-modal-card {
  position: fixed;
  inset: 50% auto auto 50%;
  width: min(520px, calc(100vw - 32px));
  z-index: 180;
  transform: translate(-50%, -50%);
  box-shadow:
    0 32px 80px rgba(15, 23, 42, 0.24),
    0 0 0 100vmax rgba(15, 23, 42, 0.42);
}

.behavior-captcha-card.verified {
  border-color: rgba(22, 163, 74, 0.22);
  background: linear-gradient(180deg, #f0fdf4 0%, #ffffff 100%);
}

.behavior-captcha-head {
  display: flex;
  align-items: flex-start;
  position: relative;
  gap: 12px;
  padding-right: 52px;
}

.behavior-captcha-copy {
  display: grid;
  gap: 6px;
  flex: 0 1 270px;
  min-width: 0;
}

.behavior-captcha-copy > .field-label {
  display: none;
}

.behavior-captcha-modal-title {
  color: #111827;
  font-size: 15px;
  font-weight: 800;
  line-height: 1.2;
}

.behavior-captcha-copy p {
  margin: 0;
  color: #7c2d12;
  font-size: 12px;
  line-height: 1.7;
}

.behavior-captcha-close {
  position: absolute;
  top: 0;
  right: 0;
  width: 38px;
  height: 38px;
  border-radius: 999px;
  border: 1px solid #e2e8f0;
  background: rgba(255, 255, 255, 0.86);
  color: #334155;
  font-size: 20px;
  line-height: 1;
  cursor: pointer;
}

.behavior-captcha-close:disabled {
  opacity: 0.65;
  cursor: not-allowed;
}

.behavior-captcha-refresh {
  margin-left: 4px;
  flex-shrink: 0;
  min-width: 108px;
  height: 38px;
  padding: 0 14px;
  border-radius: 999px;
  border: 1px solid #fdba74;
  background: rgba(255, 255, 255, 0.86);
  color: #9a3412;
  font-size: 12px;
  font-weight: 700;
  cursor: pointer;
}

.behavior-captcha-refresh:disabled {
  opacity: 0.65;
  cursor: not-allowed;
}

.behavior-captcha-stage {
  position: relative;
  width: 100%;
  min-height: 188px;
  overflow: hidden;
  border-radius: 20px;
  background: #fff;
  border: 1px solid rgba(251, 146, 60, 0.18);
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.6);
}

.behavior-captcha-background,
.behavior-captcha-piece {
  display: block;
  width: 100%;
  user-select: none;
  -webkit-user-drag: none;
}

.behavior-captcha-piece {
  position: absolute;
  left: 0;
  top: 0;
  height: auto;
  max-height: 100%;
  max-width: none;
  pointer-events: none;
  filter: drop-shadow(0 10px 16px rgba(15, 23, 42, 0.16));
}

.behavior-captcha-overlay,
.behavior-captcha-empty {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 188px;
  padding: 0 18px;
  text-align: center;
  color: #9a3412;
  font-size: 13px;
  line-height: 1.7;
}

.behavior-captcha-overlay {
  position: absolute;
  inset: 0;
  background: rgba(15, 23, 42, 0.4);
  color: #fff;
  backdrop-filter: blur(2px);
}

.behavior-captcha-slider {
  display: grid;
  gap: 10px;
}

.behavior-captcha-track {
  position: relative;
  height: 54px;
  border-radius: 18px;
  overflow: hidden;
  border: 1px solid #fdba74;
  background: #fff;
}

.behavior-captcha-progress {
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 48px;
  border-radius: 18px;
  background: linear-gradient(90deg, rgba(251, 146, 60, 0.18) 0%, rgba(249, 115, 22, 0.3) 100%);
}

.behavior-captcha-thumb {
  position: absolute;
  left: 0;
  top: 50%;
  z-index: 2;
  width: 48px;
  height: 48px;
  border-radius: 16px;
  background: linear-gradient(135deg, #111827 0%, #7c2d12 100%);
  color: #fff;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  font-weight: 800;
  cursor: grab;
  box-shadow: 0 14px 24px rgba(124, 45, 18, 0.24);
}

.behavior-captcha-thumb:disabled {
  cursor: not-allowed;
  opacity: 0.72;
  box-shadow: none;
}

.behavior-captcha-track-text {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 18px 0 70px;
  color: #7c2d12;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.01em;
  pointer-events: none;
}

.behavior-captcha-slider.verified .behavior-captcha-track {
  border-color: rgba(22, 163, 74, 0.26);
}

.behavior-captcha-slider.verified .behavior-captcha-progress {
  width: 100% !important;
  background: linear-gradient(90deg, rgba(34, 197, 94, 0.16) 0%, rgba(22, 163, 74, 0.24) 100%);
}

.behavior-captcha-slider.verified .behavior-captcha-thumb {
  cursor: default;
  background: linear-gradient(135deg, #166534 0%, #16a34a 100%);
}

.behavior-captcha-slider.verified .behavior-captcha-track-text,
.behavior-captcha-card.verified .behavior-captcha-copy p {
  color: #166534;
}

.field-group {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 12px;
  align-items: end;
}

.auth-captcha-row {
  align-items: start;
}

.captcha-trigger {
  width: 148px;
  min-width: 148px;
  height: 52px;
  margin-top: 22px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  border-radius: 16px;
  border: 1px solid #dbe4ee;
  background: #fff8f1;
  color: #9a3412;
  cursor: pointer;
}

.captcha-image {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: cover;
}

.primary-action,
.secondary-action {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  height: 54px;
  padding: 0 22px;
  border-radius: 18px;
  font-size: 14px;
  font-weight: 800;
  transition: transform 0.18s ease, box-shadow 0.18s ease, opacity 0.18s ease;
}

.primary-action {
  width: 100%;
  background: linear-gradient(135deg, #111827 0%, #7c2d12 100%);
  color: #fff;
  box-shadow: 0 22px 36px rgba(124, 45, 18, 0.18);
}

.secondary-action {
  background: #fff;
  color: #111827;
  border: 1px solid #dbe4ee;
}

.secondary-action.compact {
  min-width: 144px;
  height: 52px;
  padding: 0 18px;
}

.primary-action:disabled,
.secondary-action:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  box-shadow: none;
}

.auth-feedback {
  padding: 14px 16px;
  border-radius: 16px;
  font-size: 13px;
  line-height: 1.6;
}

.auth-feedback.info {
  background: #eff6ff;
  color: #1d4ed8;
  border: 1px solid #bfdbfe;
}

.auth-feedback.success {
  background: #f0fdf4;
  color: #166534;
  border: 1px solid #bbf7d0;
}

.auth-feedback.error {
  background: #fff1f2;
  color: #be123c;
  border: 1px solid #fecdd3;
}

.auth-footnote {
  color: #64748b;
  font-size: 12px;
  line-height: 1.7;
}

@media (max-width: 1280px) {
  .policy-inner,
  .header-inner,
  .category-nav-inner,
  .login-stage-inner {
    width: calc(100% - 32px);
  }

  .login-stage-inner {
    grid-template-columns: minmax(0, 1fr) 460px;
  }

  .category-mega-menu {
    width: min(980px, calc(100vw - 24px));
    grid-template-columns: 220px 1fr;
  }

  .category-panel-groups {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .promo-slide-title {
    font-size: 38px;
  }

  .promo-insights {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 980px) {
  .policy-inner,
  .header-inner,
  .category-nav-inner,
  .login-stage-inner {
    width: calc(100% - 24px);
  }

  .policy-inner {
    justify-content: flex-start;
    overflow-x: auto;
  }

  .header-inner {
    flex-wrap: wrap;
    gap: 12px;
    padding: 14px 0;
  }

  .header-search,
  .search-bar {
    order: 3;
    width: 100%;
  }

  .category-nav {
    overflow-x: auto;
    scrollbar-width: none;
  }

  .category-nav::-webkit-scrollbar {
    display: none;
  }

  .category-mega-menu {
    display: none;
  }

  .login-stage-inner {
    grid-template-columns: 1fr;
  }

  .promo-panel,
  .auth-shell {
    border-radius: 28px;
    min-height: auto;
  }

  .promo-panel {
    padding: 28px;
  }

  .promo-carousel,
  .promo-slide {
    min-height: 480px;
  }

  .promo-slide-title {
    font-size: 32px;
  }

  .identity-switch,
  .two-columns,
  .captcha-grid,
  .promo-insights {
    grid-template-columns: 1fr;
  }

  .auth-body {
    min-height: auto;
  }
}

@media (max-width: 640px) {
  .header-actions {
    width: 100%;
    justify-content: space-between;
  }

  .b2b-btn {
    width: 100%;
    justify-content: space-between;
  }

  .auth-body {
    padding: 22px 20px 24px;
  }

  .promo-panel {
    padding: 16px;
  }

  .promo-status-row,
  .promo-slide-footer {
    grid-template-columns: 1fr;
    display: grid;
  }

  .behavior-captcha-head {
    padding-right: 48px;
  }

  .behavior-captcha-status {
    grid-template-columns: 1fr;
  }

  .behavior-captcha-refresh {
    width: fit-content;
    min-width: 108px;
  }

  .behavior-captcha-close {
    right: 0;
  }

  .promo-slide-content {
    padding: 24px;
  }

  .promo-slide-title {
    font-size: 28px;
  }

  .promo-dots {
    left: 24px;
    bottom: 20px;
  }

  .field-group {
    grid-template-columns: 1fr;
  }

  .secondary-action.compact {
    width: 100%;
  }

  .captcha-trigger {
    width: 100%;
    min-width: 0;
    margin-top: 0;
  }

  .advanced-head {
    flex-direction: column;
  }
}
</style>


