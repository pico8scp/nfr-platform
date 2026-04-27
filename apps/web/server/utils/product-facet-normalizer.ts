import {
  FACET_CANDIDATE_RULES,
  FACET_RESERVED_PRODUCT_FIELDS,
  FALLBACK_FACET_LABELS,
  PRODUCT_COLOR_PATTERNS,
  PRODUCT_FEATURE_PATTERNS,
  PRODUCT_MATERIAL_PATTERNS,
  PRODUCT_SIZE_PATTERNS,
  QUICK_LINK_EXCLUDED_FACET_KEYS,
  QUICK_LINK_EXCLUDED_LABEL_PATTERN,
} from '../../config/product-facets'

export interface CatalogFacetPayload {
  facetValues: Record<string, string[]>
  facetLabels: Record<string, string>
}

export interface FacetGroupLike {
  key: string
  label: string
}

function isRecord(input: unknown): input is Record<string, unknown> {
  return Boolean(input) && typeof input === 'object' && !Array.isArray(input)
}

function normalizeArray<T>(input: unknown): T[] {
  if (Array.isArray(input)) {
    return input as T[]
  }

  if (input && typeof input === 'object') {
    const record = input as Record<string, unknown>

    if (Array.isArray(record.list)) {
      return record.list as T[]
    }

    if (record.data && typeof record.data === 'object') {
      const nested = record.data as Record<string, unknown>
      if (Array.isArray(nested.list)) {
        return nested.list as T[]
      }
    }

    if (Array.isArray(record.data)) {
      return record.data as T[]
    }
  }

  return []
}

function toText(value: unknown, fallback = ''): string {
  if (typeof value === 'string') {
    return value.trim() || fallback
  }

  if (typeof value === 'number') {
    return String(value)
  }

  return fallback
}

function collectPatternLabels(source: string, patterns: ReadonlyArray<{ label: string; pattern: RegExp }>): string[] {
  const matched: string[] = []

  for (const entry of patterns) {
    if (entry.pattern.test(source)) {
      matched.push(entry.label)
    }
  }

  return matched
}

export function normalizeFacetToken(input: unknown): string {
  const text = toText(input)
    .replace(/[\r\n\t]+/g, ' ')
    .replace(/\s{2,}/g, ' ')
    .trim()

  if (!text || text.length > 48) {
    return ''
  }

  if (/^(true|false|null|undefined)$/i.test(text)) {
    return ''
  }

  if (/^\d+$/.test(text)) {
    return ''
  }

  if (/^(n\/a|none|other|默认|暂无|不适用|其它|其他|未知|无)$/i.test(text)) {
    return ''
  }

  return text
}

function normalizeFacetLabel(input: unknown): string {
  const text = toText(input)
    .replace(/[：:]+$/g, '')
    .replace(/\s{2,}/g, ' ')
    .trim()

  if (!text || text.length > 24) {
    return ''
  }

  if (/^(参数|属性|规格|详情|商品参数)$/i.test(text)) {
    return ''
  }

  return text
}

function collectUnknownValues(input: unknown): string[] {
  if (input === null || input === undefined) {
    return []
  }

  if (Array.isArray(input)) {
    return input.flatMap((item) => collectUnknownValues(item))
  }

  if (typeof input === 'object') {
    const record = input as Record<string, unknown>
    const preferredKeys = ['label', 'label_name', 'name', 'value', 'text', 'title']
    const preferredValues = preferredKeys
      .map((key) => record[key])
      .flatMap((value) => collectUnknownValues(value))

    if (preferredValues.length) {
      return preferredValues
    }

    return Object.values(record).flatMap((value) => collectUnknownValues(value))
  }

  const normalized = normalizeFacetToken(input)
  if (!normalized) {
    return []
  }

  return normalized
    .split(/[|/,;，、]+/)
    .map((item) => item.trim())
    .filter((item) => item.length > 0 && item.length <= 32)
}

export function uniqueFacetValues(values: string[]): string[] {
  const unique: string[] = []
  const seen = new Set<string>()

  for (const value of values) {
    const normalized = normalizeFacetToken(value)
    if (!normalized) {
      continue
    }

    const key = normalized.toLowerCase()
    if (seen.has(key)) {
      continue
    }

    seen.add(key)
    unique.push(normalized)
  }

  return unique
}

function extractSemanticSizeValues(values: string[]): string[] {
  const matched: string[] = []
  const patterns = [
    /\b(?:XXXL|XXL|XL|XS|S|M|L|2XL|3XL|4XL|5XL|6XL)\b/gi,
    /均码|大码|小码|中码|加大码|特大码|儿童码|童码/g,
    /\b\d{2,3}\/\d{2,3}[A-Z]?\b/g,
    /\b(?:3[0-9]|4[0-9]|5[0-2])\b/g,
    /\d+(?:\.\d+)?\s?(?:cm|mm|m|ml|l|kg|g|寸|英寸|码)\b/gi,
  ]

  for (const rawValue of values) {
    const text = normalizeFacetToken(rawValue)
    if (!text) {
      continue
    }

    for (const pattern of patterns) {
      const result = text.match(pattern)
      if (result?.length) {
        matched.push(...result.map((item) => item.toUpperCase().replace(/\s+/g, '')))
      }
    }
  }

  return uniqueFacetValues(matched)
}

function extractSemanticColorValues(values: string[]): string[] {
  const matched: string[] = []

  for (const rawValue of values) {
    const text = normalizeFacetToken(rawValue)
    if (!text) {
      continue
    }

    matched.push(...collectPatternLabels(text, PRODUCT_COLOR_PATTERNS))
  }

  return uniqueFacetValues(matched)
}

function sanitizeFacetValuesByKey(key: string, values: string[]): string[] {
  if (key === 'size') {
    return extractSemanticSizeValues(values)
  }

  if (key === 'color') {
    return extractSemanticColorValues(values)
  }

  return uniqueFacetValues(values)
}

function appendFacetValues(
  store: Record<string, string[]>,
  labelStore: Record<string, string>,
  key: string,
  label: string,
  values: string[],
): void {
  const nextValues = sanitizeFacetValuesByKey(key, values)
  if (!nextValues.length) {
    return
  }

  labelStore[key] = label
  store[key] = uniqueFacetValues([...(store[key] ?? []), ...nextValues])
}

export function mergeFacetPayload(base: CatalogFacetPayload, incoming: CatalogFacetPayload): CatalogFacetPayload {
  const facetValues = { ...base.facetValues }
  const facetLabels = { ...base.facetLabels, ...incoming.facetLabels }

  for (const [key, values] of Object.entries(incoming.facetValues)) {
    facetValues[key] = uniqueFacetValues([...(facetValues[key] ?? []), ...values])
  }

  return {
    facetValues,
    facetLabels,
  }
}

function buildDynamicFacetKey(label: string): string {
  let hash = 0

  for (const char of label) {
    hash = ((hash << 5) - hash) + char.charCodeAt(0)
    hash |= 0
  }

  return `attr_${Math.abs(hash).toString(36)}`
}

function resolveFacetGroup(input: string): { key: string; label: string } | null {
  const normalizedLabel = normalizeFacetLabel(input)
  if (!normalizedLabel) {
    return null
  }

  const matchedRule = FACET_CANDIDATE_RULES.find((entry) => entry.pattern.test(normalizedLabel))
  if (!matchedRule) {
    return null
  }

  return {
    key: matchedRule.key,
    label: matchedRule.label,
  }
}

export function resolveFacetDisplayLabel(key: string, customLabel?: string): string {
  return customLabel
    || FACET_CANDIDATE_RULES.find((entry) => entry.key === key)?.label
    || FALLBACK_FACET_LABELS[key]
    || key
}

export function extractBaseFacetPayload(item: Record<string, unknown>, name: string): CatalogFacetPayload {
  const facetValues: Record<string, string[]> = {}
  const facetLabels: Record<string, string> = {}

  for (const [field, rawValue] of Object.entries(item)) {
    if (FACET_RESERVED_PRODUCT_FIELDS.has(field)) {
      continue
    }

    const rule = FACET_CANDIDATE_RULES.find((entry) => entry.pattern.test(field))
    if (!rule) {
      continue
    }

    appendFacetValues(facetValues, facetLabels, rule.key, rule.label, collectUnknownValues(rawValue))
  }

  appendFacetValues(facetValues, facetLabels, 'size', '尺寸 / 规格', collectPatternLabels(name, PRODUCT_SIZE_PATTERNS))
  appendFacetValues(facetValues, facetLabels, 'material', '材质', collectPatternLabels(name, PRODUCT_MATERIAL_PATTERNS))
  appendFacetValues(facetValues, facetLabels, 'feature', '功能 / 特性', collectPatternLabels(name, PRODUCT_FEATURE_PATTERNS))

  const labelValues = collectUnknownValues(item.label_list)
  if (labelValues.length) {
    appendFacetValues(facetValues, facetLabels, 'feature', '功能 / 特性', labelValues)
  }

  return {
    facetValues,
    facetLabels,
  }
}

function extractDetailRoot(input: unknown): Record<string, unknown> | null {
  if (!isRecord(input)) {
    return null
  }

  const candidateKeys = ['storeInfo', 'productInfo', 'product', 'info', 'goodsInfo', 'data']
  for (const key of candidateKeys) {
    if (isRecord(input[key])) {
      return input[key] as Record<string, unknown>
    }
  }

  return input
}

function collectDetailParamEntries(input: unknown): Array<{ label: string; values: string[] }> {
  return normalizeArray<Record<string, unknown>>(input)
    .map((item) => {
      const label = normalizeFacetLabel(
        item.key
          ?? item.name
          ?? item.title
          ?? item.param_name
          ?? item.label
          ?? item.attr_name,
      )

      if (!label) {
        return null
      }

      const values = collectUnknownValues(
        item.detail
          ?? item.content
          ?? item.param_value
          ?? item.text
          ?? item.val
          ?? item.attr_values
          ?? item.attr_value
          ?? item.value,
      )

      return values.length ? { label, values } : null
    })
    .filter((item): item is { label: string; values: string[] } => Boolean(item))
}

function collectDetailSpecEntries(input: unknown): Array<{ label: string; values: string[] }> {
  return normalizeArray<Record<string, unknown>>(input)
    .map((item) => {
      const label = normalizeFacetLabel(item.attr_name ?? item.name ?? item.title)
      if (!label) {
        return null
      }

      const values = collectUnknownValues(item.attr_values ?? item.values ?? item.value ?? item.detail)
      return values.length ? { label, values } : null
    })
    .filter((item): item is { label: string; values: string[] } => Boolean(item))
}

export function extractDetailFacetPayload(detailPayload: unknown): CatalogFacetPayload {
  const detailRoot = extractDetailRoot(detailPayload)
  if (!detailRoot) {
    return {
      facetValues: {},
      facetLabels: {},
    }
  }

  const detailRecord = isRecord(detailPayload) ? detailPayload : null
  const facetValues: Record<string, string[]> = {}
  const facetLabels: Record<string, string> = {}

  const paramEntries = collectDetailParamEntries(
    detailRecord?.params_list
      ?? detailRecord?.param
      ?? detailRecord?.productParams
      ?? detailRoot.params_list
      ?? detailRoot.param,
  )

  const specEntries = collectDetailSpecEntries(
    detailRecord?.productAttr
      ?? detailRecord?.attrs
      ?? detailRecord?.attr
      ?? detailRoot.attr
      ?? detailRoot.specs,
  )

  for (const entry of [...paramEntries, ...specEntries]) {
    const resolvedGroup = resolveFacetGroup(entry.label)
    appendFacetValues(
      facetValues,
      facetLabels,
      resolvedGroup?.key ?? buildDynamicFacetKey(entry.label),
      resolvedGroup?.label ?? entry.label,
      entry.values,
    )
  }

  return {
    facetValues,
    facetLabels,
  }
}

export function normalizeQuickLinkKeyword(baseKeyword: string, optionLabel: string): string {
  const keyword = toText(baseKeyword)
  const option = normalizeFacetToken(optionLabel)
  if (!option) {
    return ''
  }

  if (!keyword) {
    return option
  }

  const normalizedKeyword = keyword.replace(/\s+/g, '').toLowerCase()
  const normalizedOption = option.replace(/\s+/g, '').toLowerCase()
  if (!normalizedOption || normalizedKeyword.includes(normalizedOption)) {
    return ''
  }

  return `${keyword} ${option}`.trim()
}

export function shouldUseGroupForQuickLinks(group: FacetGroupLike): boolean {
  if (QUICK_LINK_EXCLUDED_FACET_KEYS.has(group.key)) {
    return false
  }

  return !QUICK_LINK_EXCLUDED_LABEL_PATTERN.test(group.label)
}
