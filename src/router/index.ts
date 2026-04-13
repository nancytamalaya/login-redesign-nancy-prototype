import { createRouter, createWebHashHistory } from 'vue-router'
import TenantConfigBranchView from '../views/TenantConfigBranchView.vue'

/**
 * Hash history works on static hosts (e.g. GitHub Pages) without server rewrites.
 * Open the app at …/index.html#/ or use the hash the dev server prints.
 */
const router = createRouter({
  history: createWebHashHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: TenantConfigBranchView,
    },
  ],
})

export default router
