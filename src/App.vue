<script setup lang="ts">
import { RouterView } from 'vue-router'
import AppTopBar from '@/components/AppTopBar.vue'
import AppSideBar from '@/components/AppSideBar.vue'
</script>

<template>
  <AppTopBar />
  <AppSideBar />
  <main class="app-content">
    <RouterView />
  </main>
</template>

<style>
html,
body {
  margin: 0;
  padding: 0;
}
</style>

<style scoped>
.app-content {
  margin-left: 85px;
  margin-top: 60px;
  min-height: calc(100vh - 60px);
  overflow: auto;
}

@media only screen and (max-width: 1024px) {
  .app-content {
    margin-left: 0;
  }
}
</style>
