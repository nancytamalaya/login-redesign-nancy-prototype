<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import {
  AcButton,
  AcCard,
  AcHeading,
  AcInputText,
  AcTag,
  AcMessage,
  AcDivider,
  AcProgressSpinner,
  useAcToast,
} from '@alayacare/alaya-design-system'
import { useGreetingStore } from '@/stores/greeting'
import { useCounterStore } from '@/stores/counter'

const route = useRoute()
const toast = useAcToast()
const greetingStore = useGreetingStore()
const counterStore = useCounterStore()

const newMessage = ref('')
const newAuthor = ref('')
const apiStatus = ref<string | null>(null)

async function checkHealth() {
  const res = await fetch('/api/health')
  const data = await res.json()
  apiStatus.value = data.status
}

async function submitGreeting() {
  if (!newMessage.value.trim() || !newAuthor.value.trim()) return

  await greetingStore.addGreeting(newMessage.value, newAuthor.value)
  toast.add({
    severity: 'success',
    summary: 'Greeting added',
    detail: `"${newMessage.value}" by ${newAuthor.value}`,
    life: 3000,
  })
  newMessage.value = ''
  newAuthor.value = ''
}

onMounted(() => {
  checkHealth()
  greetingStore.fetchGreetings()
})
</script>

<template>
  <div class="hello-world">
    <AcHeading title="Hello World" details="Prototype template demo" hide-divider />

    <div class="acds-row">
      <div class="acds-col-12">
        <AcMessage severity="info" :closable="false">
          You are viewing route <strong>{{ route.path }}</strong> (name: <strong>{{ String(route.name) }}</strong>).
          This component demonstrates the Alaya Design System, Pinia stores, MSW mocking, and Vue Router — all wired together.
        </AcMessage>
      </div>
    </div>

    <div class="acds-row" style="margin-top: 1rem;">
      <!-- API Health + Counter store -->
      <div class="acds-col-6">
        <AcCard>
          <template #title>API Health &amp; Counter</template>
          <template #subtitle>MSW mock + Pinia store</template>
          <template #content>
            <p style="margin-bottom: 0.75rem;">
              Mock API status:
              <AcTag v-if="apiStatus" :value="apiStatus" severity="success" />
              <AcProgressSpinner v-else style="width: 1.25rem; height: 1.25rem;" />
            </p>

            <AcDivider />

            <p style="margin-bottom: 0.5rem;">
              Counter: <strong>{{ counterStore.count }}</strong>
              (double: <strong>{{ counterStore.doubleCount }}</strong>)
            </p>
            <AcButton label="Increment" icon="ph ph-plus" @click="counterStore.increment" />
          </template>
        </AcCard>
      </div>

      <!-- Greeting form -->
      <div class="acds-col-6">
        <AcCard>
          <template #title>Add a Greeting</template>
          <template #subtitle>Posts to MSW-mocked endpoint</template>
          <template #content>
            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
              <AcInputText v-model="newAuthor" placeholder="Your name" />
              <AcInputText v-model="newMessage" placeholder="Your message" />
              <AcButton
                label="Submit"
                icon="pi pi-send"
                :disabled="!newMessage.trim() || !newAuthor.trim()"
                @click="submitGreeting"
              />
            </div>
          </template>
        </AcCard>
      </div>
    </div>

    <!-- Greetings list -->
    <div class="acds-row" style="margin-top: 1rem;">
      <div class="acds-col-12">
        <AcCard>
          <template #title>
            Greetings
            <AcTag :value="String(greetingStore.count)" severity="info" rounded style="margin-left: 0.5rem;" />
          </template>
          <template #subtitle>Fetched from <code>/api/greetings</code> via MSW</template>
          <template #content>
            <AcProgressSpinner v-if="greetingStore.loading" />
            <AcMessage v-else-if="greetingStore.error" severity="error" :closable="false">
              {{ greetingStore.error }}
            </AcMessage>
            <div v-else class="greeting-list">
              <div v-for="greeting in greetingStore.greetings" :key="greeting.id" class="greeting-item">
                <AcTag :value="greeting.author" severity="primary" />
                <span>{{ greeting.message }}</span>
              </div>
            </div>
          </template>
        </AcCard>
      </div>
    </div>
  </div>
</template>

<style scoped>
.hello-world {
  max-width: 960px;
  margin: 2rem auto;
  padding: 0 1rem;
}

.greeting-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.greeting-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}
</style>
