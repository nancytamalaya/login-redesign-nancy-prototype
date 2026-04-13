import { createRouter, createWebHistory } from 'vue-router'
import TenantConfigBranchView from '../views/TenantConfigBranchView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: TenantConfigBranchView,
    },
  ],
})

export default router
