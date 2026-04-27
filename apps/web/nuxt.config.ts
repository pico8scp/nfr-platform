import { CRMEB_API_BASE, CRMEB_HOME_PAGE_ID, CRMEB_HOME_RECOMMENDED_CATEGORY_IDS, CRMEB_PROXY_BASE, CRMEB_PUBLIC_ORIGIN } from './config/crmeb-api'

export default defineNuxtConfig({
  compatibilityDate: '2024-04-03',
  devtools: { enabled: false },
  ssr: false,
  devServer: { port: 3001 },
  experimental: {
    appManifest: false,
  },

  app: {
    head: {
      title: 'NFR Mall Frontend',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: 'NFR 跨境批发与零售一体化前台商城' }
      ]
    }
  },

  runtimeConfig: {
    apiBase: process.env.NUXT_API_BASE || CRMEB_API_BASE,
    public: {
      apiBase: process.env.NUXT_PUBLIC_API_BASE || CRMEB_PROXY_BASE,
      crmebOrigin: process.env.NUXT_PUBLIC_CRMEB_ORIGIN || CRMEB_PUBLIC_ORIGIN,
      homePageId: process.env.NUXT_PUBLIC_CRMEB_HOME_PAGE_ID || String(CRMEB_HOME_PAGE_ID),
      recommendedCategoryIds: process.env.NUXT_PUBLIC_HOME_RECOMMENDED_CATEGORY_IDS || CRMEB_HOME_RECOMMENDED_CATEGORY_IDS.join(','),
    }
  },

  css: ['~/assets/css/main.css']
})
