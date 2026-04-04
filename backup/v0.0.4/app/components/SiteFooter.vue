<template>
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
            <!-- 分销商 -->
            <li class="footer-distributor-link">
              <a href="/distributor" class="distributor-link" @click.prevent>
                Become a Distributor — Earn Commission
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
        <p class="copyright">&copy; 2026 NFR Platform. All rights reserved.</p>
        <p class="footer-note">NFR — Your gateway to global trade. B2B Wholesale &amp; B2C Retail.</p>
      </div>
    </div>
  </footer>
</template>

<style scoped>
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
  .footer-grid { grid-template-columns: repeat(3, 1fr); }
}
@media (max-width: 900px) {
  .footer-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 600px) {
  .footer-inner { padding: 24px 0 16px; }
  .footer-grid { grid-template-columns: 1fr; gap: 20px; padding: 0 12px; }
  .footer-heading { font-size: 12px; margin-bottom: 10px; }
  .footer-links { gap: 6px; }
  .footer-links a { font-size: 11px; }
  .footer-bottom { padding: 12px 12px 0; }
  .copyright, .footer-note { font-size: 10px; }
}
</style>
