import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/login',
      name: 'Login',
      component: () => import('@/views/Login.vue'),
      meta: { layout: 'AuthLayout' }
    },
    {
      path: '/',
      name: 'DashboardLayout',
      component: () => import('@/layouts/DashboardLayout.vue'),
      redirect: '/dashboard',
      children: [
        {
          path: 'dashboard',
          name: 'Dashboard',
          component: () => import('@/views/Dashboard.vue')
        },
        {
          path: 'apps',
          name: 'AppManagement',
          component: () => import('@/views/AppManagement.vue')
        },
        {
          path: 'apps/:id',
          name: 'AppDetail',
          component: () => import('@/views/AppDetail.vue')
        }
      ]
    }
  ],
})

export default router
