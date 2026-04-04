<template>
  <footer class="site-footer">
    <div class="container">
      <div class="footer-content">
        <!-- 关于我们 -->
        <div class="footer-section">
          <h4>关于我们</h4>
          <ul>
            <li><a href="#">关于我们</a></li>
            <li><a href="#">时尚博主</a></li>
            <li><a href="#">社会责任</a></li>
          </ul>
        </div>

        <!-- 客户服务 -->
        <div class="footer-section">
          <h4>客户服务</h4>
          <ul>
            <li><a href="#">常见问题</a></li>
            <li><a href="#">物流信息</a></li>
            <li><a href="#">退货流程</a></li>
            <li><a href="#">联系我们</a></li>
          </ul>
        </div>

        <!-- 支付方式 -->
        <div class="footer-section">
          <h4>支付方式</h4>
          <div class="payment-icons">
            <span>💳 Visa</span>
            <span>💳 Mastercard</span>
            <span>💳 PayPal</span>
            <span>🏦 Stripe</span>
          </div>
        </div>

        <!-- 社交媒体 -->
        <div class="footer-section">
          <h4>关注我们</h4>
          <div class="social-links">
            <a href="#" title="Facebook">📘</a>
            <a href="#" title="Instagram">📷</a>
            <a href="#" title="Twitter">🐦</a>
            <a href="#" title="TikTok">🎵</a>
          </div>
        </div>
      </div>

      <!-- 订阅 -->
      <div class="footer-subscribe">
        <p>订阅NFR电子报，抢先了解新品速递、热卖品补货及优惠资讯！</p>
        <div class="subscribe-form">
          <input type="email" placeholder="Enter your email" />
          <button class="btn-primary">订阅</button>
        </div>
      </div>

      <!-- 底部版权 -->
      <div class="footer-bottom">
        <p>©2024-2026 NFR All Rights Reserved</p>
        <div class="footer-links">
          <a href="#">隐私政策</a>
          <a href="#">使用条款</a>
          <a href="#">知识产权</a>
        </div>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.site-footer {
  background: #1a1a1a;
  color: #fff;
  padding: 60px 0 30px;
  margin-top: auto;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 40px;
  margin-bottom: 40px;
}

.footer-section h4 {
  font-size: var(--font-size-lg);
  margin-bottom: 20px;
  color: #fff;
}

.footer-section ul {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.footer-section ul li a {
  color: #999;
  font-size: var(--font-size-sm);
}

.footer-section ul li a:hover {
  color: var(--color-primary);
}

.payment-icons {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  color: #999;
  font-size: var(--font-size-sm);
}

.social-links {
  display: flex;
  gap: 16px;
}

.social-links a {
  font-size: 24px;
  opacity: 0.7;
  transition: var(--transition);
}

.social-links a:hover {
  opacity: 1;
}

.footer-subscribe {
  padding: 30px 0;
  border-top: 1px solid #333;
  border-bottom: 1px solid #333;
  text-align: center;
}

.footer-subscribe p {
  color: #999;
  margin-bottom: 16px;
}

.subscribe-form {
  display: flex;
  justify-content: center;
  gap: 0;
  max-width: 500px;
  margin: 0 auto;
}

.subscribe-form input {
  flex: 1;
  padding: 12px 16px;
  border: 1px solid #333;
  background: #2a2a2a;
  color: #fff;
  border-radius: 4px 0 0 4px;
}

.subscribe-form .btn-primary {
  border-radius: 0 4px 4px 0;
}

.footer-bottom {
  padding-top: 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: #666;
  font-size: var(--font-size-sm);
}

.footer-links {
  display: flex;
  gap: 20px;
}

.footer-links a {
  color: #666;
}

.footer-links a:hover {
  color: var(--color-primary);
}
</style>
