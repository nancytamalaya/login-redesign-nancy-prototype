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

const MSW_START_TIMEOUT_MS = 8000

async function prepareApp() {
  try {
    const { worker } = await import('./mocks/browser')
    await Promise.race([
      worker.start({
        onUnhandledRequest: 'bypass',
        serviceWorker: {
          url: `${import.meta.env.BASE_URL}mockServiceWorker.js`,
        },
      }),
      new Promise<never>((_, reject) => {
        setTimeout(() => reject(new Error('MSW start timed out')), MSW_START_TIMEOUT_MS)
      }),
    ])
  } catch (err) {
    console.warn(
      '[MSW] Mock worker did not start (blocked, unsupported, or slow). The UI will still load.',
      err,
    )
  }

  const app = createApp(App)

  install(app)
  app.directive('tooltip', AcTooltip)
  app.use(createPinia())
  app.use(router)

  app.mount('#app')
}

void prepareApp()
