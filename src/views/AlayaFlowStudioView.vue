<script setup lang="ts">
import AlayaFlowStudio from '@/components/AlayaFlowStudio.vue'
</script>

<template>
  <main class="alaya-flow-studio-view">
    <AlayaFlowStudio />
  </main>
</template>

<style scoped>
.alaya-flow-studio-view {
  min-height: 100%;
  background: var(--surface-ground, #f8f9fa);
}
</style>
