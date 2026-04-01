import { createRouter, createWebHistory } from 'vue-router'
import FlowOverviewView from '../views/FlowOverviewView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: FlowOverviewView,
    },
  ],
})

export default router
