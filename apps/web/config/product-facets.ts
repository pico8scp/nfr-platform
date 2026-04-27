export interface ProductFacetPatternRule {
  label: string
  pattern: RegExp
}

export interface ProductFacetCandidateRule {
  key: string
  label: string
  pattern: RegExp
}

export const PRODUCT_SIZE_PATTERNS: ProductFacetPatternRule[] = [
  { label: '均码', pattern: /均码|free\s?size/i },
  { label: '小个子', pattern: /小个子/ },
  { label: '大码', pattern: /大码|加肥|加大/i },
  { label: '儿童', pattern: /童装|儿童|婴儿|婴幼儿/ },
  { label: 'XL', pattern: /(?:^|[^A-Z])XL(?:[^A-Z]|$)/i },
  { label: 'XXL', pattern: /(?:^|[^A-Z])(?:XXL|2XL)(?:[^A-Z]|$)/i },
  { label: '3XL+', pattern: /3XL|4XL|5XL|6XL/i },
] as const

export const PRODUCT_COLOR_PATTERNS: ProductFacetPatternRule[] = [
  { label: '黑色', pattern: /黑色|雅黑/ },
  { label: '白色', pattern: /白色|米白|乳白/ },
  { label: '灰色', pattern: /灰色|深灰|浅灰|银灰/ },
  { label: '蓝色', pattern: /蓝色|深蓝|浅蓝|天蓝|湖蓝|宝蓝|藏青/ },
  { label: '红色', pattern: /红色|大红|酒红|枣红|玫红/ },
  { label: '粉色', pattern: /粉色|浅粉|藕粉/ },
  { label: '绿色', pattern: /绿色|墨绿|军绿|橄榄绿/ },
  { label: '黄色', pattern: /黄色|姜黄/ },
  { label: '紫色', pattern: /紫色|香芋紫/ },
  { label: '橙色', pattern: /橙色/ },
  { label: '棕色', pattern: /棕色|咖色|咖啡色|焦糖色/ },
  { label: '卡其', pattern: /卡其/ },
  { label: '米色', pattern: /米色|杏色|裸色/ },
  { label: '金色', pattern: /金色/ },
  { label: '银色', pattern: /银色/ },
  { label: '透明', pattern: /透明/ },
  { label: '多色', pattern: /多色|混色|彩色/ },
] as const

export const PRODUCT_MATERIAL_PATTERNS: ProductFacetPatternRule[] = [
  { label: '纯棉', pattern: /纯棉/ },
  { label: '棉', pattern: /(?:^|[^纯])棉|棉质|棉麻/ },
  { label: '莫代尔', pattern: /莫代尔/ },
  { label: '蕾丝', pattern: /蕾丝/ },
  { label: '雪纺', pattern: /雪纺/ },
  { label: '牛仔', pattern: /牛仔/ },
  { label: '针织', pattern: /针织/ },
  { label: '冰丝', pattern: /冰丝/ },
  { label: '涤纶', pattern: /涤纶|聚酯纤维/ },
  { label: '真丝', pattern: /真丝|桑蚕丝/ },
  { label: '亚麻', pattern: /亚麻/ },
  { label: '皮革', pattern: /皮革|PU|皮质/i },
] as const

export const PRODUCT_FEATURE_PATTERNS: ProductFacetPatternRule[] = [
  { label: '新款', pattern: /新款|新品/ },
  { label: 'INS风', pattern: /ins风|INS/i },
  { label: '韩版', pattern: /韩版/ },
  { label: '性感', pattern: /性感/ },
  { label: '透气', pattern: /透气/ },
  { label: '抑菌', pattern: /抑菌|抗菌/ },
  { label: '高腰', pattern: /高腰/ },
  { label: '中腰', pattern: /中腰/ },
  { label: '宽松', pattern: /宽松/ },
  { label: '修身', pattern: /修身/ },
  { label: '显瘦', pattern: /显瘦/ },
  { label: '休闲', pattern: /休闲/ },
  { label: '工装', pattern: /工装/ },
  { label: '运动', pattern: /运动/ },
  { label: '百搭', pattern: /百搭/ },
  { label: '纯色', pattern: /纯色/ },
] as const

export const FACET_RESERVED_PRODUCT_FIELDS = new Set([
  'id',
  'store_name',
  'title',
  'image',
  'pic',
  'recommend_image',
  'price',
  'ot_price',
  'sales',
  'stock',
  'activity',
  'cate_id',
  'star',
  'unit_name',
  'label_list',
  'name',
])

export const FACET_CANDIDATE_RULES: ProductFacetCandidateRule[] = [
  { key: 'brand', label: '品牌', pattern: /(brand|品牌)/i },
  {
    key: 'size',
    label: '尺寸 / 规格',
    pattern: /(size|spec|specification|model|capacity|volume|weight|length|width|height|尺寸|尺码|规格|型号|容量|净含量|重量|长宽高)/i,
  },
  { key: 'color', label: '颜色', pattern: /(color|colour|颜色|色系)/i },
  {
    key: 'material',
    label: '材质',
    pattern: /(material|fabric|texture|composition|材质|面料|成分|组成)/i,
  },
  {
    key: 'pattern',
    label: '图案 / 主题',
    pattern: /(pattern|theme|print|图案|主题|印花|花型)/i,
  },
  {
    key: 'style',
    label: '风格 / 场景',
    pattern: /(style|scene|occasion|风格|场景|适用|用途)/i,
  },
  {
    key: 'feature',
    label: '功能 / 特性',
    pattern: /(feature|function|detail|elasticity|age|flavor|taste|neckline|sleeve|功能|特性|细节|弹力|年龄|口味|领型|袖长|适龄)/i,
  },
] as const

export const FALLBACK_FACET_LABELS: Record<string, string> = {
  size: '尺寸 / 规格',
  color: '颜色',
  material: '材质',
  feature: '功能 / 特性',
}

export const QUICK_LINK_EXCLUDED_FACET_KEYS = new Set(['rating', 'price_range', 'size'])

export const QUICK_LINK_EXCLUDED_LABEL_PATTERN = /(尺码|尺寸|规格|型号|容量|重量|长宽高)/
