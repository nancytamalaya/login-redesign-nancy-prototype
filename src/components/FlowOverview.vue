<script setup lang="ts">
import { ref, computed } from 'vue'
import { RouterLink } from 'vue-router'
import type { PageState } from 'primevue/paginator'

interface FlowRun {
  id: string
  initiator: string
  date: string
  status: 'Completed' | 'Running' | 'Failed'
  version: string
  escalation: boolean
  outcomes: boolean
}

const flowRuns = ref<FlowRun[]>([
  { id: '1', initiator: 'Automated', date: 'Today, 9:48 AM', status: 'Completed', version: 'v1.1', escalation: false, outcomes: true },
  { id: '2', initiator: 'Assignee', date: 'Today, 9:47 AM', status: 'Completed', version: 'v1.1', escalation: false, outcomes: true },
  { id: '3', initiator: 'Automated', date: 'Today, 9:46 AM', status: 'Completed', version: 'v1.1', escalation: false, outcomes: true },
  { id: '4', initiator: 'Automated', date: 'Today, 9:45 AM', status: 'Completed', version: 'v1.1', escalation: false, outcomes: true },
  { id: '5', initiator: 'Automated', date: 'Today, 9:44 AM', status: 'Completed', version: 'v1.1', escalation: true, outcomes: false },
  { id: '6', initiator: 'Automated', date: 'Today, 9:43 AM', status: 'Completed', version: 'v1.1', escalation: false, outcomes: true },
  { id: '7', initiator: 'Automated', date: 'Today, 9:42 AM', status: 'Completed', version: 'v1.1', escalation: false, outcomes: true },
  { id: '8', initiator: 'Automated', date: 'Today, 9:41 AM', status: 'Completed', version: 'v1.1', escalation: false, outcomes: true },
  { id: '9', initiator: 'Automated', date: 'Today, 9:49 AM', status: 'Completed', version: 'v1.1', escalation: false, outcomes: true },
  { id: '10', initiator: 'Automated', date: 'Jan 31 2026, 10:00 AM', status: 'Completed', version: 'v1.1', escalation: true, outcomes: true },
])

const dateRangeOptions = [
  { label: 'Last 7 Days', value: '7' },
  { label: 'Last 30 Days', value: '30' },
  { label: 'Last 90 Days', value: '90' },
  { label: 'All Time', value: 'all' },
]
const selectedDateRange = ref('30')

const stats = [
  { value: '10h', label: 'Time Saved' },
  { value: '$1k', label: 'Cost Saved' },
  { value: '29', label: 'Outcomes Achieved' },
  { value: '13', label: 'Flows Running' },
  { value: '1', label: 'Open Escalations' },
  { value: '5%', label: 'Escalation Rate' },
]

const first = ref(0)
const rows = ref(10)
const totalRecords = ref(100)

const rowsPerPageOptions = [10, 25, 50]

function onPageChange(event: PageState) {
  first.value = event.first
  rows.value = event.rows
}

const currentPageDisplay = computed(() => {
  const start = first.value + 1
  const end = Math.min(first.value + rows.value, totalRecords.value)
  return `${start}-${end}`
})

function handleView(run: FlowRun) {
  console.log('View run:', run)
}

function goBack() {
  window.history.back()
}
</script>

<template>
  <div class="flow-overview">
    <p class="prototype-nav">
      <RouterLink class="prototype-link" :to="{ name: 'vacant-visit-scheduler-config' }">
        Open Vacant Visit Scheduler — branch config (Figma prototype)
      </RouterLink>
    </p>
    <header class="flow-header">
      <div class="header-left">
        <AcButton
          icon="pi pi-arrow-left"
          class="p-button-text p-button-rounded back-button"
          @click="goBack"
          aria-label="Go back"
        />
        <div class="header-content">
          <div class="title-row">
            <h1 class="flow-title">Flow: Check for exceptions</h1>
            <AcTag severity="success" value="Published" />
          </div>
          <p class="flow-subtitle">
            Visit Verification Agent · Autonomous · V1.1 · Updated on 11/01/2026, 18:16, by Administrator
          </p>
        </div>
      </div>
      <div class="header-right">
        <AcDropdown
          v-model="selectedDateRange"
          :options="dateRangeOptions"
          optionLabel="label"
          optionValue="value"
          class="date-range-dropdown"
        />
      </div>
    </header>

    <section class="stats-section">
      <div class="stats-grid">
        <div v-for="stat in stats" :key="stat.label" class="stat-card">
          <div class="stat-value">{{ stat.value }}</div>
          <div class="stat-label">{{ stat.label }}</div>
        </div>
      </div>
    </section>

    <section class="runs-section">
      <div class="runs-header">
        <h2 class="runs-title">Runs</h2>
        <div class="runs-actions">
          <AcButton
            icon="pi pi-filter"
            label="Filters"
            class="p-button-outlined"
          />
          <AcButton
            icon="pi pi-refresh"
            class="p-button-text p-button-rounded"
            aria-label="Refresh"
          />
        </div>
      </div>

      <AcDataTable
        :value="flowRuns"
        :paginator="true"
        :rows="rows"
        :totalRecords="totalRecords"
        :first="first"
        :rowsPerPageOptions="rowsPerPageOptions"
        :lazy="true"
        paginatorTemplate="CurrentPageReport FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink RowsPerPageDropdown"
        :currentPageReportTemplate="`${currentPageDisplay} of ${totalRecords}+`"
        @page="onPageChange"
        class="runs-table"
        stripedRows
      >
        <AcColumn field="initiator" header="Initiator" />
        <AcColumn field="date" header="Date" />
        <AcColumn field="status" header="Status">
          <template #body="slotProps">
            <AcTag
              :severity="slotProps.data.status === 'Completed' ? 'success' : slotProps.data.status === 'Running' ? 'info' : 'danger'"
              :value="slotProps.data.status"
            />
          </template>
        </AcColumn>
        <AcColumn field="version" header="Version" />
        <AcColumn field="escalation" header="Escalation">
          <template #body="slotProps">
            {{ slotProps.data.escalation ? 'Yes' : 'No' }}
          </template>
        </AcColumn>
        <AcColumn field="outcomes" header="Outcomes">
          <template #body="slotProps">
            {{ slotProps.data.outcomes ? 'Yes' : 'No' }}
          </template>
        </AcColumn>
        <AcColumn header="">
          <template #body="slotProps">
            <AcButton
              label="View"
              class="p-button-outlined view-button"
              @click="handleView(slotProps.data)"
            />
          </template>
        </AcColumn>
      </AcDataTable>
    </section>
  </div>
</template>

<style scoped>
.flow-overview {
  padding: 24px;
  background-color: var(--surface-ground, #f8f9fa);
  min-height: 100%;
}

.prototype-nav {
  margin: 0 0 16px;
}

.prototype-link {
  font-size: 0.875rem;
  color: var(--p-primary-color, #1d5eed);
  text-decoration: underline;
  text-underline-offset: 2px;
}

.prototype-link:hover {
  text-decoration: none;
}

.flow-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 24px;
}

.header-left {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

:deep(.back-button) {
  color: var(--text-color-secondary, #6c757d);
  margin-top: 4px;
  background: var(--surface-card, #ffffff);
  border: 1px solid var(--surface-border, #dee2e6);
  width: 36px;
  height: 36px;
}

:deep(.back-button:hover) {
  background: var(--surface-hover, #e9ecef);
}

.header-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.title-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.flow-title {
  font-size: 1.5rem;
  font-weight: 600;
  margin: 0;
  color: var(--text-color, #212529);
}

.flow-subtitle {
  font-size: 0.875rem;
  color: var(--text-color-secondary, #6c757d);
  margin: 0;
}

.header-right {
  display: flex;
  align-items: center;
}

:deep(.date-range-dropdown) {
  min-width: 150px;
}

.stats-section {
  margin-bottom: 24px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 16px;
}

.stat-card {
  background-color: var(--surface-card, #ffffff);
  border: 1px solid var(--surface-border, #dee2e6);
  border-radius: 8px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.stat-value {
  font-size: 1.75rem;
  font-weight: 700;
  color: var(--text-color, #212529);
  line-height: 1.2;
}

.stat-label {
  font-size: 0.875rem;
  color: var(--text-color-secondary, #6c757d);
}

.runs-section {
  background-color: var(--surface-card, #ffffff);
  border: 1px solid var(--surface-border, #dee2e6);
  border-radius: 8px;
}

.runs-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid var(--surface-border, #dee2e6);
}

.runs-title {
  font-size: 1.125rem;
  font-weight: 600;
  margin: 0;
  color: var(--text-color, #212529);
}

.runs-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

:deep(.runs-table) {
  width: 100%;
}

:deep(.runs-table .p-datatable-wrapper) {
  border-radius: 0 0 8px 8px;
}

:deep(.runs-table .p-datatable-thead > tr > th) {
  background: var(--surface-ground, #f8f9fa);
  padding: 12px 16px;
  font-weight: 500;
  color: var(--text-color-secondary, #6c757d);
  font-size: 0.875rem;
  border: none;
  border-bottom: 1px solid var(--surface-border, #dee2e6);
}

:deep(.runs-table .p-datatable-tbody > tr > td) {
  padding: 12px 16px;
  border: none;
  border-bottom: 1px solid var(--surface-border, #dee2e6);
}

:deep(.runs-table .p-datatable-tbody > tr:last-child > td) {
  border-bottom: none;
}

:deep(.runs-table .p-paginator) {
  padding: 12px 16px;
  border-top: 1px solid var(--surface-border, #dee2e6);
  justify-content: space-between;
}

:deep(.view-button) {
  padding: 6px 16px;
  font-size: 0.875rem;
}

@media (max-width: 1200px) {
  .stats-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .flow-header {
    flex-direction: column;
    gap: 16px;
  }

  .header-right {
    width: 100%;
  }

  :deep(.date-range-dropdown) {
    width: 100%;
  }
}
</style>
