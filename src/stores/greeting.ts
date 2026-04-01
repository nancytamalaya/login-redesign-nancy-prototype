import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

interface Greeting {
  id: string
  message: string
  author: string
}

export const useGreetingStore = defineStore('greeting', () => {
  const greetings = ref<Greeting[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const count = computed(() => greetings.value.length)

  async function fetchGreetings() {
    loading.value = true
    error.value = null
    try {
      const res = await fetch('/api/greetings')
      greetings.value = await res.json()
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to fetch greetings'
    } finally {
      loading.value = false
    }
  }

  async function addGreeting(message: string, author: string) {
    const res = await fetch('/api/greetings', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message, author }),
    })
    const newGreeting: Greeting = await res.json()
    greetings.value.push(newGreeting)
    return newGreeting
  }

  return { greetings, loading, error, count, fetchGreetings, addGreeting }
})
