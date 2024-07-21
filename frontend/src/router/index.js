// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router';
import SchoolsList from '../components/SchoolsList.vue';

const routes = [
  {
    path: '/',
    name: 'SchoolsList',
    component: SchoolsList
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;
