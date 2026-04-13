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

/**
 * MSW runs after the UI mounts so a slow/blocked service worker never leaves a blank #app.
 * The mock chunk loads asynchronously and never blocks first paint.
 */
function startMockWorker(): void {
  void import('./mocks/browser')
    .then(({ worker }) =>
      worker.start({
        onUnhandledRequest: 'bypass',
        serviceWorker: {
          url: `${import.meta.env.BASE_URL}mockServiceWorker.js`,
        },
      }),
    )
    .catch((err: unknown) => {
      console.warn('[MSW] Mock worker failed to start; continuing without mocks.', err)
    })
}

const root = document.getElementById('app')
if (!root) {
  throw new Error('Missing #app element')
}

const app = createApp(App)

try {
  install(app)
  app.directive('tooltip', AcTooltip)
  app.use(createPinia())
  app.use(router)
  app.mount('#app')
} catch (err) {
  const message = err instanceof Error ? err.stack ?? err.message : String(err)
  console.error('[bootstrap]', err)
  root.innerHTML = `<div style="padding:24px;font-family:system-ui,sans-serif;max-width:48rem">
    <h1 style="font-size:1.125rem;margin:0 0 8px">Prototype failed to start</h1>
    <p style="margin:0 0 12px;color:#444">Copy this for support or check the browser console.</p>
    <pre style="overflow:auto;background:#f5f5f5;padding:12px;border-radius:6px;font-size:12px;white-space:pre-wrap">${message}</pre>
  </div>`
  throw err
}

queueMicrotask(() => {
  startMockWorker()
})
