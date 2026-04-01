# accloud-prototype-template

A ready-to-go prototype repository for building interactive prototypes with **Vue 3**, **TypeScript**, and the **AlayaCare Design System**. It includes mock API support out of the box via MSW so you can prototype realistic data flows without a backend.

## Getting Started

### Prerequisites

- **Node.js** `>=20.19` and `<24`
- **npm** (ships with Node)
- Access to the `@alayacare` npm registry (via AWS CodeArtifact)

### Create a New Project

1. **Clone or copy the template** into a new directory:

   ```sh
   git clone <template-repo-url> my-prototype
   cd my-prototype
   ```

2. **Install dependencies:**

   ```sh
   npm install
   ```

3. **Start the dev server:**

   ```sh
   npm run dev
   ```

   The app will be available at the URL printed in the terminal (typically `http://localhost:5173`).

### Commands

| Command | Description |
|---|---|
| `npm run dev` | Start the Vite dev server with hot-reload |
| `npm run build` | Type-check and compile for production |
| `npm run preview` | Preview the production build locally |

## Project Structure

```
src/
├── assets/          # CSS and static assets
├── components/      # Reusable UI components
├── mocks/           # MSW mock API handlers
│   ├── browser.ts   # Service Worker setup
│   └── handlers.ts  # Request handlers (your fake API lives here)
├── router/          # Vue Router configuration
│   └── index.ts
├── stores/          # Pinia state management stores
├── views/           # Page-level components (one per route)
├── App.vue          # Root layout with <RouterView />
└── main.ts          # App bootstrap
```

## Key Concepts

### AlayaCare Design System

All UI should be built with `Ac`-prefixed components from `@alayacare/alaya-design-system`. Prefer these over raw HTML elements to keep the prototype visually consistent with the product.

The design system styles are imported globally in `src/main.ts` — no extra setup is needed.

### Mock API with MSW

This project uses [MSW (Mock Service Worker)](https://mswjs.io/) to intercept network requests and return mock data. MSW runs in **all environments** (not just development), so the prototype is fully self-contained with no real backend required.

- **Define handlers** in `src/mocks/handlers.ts` using the `http` helper from MSW.
- Handlers are automatically registered via `src/mocks/browser.ts`.
- Use standard `fetch()` calls in your components and stores — MSW intercepts them transparently.

The template ships with example handlers at `/api/greetings` to demonstrate the pattern.

### State Management with Pinia

Use [Pinia](https://pinia.vuejs.org/) stores in `src/stores/` to manage shared state. Stores use the Composition API style (`defineStore` with a setup function). See `src/stores/greeting.ts` for an example that fetches data from the mock API.

### Routing

Routes are defined in `src/router/index.ts`. Each route maps a URL path to a view component in `src/views/`. The template starts with a single `/` route pointing to `HomeView`.


## GitHub Pages

Pushes to branches with a `cursor/` prefix are auto-deployed to GitHub Pages via CircleCI.
This allows sharing prototypes with others for feedback and collaboration.

Flow:
- CircleCI runs a gitleaks secrets scan (blocks deploy if secrets are found).
- CircleCI builds the app (`npm run build-only` → `dist/`).
- CircleCI pushes the build output to the `gh-pages` branch under a **slugified branch name** (non-alphanumeric characters become dashes).
- GitHub Pages serves from the `gh-pages` branch.
- CircleCI posts a comment on the PR with the preview URL.

The branch name is slugified for the URL: slashes and special characters become dashes.

Example: branch `cursor/dog-breeds-datatable-fe12` → `https://alayacare.github.io/accloud-prototype-template/cursor-dog-breeds-datatable-fe12/`

An index of all deployed prototypes is at `https://alayacare.github.io/accloud-prototype-template/`.

### One-time repo setup

1. **GitHub → Settings → Pages → Build and deployment** — set **Source** to **Deploy from a branch**, choose branch **`gh-pages`**, folder **`/ (root)`**.
2. **GitHub → Settings → Branches** — add branch protection on `gh-pages` (restrict pushes to the CI GitHub App, disable force push and deletion).
3. **CircleCI** — ensure the `aws-ecr` and `github-app` contexts are available to this project.