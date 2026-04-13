<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

function openTenantConfig() {
  void router.push({ name: 'tenant-config' })
}
</script>

<template>
  <div class="alaya-flow-studio">
    <header class="studio-header">
      <h1 class="studio-title">AlayaFlow Studio</h1>
      <p class="studio-subtitle">Voice Agents</p>
      <p class="studio-lede">
        Build and manage autonomous voice agents for scheduling and operations.
      </p>
    </header>

    <section class="studio-section" aria-labelledby="agents-heading">
      <h2 id="agents-heading" class="section-heading">Your agents</h2>
      <div class="agent-grid">
        <AcCard class="agent-card">
          <template #title>Vacant Visit Scheduler</template>
          <template #content>
            <p class="card-text">
              Branch overrides, urgent offers, voice agent identifiers, and escalation settings
              (Figma prototype).
            </p>
            <AcButton label="Configure" icon="ph ph-gear-six" @click="openTenantConfig" />
          </template>
        </AcCard>

        <AcCard class="agent-card agent-card--muted">
          <template #title>Visit Verification Agent</template>
          <template #content>
            <p class="card-text">Published · Run history and metrics available in production.</p>
            <AcButton label="View runs" class="p-button-outlined" disabled />
          </template>
        </AcCard>

        <AcCard class="agent-card agent-card--muted">
          <template #title>Custom voice agent</template>
          <template #content>
            <p class="card-text">Create a new agent from a template (coming soon).</p>
            <AcButton label="Create" class="p-button-outlined" disabled />
          </template>
        </AcCard>
      </div>
    </section>
  </div>
</template>

<style scoped>
.alaya-flow-studio {
  padding: 24px;
  max-width: 1200px;
  margin: 0 auto;
}

.studio-header {
  margin-bottom: 32px;
}

.studio-title {
  margin: 0 0 4px;
  font-size: 1.75rem;
  font-weight: 700;
  line-height: 1.2;
  color: var(--text-color, #181b21);
}

.studio-subtitle {
  margin: 0 0 12px;
  font-size: 1.125rem;
  font-weight: 600;
  color: var(--text-color-secondary, #4d586a);
}

.studio-lede {
  margin: 0;
  max-width: 42rem;
  font-size: 0.9375rem;
  line-height: 1.5;
  color: var(--text-color-secondary, #6c757d);
}

.section-heading {
  margin: 0 0 16px;
  font-size: 1rem;
  font-weight: 700;
  color: #343a40;
}

.agent-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.agent-card {
  height: 100%;
}

.agent-card--muted :deep(.p-card-title) {
  color: var(--text-color-secondary, #6c757d);
}

.card-text {
  margin: 0 0 16px;
  font-size: 0.875rem;
  line-height: 1.5;
  color: var(--text-color-secondary, #4d586a);
}
</style>
