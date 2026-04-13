import { createRouter, createWebHistory } from 'vue-router'
import FlowOverviewView from '../views/FlowOverviewView.vue'
import TenantConfigBranchView from '../views/TenantConfigBranchView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: FlowOverviewView,
    },
    {
      path: '/vacant-visit-scheduler/config',
      name: 'vacant-visit-scheduler-config',
      component: TenantConfigBranchView,
    },
  ],
})

export default router
