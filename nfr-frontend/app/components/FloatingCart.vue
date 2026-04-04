<template>
  <div class="floating-cart">
    <!-- Floating cart button -->
    <button class="cart-fab" @click="toggleCart" :class="{ 'has-items': totalItems > 0 }">
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
      </svg>
      <span class="cart-badge" v-if="totalItems > 0">{{ totalItems > 99 ? '99+' : totalItems }}</span>
    </button>

    <!-- Slide-out cart panel -->
    <Transition name="cart-slide">
      <div class="cart-panel" v-if="isOpen">
        <!-- Panel header -->
        <div class="panel-header">
          <div class="panel-title">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
              <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
            </svg>
            <span>Shopping Cart</span>
            <span class="panel-count">({{ totalItems }} items)</span>
          </div>
          <button class="panel-close" @click="closeCart">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>

        <!-- Free shipping progress -->
        <div class="shipping-progress" v-if="totalItems > 0">
          <div class="shipping-msg" v-if="needsForFreeShipping > 0">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#e60023" stroke-width="2">
              <rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/>
              <circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>
            </svg>
            Add <strong>${{ needsForFreeShipping.toFixed(2) }}</strong> more for <strong>FREE Shipping</strong>
          </div>
          <div class="shipping-msg free" v-else>
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#2e7d32" stroke-width="2">
              <path d="M5 12l5 5L20 7"/>
            </svg>
            You have unlocked <strong>FREE Shipping!</strong>
          </div>
          <div class="progress-bar">
            <div class="progress-fill" :style="{ width: freeShippingProgress + '%' }"></div>
          </div>
          <div class="progress-labels">
            <span>$0</span>
            <span>${{ freeShippingThreshold }}</span>
          </div>
        </div>

        <!-- Empty cart -->
        <div class="cart-empty" v-if="totalItems === 0">
          <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#ddd" stroke-width="1.5">
            <circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/>
            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
          </svg>
          <p>Your cart is empty</p>
          <button class="browse-btn" @click="closeCart">Browse Products</button>
        </div>

        <!-- Cart items -->
        <div class="cart-items" v-else>
          <div class="cart-item" v-for="item in items" :key="item.id">
            <img :src="item.img" :alt="item.name" class="item-img" />
            <div class="item-info">
              <p class="item-name">{{ item.name }}</p>
              <div class="item-price-row">
                <span class="item-price">${{ (item.price * item.qty).toFixed(2) }}</span>
                <span class="item-old" v-if="item.oldPrice">${{ (item.oldPrice * item.qty).toFixed(2) }}</span>
              </div>
              <div class="item-qty-row">
                <div class="qty-control">
                  <button class="qty-btn" @click="updateQty(item.id, item.qty - 1)">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="5" y1="12" x2="19" y2="12"/></svg>
                  </button>
                  <span class="qty-val">{{ item.qty }}</span>
                  <button class="qty-btn" @click="updateQty(item.id, item.qty + 1)">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                  </button>
                </div>
                <span class="item-moq" v-if="item.moq">MOQ: {{ item.moq }}</span>
              </div>
            </div>
            <button class="item-remove" @click="removeItem(item.id)">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>
        </div>

        <!-- Checkout summary -->
        <div class="cart-summary" v-if="totalItems > 0">
          <!-- Coupon -->
          <div class="promo-row">
            <input type="text" placeholder="Coupon code" class="promo-input" />
            <button class="promo-btn">Apply</button>
          </div>

          <!-- Summary lines -->
          <div class="summary-lines">
            <div class="summary-line">
              <span>Subtotal ({{ totalItems }} items)</span>
              <span>${{ subtotal.toFixed(2) }}</span>
            </div>
            <div class="summary-line">
              <span>Shipping</span>
              <span :class="{ free: subtotal >= freeShippingThreshold }">
                {{ subtotal >= freeShippingThreshold ? 'FREE' : '$7.99' }}
              </span>
            </div>
            <div class="summary-line discount" v-if="subtotal < 100">
              <span>Est. Tariff</span>
              <span class="discount-val">~${{ (subtotal * 0.05).toFixed(2) }}</span>
            </div>
            <div class="summary-total">
              <span>Est. Total</span>
              <span>${{ (subtotal + (subtotal >= freeShippingThreshold ? 0 : 7.99) + (subtotal < 100 ? subtotal * 0.05 : 0)).toFixed(2) }}</span>
            </div>
          </div>

          <!-- B2B tip -->
          <div class="b2b-tip">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#c9a84c" stroke-width="2">
              <path d="M2 20a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8l-7 5V8l-7 5V8l-7 5V8l-7 5V8l-7 5v12z"/>
            </svg>
            <span>Business buyer? <a href="/b2b" @click.prevent="closeCart">Switch to B2B</a> for wholesale prices</span>
          </div>

          <!-- Action buttons -->
          <div class="summary-actions">
            <button class="checkout-btn" @click="goCheckout">
              Proceed to Checkout
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
            </button>
            <button class="continue-btn" @click="closeCart">Continue Shopping</button>
          </div>

          <!-- Security note -->
          <div class="security-note">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="2">
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
            </svg>
            <span>Secure checkout · 30-day returns</span>
          </div>
        </div>
      </div>
    </Transition>

    <!-- Overlay -->
    <Transition name="fade">
      <div class="cart-overlay" v-if="isOpen" @click="closeCart"></div>
    </Transition>
  </div>
</template>

<script setup>
const { items, isOpen, totalItems, subtotal, freeShippingThreshold, freeShippingProgress, needsForFreeShipping, removeItem, updateQty, closeCart, toggleCart } = useCart()
const router = useRouter()
const goCheckout = () => {
  closeCart()
  router.push('/checkout')
}
</script>

<style scoped>
.floating-cart {
  position: fixed;
  bottom: 24px;
  right: 24px;
  z-index: 9999;
}

/* Floating button */
.cart-fab {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: #111;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  position: relative;
  box-shadow: 0 4px 20px rgba(0,0,0,0.2);
  transition: all 0.2s;
}
.cart-fab:hover { transform: scale(1.08); box-shadow: 0 6px 28px rgba(0,0,0,0.28); }
.cart-fab.has-items { background: #e60023; }
.cart-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  min-width: 20px;
  height: 20px;
  background: #111;
  color: #fff;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 800;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 5px;
  border: 2px solid #fff;
}
.cart-fab.has-items .cart-badge { background: #fff; color: #e60023; }

/* Slide-out panel */
.cart-panel {
  position: fixed;
  top: 0;
  right: 0;
  width: 400px;
  height: 100vh;
  background: #fff;
  box-shadow: -4px 0 32px rgba(0,0,0,0.12);
  display: flex;
  flex-direction: column;
  z-index: 10000;
  overflow: hidden;
}

/* Panel header */
.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 20px;
  border-bottom: 1px solid #eee;
  flex-shrink: 0;
}
.panel-title { display: flex; align-items: center; gap: 8px; font-size: 16px; font-weight: 800; color: #111; }
.panel-title svg { color: #111; }
.panel-count { font-size: 13px; color: #888; font-weight: 400; }
.panel-close {
  width: 32px; height: 32px; border-radius: 50%;
  border: 1px solid #eee; background: #fff;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; color: #888; transition: all 0.2s;
}
.panel-close:hover { background: #f5f5f5; color: #111; }

/* Shipping progress */
.shipping-progress {
  padding: 12px 20px;
  background: #fffbf5;
  border-bottom: 1px solid #f5e8c8;
  flex-shrink: 0;
}
.shipping-msg { display: flex; align-items: center; gap: 5px; font-size: 12px; color: #555; margin-bottom: 6px; }
.shipping-msg strong { color: #111; }
.shipping-msg.free { color: #2e7d32; }
.progress-bar { height: 4px; background: #f0e8c8; border-radius: 2px; overflow: hidden; margin-bottom: 4px; }
.progress-fill { height: 100%; background: #e60023; border-radius: 2px; transition: width 0.3s; }
.progress-labels { display: flex; justify-content: space-between; font-size: 10px; color: #aaa; }

/* Empty cart */
.cart-empty { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 12px; padding: 40px 20px; }
.cart-empty p { font-size: 14px; color: #aaa; }
.browse-btn { padding: 8px 20px; background: #111; color: #fff; border: none; border-radius: 4px; font-size: 13px; font-weight: 600; cursor: pointer; }

/* Cart items */
.cart-items { flex: 1; overflow-y: auto; padding: 8px 0; scrollbar-width: thin; scrollbar-color: #ddd transparent; }
.cart-items::-webkit-scrollbar { width: 4px; }
.cart-items::-webkit-scrollbar-thumb { background: #ddd; border-radius: 2px; }

.cart-item {
  display: flex; gap: 12px; padding: 12px 20px;
  border-bottom: 1px solid #f5f5f5; position: relative;
  transition: background 0.15s;
}
.cart-item:hover { background: #fafafa; }
.item-img { width: 70px; height: 70px; object-fit: cover; border-radius: 6px; border: 1px solid #f0f0f0; flex-shrink: 0; }
.item-info { flex: 1; min-width: 0; }
.item-name {
  font-size: 12px; color: #222; line-height: 1.4;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
  overflow: hidden; margin-bottom: 4px;
}
.item-price-row { display: flex; align-items: baseline; gap: 6px; margin-bottom: 6px; }
.item-price { font-size: 14px; font-weight: 800; color: #111; }
.item-old { font-size: 11px; color: #aaa; text-decoration: line-through; }
.item-qty-row { display: flex; align-items: center; justify-content: space-between; }
.qty-control { display: flex; align-items: center; border: 1px solid #e0e0e0; border-radius: 4px; overflow: hidden; }
.qty-btn {
  width: 26px; height: 26px; background: #fff; border: none;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  color: #555; transition: background 0.15s;
}
.qty-btn:hover { background: #f5f5f5; }
.qty-val { min-width: 30px; text-align: center; font-size: 13px; font-weight: 700; color: #111; }
.item-moq { font-size: 10px; color: #aaa; }
.item-remove {
  position: absolute; top: 10px; right: 16px;
  width: 24px; height: 24px; border-radius: 50%; border: none;
  background: #f5f5f5; display: flex; align-items: center; justify-content: center;
  cursor: pointer; color: #aaa; transition: all 0.15s;
}
.item-remove:hover { background: #ffe0e0; color: #e60023; }

/* Checkout summary */
.cart-summary { border-top: 2px solid #f0f0f0; padding: 16px 20px; flex-shrink: 0; background: #fff; }
.promo-row { display: flex; gap: 0; margin-bottom: 12px; }
.promo-input {
  flex: 1; padding: 8px 12px; border: 1px solid #ddd; border-right: none;
  border-radius: 4px 0 0 4px; font-size: 12px; outline: none; color: #333;
}
.promo-input::placeholder { color: #bbb; }
.promo-input:focus { border-color: #111; }
.promo-btn {
  padding: 8px 14px; background: #fff; border: 1px solid #111;
  border-radius: 0 4px 4px 0; font-size: 12px; font-weight: 700;
  color: #111; cursor: pointer;
}
.promo-btn:hover { background: #f5f5f5; }
.summary-lines { display: flex; flex-direction: column; gap: 6px; margin-bottom: 12px; }
.summary-line { display: flex; justify-content: space-between; font-size: 12px; color: #666; }
.summary-line .free { color: #2e7d32; font-weight: 700; }
.summary-line.discount .discount-val { color: #e60023; font-weight: 700; }
.summary-total {
  display: flex; justify-content: space-between; font-size: 15px; font-weight: 800;
  color: #111; padding-top: 8px; border-top: 1px solid #eee; margin-top: 4px;
}
.b2b-tip {
  display: flex; align-items: flex-start; gap: 6px;
  background: #fffef5; border: 1px solid #e8d89a; border-radius: 6px;
  padding: 8px 10px; font-size: 11px; color: #777; margin-bottom: 12px;
}
.b2b-tip svg { flex-shrink: 0; margin-top: 1px; }
.b2b-tip a { color: #c9a84c; font-weight: 700; text-decoration: none; }
.b2b-tip a:hover { text-decoration: underline; }
.summary-actions { display: flex; flex-direction: column; gap: 8px; }
.checkout-btn {
  display: flex; align-items: center; justify-content: center; gap: 8px;
  width: 100%; padding: 13px; background: #111; color: #fff; border: none;
  border-radius: 6px; font-size: 14px; font-weight: 800; cursor: pointer;
  transition: background 0.2s; letter-spacing: 0.3px;
}
.checkout-btn:hover { background: #333; }
.continue-btn {
  width: 100%; padding: 10px; background: #fff; color: #111;
  border: 1px solid #ddd; border-radius: 6px; font-size: 13px;
  font-weight: 600; cursor: pointer; transition: all 0.2s;
}
.continue-btn:hover { border-color: #111; }
.security-note { display: flex; align-items: center; justify-content: center; gap: 5px; margin-top: 10px; font-size: 11px; color: #aaa; }

/* Overlay */
.cart-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); z-index: 9999; }

/* Animations */
.cart-slide-enter-active, .cart-slide-leave-active { transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
.cart-slide-enter-from, .cart-slide-leave-to { transform: translateX(100%); }
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* Responsive */
@media (max-width: 480px) {
  .floating-cart { bottom: 16px; right: 16px; }
  .cart-fab { width: 50px; height: 50px; }
  .cart-panel { width: 100vw; }
}
</style>
