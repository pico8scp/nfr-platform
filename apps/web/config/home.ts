export interface HomeFallbackProduct {
  id: number
  name: string
  image: string
  price: string
  originalPrice: string
  sales: number
  stock: number
  badge?: string
}

export const HOME_FALLBACK_IMAGES = {
  banner: 'https://picsum.photos/seed/nfr-home-banner/900/400',
  product: 'https://picsum.photos/seed/nfr-home-product/480/640',
  category: 'https://picsum.photos/seed/nfr-home-category/200/200',
  heroSide: [
    'https://picsum.photos/seed/nfr-act/295/135',
    'https://picsum.photos/seed/nfr-dis/295/135',
    'https://picsum.photos/seed/nfr-hl1/295/135',
    'https://picsum.photos/seed/nfr-upg/295/135',
    'https://picsum.photos/seed/nfr-act2/295/135',
    'https://picsum.photos/seed/nfr-hr1/295/135',
  ],
} as const

export const HOME_DISPLAY_LIMITS = {
  navItems: 4,
  banners: 3,
  shortcutItems: 6,
  categoryEntries: 8,
  featuredProducts: 4,
  dealProducts: 5,
  seckillProducts: 4,
  flashSaleProducts: 3,
  bestSellerProducts: 5,
  groupBuyProducts: 3,
  hotSellerProducts: 12,
  categoryPanelGroups: 18,
  categoryPanelChildren: 10,
} as const

export function isHomeFallbackImage(input: string | undefined): boolean {
  if (!input) {
    return true
  }

  const normalized = input.trim().toLowerCase()
  if (!normalized) {
    return true
  }

  return normalized.includes('picsum.photos/seed/nfr-')
    || normalized.includes('picsum.photos/seed/crmeb-home-')
    || normalized.includes('picsum.photos/seed/crmeb-product-')
}

export function resolveHomeFallbackProductImage(seed: string | number): string {
  return `https://picsum.photos/seed/crmeb-product-${seed}/480/640`
}

export const HOME_DEFAULT_FEATURED_PRODUCTS: HomeFallbackProduct[] = [
  { id: 1001, name: '轻奢通勤女包', image: 'https://picsum.photos/seed/crmeb-home-1001/480/640', price: '239.00', originalPrice: '329.00', sales: 128, stock: 56, badge: '新品' },
  { id: 1002, name: '蓝牙降噪耳机', image: 'https://picsum.photos/seed/crmeb-home-1002/480/640', price: '169.00', originalPrice: '229.00', sales: 256, stock: 87, badge: '热卖' },
  { id: 1003, name: '家用空气炸锅', image: 'https://picsum.photos/seed/crmeb-home-1003/480/640', price: '299.00', originalPrice: '399.00', sales: 98, stock: 33, badge: '推荐' },
  { id: 1004, name: '舒适跑鞋', image: 'https://picsum.photos/seed/crmeb-home-1004/480/640', price: '219.00', originalPrice: '289.00', sales: 173, stock: 61, badge: '精选' },
] as const

export const HOME_DEFAULT_DEAL_PRODUCTS: HomeFallbackProduct[] = [
  { id: 2001, name: '保温随行杯', image: 'https://picsum.photos/seed/crmeb-home-2001/480/640', price: '39.90', originalPrice: '59.90', sales: 665, stock: 240 },
  { id: 2002, name: '便携折叠雨伞', image: 'https://picsum.photos/seed/crmeb-home-2002/480/640', price: '29.90', originalPrice: '49.90', sales: 452, stock: 188 },
  { id: 2003, name: '氛围桌面夜灯', image: 'https://picsum.photos/seed/crmeb-home-2003/480/640', price: '49.00', originalPrice: '79.00', sales: 339, stock: 126 },
  { id: 2004, name: '简约家居收纳盒', image: 'https://picsum.photos/seed/crmeb-home-2004/480/640', price: '24.90', originalPrice: '39.90', sales: 581, stock: 310 },
  { id: 2005, name: '便携充电宝', image: 'https://picsum.photos/seed/crmeb-home-2005/480/640', price: '69.00', originalPrice: '99.00', sales: 721, stock: 144 },
] as const

export const HOME_DEFAULT_SECKILL_PRODUCTS: HomeFallbackProduct[] = [
  { id: 3001, name: '智能手表', image: 'https://picsum.photos/seed/crmeb-home-3001/480/640', price: '159.00', originalPrice: '229.00', sales: 189, stock: 42 },
  { id: 3002, name: '护肤礼盒', image: 'https://picsum.photos/seed/crmeb-home-3002/480/640', price: '89.00', originalPrice: '139.00', sales: 243, stock: 68 },
  { id: 3003, name: '筋膜枪', image: 'https://picsum.photos/seed/crmeb-home-3003/480/640', price: '119.00', originalPrice: '179.00', sales: 155, stock: 57 },
  { id: 3004, name: '儿童积木套装', image: 'https://picsum.photos/seed/crmeb-home-3004/480/640', price: '79.00', originalPrice: '129.00', sales: 276, stock: 81 },
] as const
