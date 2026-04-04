// 全局购物车状态管理
export const useCart = () => {
  const items = useState('cartItems', () => [
    {
      id: 1,
      name: 'Women Boho Floral Maxi Dress',
      img: 'https://picsum.photos/seed/cart1/120/120',
      price: 18.99,
      oldPrice: 39.90,
      qty: 2,
      moq: 20,
    },
    {
      id: 2,
      name: 'TWS Bluetooth Earbuds ANC 5.3',
      img: 'https://picsum.photos/seed/cart2/120/120',
      price: 28.99,
      oldPrice: 59.99,
      qty: 1,
      moq: 10,
    },
  ])

  const isOpen = useState('cartOpen', () => false)

  const totalItems = computed(() => items.value.reduce((sum: number, i: any) => sum + i.qty, 0))
  const subtotal = computed(() => items.value.reduce((sum: number, i: any) => sum + i.price * i.qty, 0))
  const freeShippingThreshold = 49
  const freeShippingProgress = computed(() => Math.min((subtotal.value / freeShippingThreshold) * 100, 100))
  const needsForFreeShipping = computed(() => Math.max(freeShippingThreshold - subtotal.value, 0))

  const addItem = (product: any) => {
    const existing = items.value.find((i: any) => i.id === product.id)
    if (existing) {
      existing.qty++
    } else {
      items.value.push({ ...product, qty: 1 })
    }
    isOpen.value = true
  }

  const removeItem = (id: number) => {
    items.value = items.value.filter((i: any) => i.id !== id)
  }

  const updateQty = (id: number, qty: number) => {
    if (qty <= 0) {
      removeItem(id)
      return
    }
    const item = items.value.find((i: any) => i.id === id)
    if (item) item.qty = qty
  }

  const openCart = () => { isOpen.value = true }
  const closeCart = () => { isOpen.value = false }
  const toggleCart = () => { isOpen.value = !isOpen.value }

  return {
    items,
    isOpen,
    totalItems,
    subtotal,
    freeShippingThreshold,
    freeShippingProgress,
    needsForFreeShipping,
    addItem,
    removeItem,
    updateQty,
    openCart,
    closeCart,
    toggleCart,
  }
}
