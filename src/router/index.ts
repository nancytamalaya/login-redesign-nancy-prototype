import { createRouter, createWebHashHistory } from 'vue-router'
import TenantConfigBranchView from '../views/TenantConfigBranchView.vue'

/**
 * Hash history works on static hosts (e.g. GitHub Pages) without server rewrites.
 *
 * Vacant Visit Scheduler (Figma branch config) lives at:
 * - http://localhost:5173/#/
 * - http://localhost:5173/#/tenant-config
 */
const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: TenantConfigBranchView,
    },
    {
      path: '/tenant-config',
      name: 'tenant-config',
      component: TenantConfigBranchView,
    },
  ],
})

export default router
