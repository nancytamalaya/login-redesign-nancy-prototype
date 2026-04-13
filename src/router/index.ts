import { createRouter, createWebHashHistory } from 'vue-router'
import AlayaFlowStudioView from '../views/AlayaFlowStudioView.vue'
import TenantConfigBranchView from '../views/TenantConfigBranchView.vue'

/**
 * Hash history works on static hosts (e.g. GitHub Pages) without server rewrites.
 *
 * - AlayaFlow Studio (Voice Agents): http://localhost:5173/#/
 * - Tenant config (Figma 7519-44878): http://localhost:5173/#/tenant-config
 */
const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'studio',
      component: AlayaFlowStudioView,
    },
    {
      path: '/tenant-config',
      name: 'tenant-config',
      component: TenantConfigBranchView,
    },
  ],
})

export default router
