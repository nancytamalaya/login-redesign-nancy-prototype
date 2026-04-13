<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const branchOptions = [
  { label: 'Texas', value: 'texas' },
  { label: 'Atlanta Branch', value: 'atlanta' },
  { label: 'North Region', value: 'north' },
]

const escalateGroupOptions = [
  { label: 'Scheduling Supervisor', value: 'scheduling-supervisor' },
  { label: 'Clinical Manager', value: 'clinical-manager' },
]

const escalateAssigneeOptions = [
  { label: 'Alexandra (Audra) Dunne', value: 'alexandra-dunne' },
  { label: 'Jordan Smith', value: 'jordan-smith' },
]

const selectedBranch = ref('texas')

const minutesSaved = ref(20)
const dollarsSaved = ref(5)
const urgentHours = ref(4)

const generateOffers = ref<'employees' | 'assign'>('employees')
const offerExpiryType = ref<'now' | 'visit'>('now')
const offerExpiryMinutes = ref(120)
const workAssignmentRule = ref<'first' | 'highest'>('first')

const voiceCallEnabled = ref(false)
const employeesToCall = ref(3)

const agentIdentifier = ref('')
const phoneIdentifier = ref('')

const autoApprove = ref(false)
const escalateGroup = ref('scheduling-supervisor')
const escalateAssignee = ref('alexandra-dunne')

/** Step tree — AcCheckbox mirrors Figma completion state + shows checkbox control type. */
const treeStepIdentifyDone = ref(true)
const treeStepMatchDone = ref(true)
const treeStepApproveDone = ref(true)
const treeStepFinalizeDone = ref(false)

const notifyAssigneeOnEscalation = ref(true)

function goBack() {
  if (window.history.length > 1) {
    router.back()
  } else {
    void router.push({ name: 'studio' })
  }
}

function onAddOverride() {
  // Prototype: no persistence
}

function onDeleteOverride() {
  // Prototype: no persistence
}

function onSave() {
  // Prototype: no persistence
}
</script>

<template>
  <div class="tenant-config-branch">
    <header class="page-heading">
      <div class="heading-inner">
        <div class="title-row-primary">
          <AcButton
            icon="ph ph-arrow-left"
            class="p-button-outlined p-button-rounded back-btn-inline"
            aria-label="Go back"
            @click="goBack"
          />
          <h1 class="page-title">Vacant Visit Scheduler</h1>
          <AcTag severity="warning-light" value="Configuring" rounded class="title-tag" />
        </div>
        <p class="page-meta">
          <span>Scheduling</span>
          <span class="meta-sep" aria-hidden="true">·</span>
          <span>Autonomous</span>
          <span class="meta-sep" aria-hidden="true">·</span>
          <span>V1.1</span>
          <span class="meta-sep" aria-hidden="true">·</span>
          <span>Updated on 11/01/2026, 18:16, by Administrator</span>
        </p>
      </div>
    </header>

    <div class="main-surface">
      <aside class="step-tree" aria-label="Configuration steps">
        <div class="tree-row">
          <span class="tree-spacer" />
          <span class="tree-label">Identify and Prioritize Vacant Visits</span>
          <AcCheckbox
            v-model="treeStepIdentifyDone"
            binary
            hide-label
            input-id="tree-step-identify"
            class="tree-checkbox"
            aria-label="Step complete: Identify and Prioritize Vacant Visits"
          />
        </div>
        <div class="tree-row">
          <span class="tree-spacer" />
          <span class="tree-label">Match and Offer to Caregivers</span>
          <AcCheckbox
            v-model="treeStepMatchDone"
            binary
            hide-label
            input-id="tree-step-match"
            class="tree-checkbox"
            aria-label="Step complete: Match and Offer to Caregivers"
          />
        </div>
        <div class="tree-row tree-row-expandable">
          <button type="button" class="tree-toggle" aria-expanded="true" aria-label="Toggle step">
            <i class="ph ph-caret-down" aria-hidden="true" />
          </button>
          <span class="tree-label">Approve Assignment or Escalate</span>
          <AcCheckbox
            v-model="treeStepApproveDone"
            binary
            hide-label
            input-id="tree-step-approve"
            class="tree-checkbox"
            aria-label="Step complete: Approve Assignment or Escalate"
          />
        </div>
        <div class="tree-row tree-row-nested tree-row-active">
          <span class="tree-label">Branch</span>
        </div>
        <div class="tree-row tree-row-nested tree-row-indent-2">
          <span class="tree-label">Group</span>
        </div>
        <div class="tree-row tree-row-nested tree-row-indent-3">
          <span class="tree-label">Payor</span>
        </div>
        <div class="tree-row">
          <span class="tree-spacer" />
          <span class="tree-label">Finalize and Publish Agent</span>
          <AcCheckbox
            v-model="treeStepFinalizeDone"
            binary
            hide-label
            input-id="tree-step-finalize"
            class="tree-checkbox"
            aria-label="Step complete: Finalize and Publish Agent"
          />
        </div>
      </aside>

      <section class="config-card">
        <div class="card-header">
          <div class="card-header-left">
            <h2 class="card-title">Branch Override for</h2>
            <AcDropdown
              v-model="selectedBranch"
              :options="branchOptions"
              option-label="label"
              option-value="value"
              class="branch-dropdown"
            />
          </div>
          <AcButton
            label="Override"
            icon="ph ph-plus"
            class="p-button-outlined"
            @click="onAddOverride"
          />
        </div>

        <div class="card-body">
          <div class="form-stack">
            <div class="form-section">
              <h3 class="section-title">Outcomes</h3>
              <AcInputNumber
                v-model="minutesSaved"
                label="Minutes saved per automated outcomes"
                required
                class="field-block"
                :min="0"
              />
              <AcInputNumber
                v-model="dollarsSaved"
                label="Dollars saved per automated outcome"
                required
                class="field-block"
                :min="0"
                :min-fraction-digits="2"
                :max-fraction-digits="2"
                mode="decimal"
              />
            </div>

            <div class="form-section">
              <h3 class="section-title">Urgent Visit</h3>
              <AcInputNumber
                v-model="urgentHours"
                label="A visit is urgent if scheduled less than X hours from now"
                required
                class="field-block"
                :min="0"
              />
            </div>

            <div class="form-section">
              <h3 class="section-title">Urgent Offer</h3>

              <div class="radio-field">
                <div class="radio-label-row">
                  <span class="radio-group-label">Generate offers</span>
                  <span class="required-asterisk" aria-hidden="true">*</span>
                </div>
                <div class="radio-options">
                  <div class="radio-line">
                    <AcRadioButton
                      v-model="generateOffers"
                      input-id="gen-offer-emp"
                      name="generateOffers"
                      :value="'employees'"
                    />
                    <label for="gen-offer-emp" class="radio-text">Offer visit to employee(s)</label>
                  </div>
                  <div class="radio-line">
                    <AcRadioButton
                      v-model="generateOffers"
                      input-id="gen-offer-assign"
                      name="generateOffers"
                      :value="'assign'"
                    />
                    <label for="gen-offer-assign" class="radio-text">
                      Assign visit to top employee without an offer
                    </label>
                  </div>
                </div>
              </div>

              <div class="radio-field">
                <div class="radio-label-row">
                  <span class="radio-group-label">Offer Expiry Type</span>
                  <span class="required-asterisk" aria-hidden="true">*</span>
                </div>
                <div class="radio-options">
                  <div class="radio-line">
                    <AcRadioButton
                      v-model="offerExpiryType"
                      input-id="exp-now"
                      name="offerExpiryType"
                      :value="'now'"
                    />
                    <label for="exp-now" class="radio-text">Calculate expiry relative to now</label>
                  </div>
                  <div class="radio-line">
                    <AcRadioButton
                      v-model="offerExpiryType"
                      input-id="exp-visit"
                      name="offerExpiryType"
                      :value="'visit'"
                    />
                    <label for="exp-visit" class="radio-text">
                      Calculate expiry relative to visit start
                    </label>
                  </div>
                </div>
              </div>

              <AcInputNumber
                v-model="offerExpiryMinutes"
                label="Offer Expiry Minutes"
                required
                class="field-block"
                :min="0"
              />

              <div class="radio-field">
                <div class="radio-label-row">
                  <span class="radio-group-label">Work Assignment Rule</span>
                  <span class="required-asterisk" aria-hidden="true">*</span>
                </div>
                <div class="radio-options">
                  <div class="radio-line">
                    <AcRadioButton
                      v-model="workAssignmentRule"
                      input-id="war-first"
                      name="workAssignmentRule"
                      :value="'first'"
                    />
                    <label for="war-first" class="radio-text">
                      Assign to the employee that responds first
                    </label>
                  </div>
                  <div class="radio-line">
                    <AcRadioButton
                      v-model="workAssignmentRule"
                      input-id="war-highest"
                      name="workAssignmentRule"
                      :value="'highest'"
                    />
                    <label for="war-highest" class="radio-text">
                      After expiry, assign to employee what was ranked the highest
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <div class="form-section">
              <h3 class="section-title">Work Assignment Rules</h3>
              <div class="switch-row">
                <AcInputSwitch
                  v-model="voiceCallEnabled"
                  input-id="voice-call"
                  class="form-inputswitch"
                />
                <label for="voice-call" class="switch-label">Contact top employees via voice call</label>
              </div>
              <AcInputNumber
                v-model="employeesToCall"
                label="Number of employees to call"
                required
                class="field-block"
                :min="0"
              />
            </div>

            <div class="form-section">
              <h3 class="section-title">Voice Agent</h3>
              <AcInputText
                v-model="agentIdentifier"
                label="Agent Identifier (Contact AlayaCare for identifier)"
                required
                class="field-block"
              />
              <AcInputText
                v-model="phoneIdentifier"
                label="Phone Number Identifier (Contact AlayaCare for identifier)"
                required
                class="field-block"
              />
            </div>

            <div class="form-section">
              <h3 class="section-title">Escalations</h3>
              <p class="section-hint">
                If auto-approve is off, escalations become tasks for manual approval.
              </p>
              <div class="switch-row">
                <AcInputSwitch
                  v-model="autoApprove"
                  input-id="auto-approve"
                  class="form-inputswitch"
                />
                <label for="auto-approve" class="switch-label">Auto-approve</label>
              </div>
              <AcCheckbox
                v-model="notifyAssigneeOnEscalation"
                binary
                input-id="notify-assignee"
                label="Notify escalation assignee by email"
                class="field-block escalation-checkbox"
              />
              <AcDropdown
                v-model="escalateGroup"
                :options="escalateGroupOptions"
                option-label="label"
                option-value="value"
                label="Escalate to Group"
                required
                class="field-block"
              />
              <AcDropdown
                v-model="escalateAssignee"
                :options="escalateAssigneeOptions"
                option-label="label"
                option-value="value"
                label="Escalate to Assignee (optional)"
                class="field-block"
              />
            </div>
          </div>
        </div>

        <footer class="card-footer">
          <AcButton
            icon="ph ph-trash"
            class="p-button-text p-button-rounded footer-delete"
            aria-label="Delete override"
            @click="onDeleteOverride"
          />
          <AcButton label="Save" class="save-btn" @click="onSave" />
        </footer>
      </section>
    </div>
  </div>
</template>

<style scoped>
.tenant-config-branch {
  --config-bg: #f3f5f7;
  --text-primary: #181b21;
  --text-secondary: #4d586a;
  --text-muted: #68778d;
  --border-subtle: #dee2e6;
  --border-panel: #eaedf0;
  --active-row-bg: #eff6ff;
  min-height: 100%;
  display: flex;
  flex-direction: column;
  background: #fff;
}

.page-heading {
  padding: 12px 16px;
  border-bottom: 1px solid var(--border-panel);
}

.heading-inner {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.title-row-primary {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px 16px;
}

:deep(.back-btn-inline) {
  width: 40px;
  height: 40px;
  min-width: 40px;
  padding: 0;
  flex-shrink: 0;
  border-color: #7d8a9e;
  color: var(--text-secondary);
}

:deep(.back-btn-inline .p-button-icon),
:deep(.back-btn-inline [data-pc-section='icon']) {
  font-size: 1.125rem;
}

.page-title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
  line-height: 1;
  color: var(--text-primary);
}

.title-tag {
  flex-shrink: 0;
}

.page-meta {
  margin: 0;
  padding: 4px 0;
  font-size: 0.875rem;
  line-height: 1.25;
  color: var(--text-primary);
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 4px;
}

.meta-sep {
  color: #ced2da;
  font-size: 0.75rem;
  font-weight: 500;
}

.main-surface {
  flex: 1;
  display: flex;
  gap: 16px;
  align-items: flex-start;
  justify-content: center;
  padding: 8px 16px 24px;
  background: var(--config-bg);
}

.step-tree {
  flex-shrink: 0;
  width: 360px;
  max-width: 100%;
  background: #fff;
  border: 1px solid var(--border-subtle);
  border-radius: 6px;
  padding: 4px 8px;
}

.tree-row {
  display: flex;
  align-items: center;
  gap: 8px;
  min-height: 42px;
  padding: 7px 8px 7px 0;
  border-radius: 6px;
}

.tree-row-expandable .tree-toggle {
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  background: transparent;
  border-radius: 14px;
  cursor: pointer;
  color: var(--text-secondary);
  padding: 0;
}

.tree-spacer {
  width: 28px;
  flex-shrink: 0;
}

.tree-label {
  flex: 1;
  font-size: 0.875rem;
  color: var(--text-secondary);
  line-height: 1.25;
}

:deep(.tree-checkbox) {
  flex-shrink: 0;
  margin: 0;
}

:deep(.tree-checkbox .p-checkbox) {
  vertical-align: middle;
}

.tree-row-nested {
  padding-left: 36px;
}

.tree-row-indent-2 {
  padding-left: 52px;
}

.tree-row-indent-3 {
  padding-left: 68px;
}

.tree-row-active {
  background: var(--active-row-bg);
}

.tree-row-active .tree-label {
  color: var(--text-secondary);
  font-weight: 500;
}

.config-card {
  flex: 1;
  min-width: 0;
  background: #fff;
  border: 1px solid var(--border-panel);
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  max-width: 100%;
}

.card-header {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  padding: 16px 16px 0;
  padding-bottom: 16px;
}

.card-header-left {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
}

.card-title {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 700;
  line-height: 1.6;
  color: var(--text-primary);
}

:deep(.branch-dropdown) {
  width: 200px;
  min-width: 160px;
}

.card-body {
  padding: 0 16px 16px;
}

.form-stack {
  display: flex;
  flex-direction: column;
  gap: 32px;
  max-width: 919px;
}

.form-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.section-title {
  margin: 0;
  font-size: 1rem;
  font-weight: 700;
  line-height: 1.25;
  color: #343a40;
}

.section-hint {
  margin: 0;
  font-size: 0.875rem;
  line-height: 1.43;
  color: var(--text-secondary);
}

:deep(.field-block) {
  width: 100%;
  max-width: 420px;
}

.radio-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.radio-label-row {
  display: flex;
  align-items: center;
  gap: 4px;
  min-height: 16px;
}

.radio-group-label {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-muted);
  line-height: 1.75rem;
}

.required-asterisk {
  color: var(--p-red-500, #e3291c);
  font-weight: 700;
  font-size: 0.875rem;
}

.radio-options {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.radio-line {
  display: flex;
  align-items: center;
  gap: 9px;
}

:deep(.radio-line .p-radiobutton) {
  flex-shrink: 0;
}

:deep(.radio-line .p-radiobutton-box) {
  width: 22px;
  height: 22px;
}

.radio-text {
  font-size: 0.875rem;
  line-height: 1.5;
  color: var(--text-secondary);
  cursor: pointer;
}

.switch-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

:deep(.form-inputswitch.p-inputswitch) {
  flex-shrink: 0;
}

:deep(.escalation-checkbox) {
  max-width: 420px;
}

.switch-label {
  font-size: 0.875rem;
  color: var(--text-secondary);
  cursor: pointer;
  line-height: 1.25;
}

.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 16px;
  margin-top: auto;
  padding: 16px;
  border-top: 1px solid #dfe2e7;
  border-radius: 0 0 6px 6px;
}

:deep(.footer-delete) {
  color: var(--text-muted);
}

:deep(.save-btn) {
  background: #1d5eed;
  border-color: #1d5eed;
}

@media (max-width: 1024px) {
  .main-surface {
    flex-direction: column;
    align-items: stretch;
  }

  .step-tree {
    width: 100%;
  }
}
</style>
