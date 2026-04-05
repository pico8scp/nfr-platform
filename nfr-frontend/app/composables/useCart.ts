// Cart composable
import { ref } from 'vue'
import { cartApi } from '~/utils/api'

const items = ref<any[]>([])
const total = ref(0)
const open = ref(false)

export function useCart() {
  async function loadCart() {
    const token = localStorage.getItem('token')
    if (!token) return
    try {
      const cart = await cartApi.get(token)
      items.value = cart.items
      total.value = cart.total
    } catch {
      // ignore
    }
  }

  async function addItem(productId: number, variantId?: number, quantity = 1) {
    const token = localStorage.getItem('token')
    if (!token) throw new Error('Please login first')
    const item = await cartApi.addItem({ product_id: productId, variant_id: variantId, quantity }, token)
    await loadCart()
    return item
  }

  async function removeItem(itemId: number) {
    const token = localStorage.getItem('token')
    if (!token) return
    await cartApi.removeItem(itemId, token)
    await loadCart()
  }

  function openCart() {
    open.value = true
    loadCart()
  }

  function getTotalItems() {
    return items.value.reduce((s, i) => s + i.quantity, 0)
  }

  return {
    items,
    total,
    open,
    loadCart,
    addItem,
    removeItem,
    openCart,
    getTotalItems,
  }
}
