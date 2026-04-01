import { http, HttpResponse } from 'msw'

const greetings = [
  { id: '1', message: 'Hello from the AlayaCare Design System!', author: 'Alice' },
  { id: '2', message: 'Welcome to the prototype template.', author: 'Bob' },
  { id: '3', message: 'Build fast, iterate faster.', author: 'Charlie' },
]

export const handlers = [
  http.get('/api/health', () => {
    return HttpResponse.json({ status: 'ok' })
  }),

  http.get('/api/greetings', () => {
    return HttpResponse.json(greetings)
  }),

  http.post('/api/greetings', async ({ request }) => {
    const body = (await request.json()) as { message: string; author: string }
    const newGreeting = { id: String(greetings.length + 1), ...body }
    greetings.push(newGreeting)
    return HttpResponse.json(newGreeting, { status: 201 })
  }),
]
