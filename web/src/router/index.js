import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '../views/Dashboard.vue'
import Artists from '../views/Artists.vue'
import Episodes from '../views/Episodes.vue'

const routes = [
  {
    path: '/',
    name: 'Dashboard',
    component: Dashboard
  },
  {
    path: '/artists',
    name: 'Artists',
    component: Artists
  },
  {
    path: '/episodes',
    name: 'Episodes',
    component: Episodes
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
