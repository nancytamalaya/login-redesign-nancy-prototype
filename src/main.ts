import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { install, AcTooltip } from '@alayacare/alaya-design-system/dist/system/lib'

import '@alayacare/alaya-design-system/dist/system/icons/phosphor/icons.css'
import '@alayacare/alaya-design-system/dist/system/style.css'
import '@alayacare/alaya-design-system/dist/system/theme.css'
import '@alayacare/alaya-design-system/dist/system/system.utils.css'
import './assets/base.css'

import App from './App.vue'
import router from './router'

async function prepareApp() {
  const { worker } = await import('./mocks/browser')
  await worker.start({
    onUnhandledRequest: 'bypass',
    serviceWorker: {
      url: `${import.meta.env.BASE_URL}mockServiceWorker.js`,
    },
  })

  const app = createApp(App)

  install(app)
  app.directive('tooltip', AcTooltip)
  app.use(createPinia())
  app.use(router)

  app.mount('#app')
}

prepareApp()
