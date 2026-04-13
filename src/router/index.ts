import { createRouter, createWebHashHistory } from 'vue-router'
import TenantConfigBranchView from '../views/TenantConfigBranchView.vue'

/**
 * Hash history works on static hosts (e.g. GitHub Pages) without server rewrites.
 *
 * Tenant config (Figma node 7519-44878): http://localhost:5173/#/tenant-config
 * Root hash redirects there so /#/ also resolves to the same screen.
 */
const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: { name: 'tenant-config' },
    },
    {
      path: '/tenant-config',
      name: 'tenant-config',
      component: TenantConfigBranchView,
    },
  ],
})

export default router
