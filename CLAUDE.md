# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```sh
npm install          # Install dependencies
npm run dev          # Dev server with hot-reload (Vite)
npm run build        # Production build (type-check + compile)
npm run build-only   # Vite build without type-checking
npm run type-check   # Run vue-tsc type-checking
npm run test:unit    # Run unit tests (Vitest, watch mode)
npm run lint         # Run oxlint then ESLint with auto-fix
npm run format       # Format src/ with Prettier
```

Run a single test file: `npx vitest run src/__tests__/App.spec.ts`

## Tech Stack

- **Vue 3** with Composition API (`<script setup lang="ts">`)
- **Pinia** for state management (setup/store pattern with `defineStore`)
- **Vue Router** with `createWebHistory`
- **shadcn-vue** (vega style, reka base) — UI components in `src/components/ui/`, managed via `components.json`
- **Reka UI** — headless primitives underlying shadcn-vue components
- **Tailwind CSS v4** via `@tailwindcss/vite` plugin (no PostCSS, no config file)
- **Vite** with `@` path alias → `./src`
- **TypeScript** with project references (app, node, vitest configs)
- **JSX** support via `@vitejs/plugin-vue-jsx`
- **Lucide Vue** for icons, **@vueuse/core** for composables
- **@tanstack/vue-table** for data tables
- **tw-animate-css** for animation utilities

## Architecture

### Routing & Layouts

`src/router/index.ts` defines two top-level route groups:

1. `/login` — Uses `meta.layout: 'AuthLayout'` (currently no layout wrapper, renders standalone)
2. `/` — Renders `DashboardLayout.vue` with nested children:
   - `/dashboard` — Dashboard overview with stat cards and chart placeholders
   - `/apps` — App management table with search, filter, pagination, and edit dialog
   - `/apps/:id` — App detail page

`src/App.vue` is a bare `<RouterView />`. The `DashboardLayout.vue` provides sidebar nav, top header with search/notification/user dropdown, and a `<RouterView />` content area.

### Key Directories

- `src/views/` — Page-level components (Login, Dashboard, AppManagement, AppDetail)
- `src/layouts/` — Layout wrappers (DashboardLayout with sidebar + header)
- `src/components/ui/` — shadcn-vue components (button, card, dialog, dropdown-menu, input, pagination, select, table). Do not edit these directly — regenerate via shadcn CLI if needed.
- `src/lib/utils.ts` — `cn()` helper (clsx + tailwind-merge) used by shadcn components
- `src/stores/` — Pinia stores (composition API style with `defineStore`)
- `src/composables/` — Shared composable functions (use `use` prefix)
- `src/__tests__/` — Unit tests using Vitest + `@vue/test-utils`, jsdom environment

### CSS & Theming

`src/assets/main.css` is the single CSS entry point. It imports Tailwind v4, tw-animate-css, and defines CSS custom properties for light/dark themes using oklch colors. The theme variables (background, foreground, primary, card, sidebar, etc.) are mapped via `@theme inline` for Tailwind usage. Dark mode uses `.dark` class.

### Lint Pipeline

Linting runs in two stages via `npm run lint` (using npm-run-all2):
1. `oxlint` — fast linter (config in `.oxlintrc.json`)
2. `ESLint` — with Vue essential rules, TypeScript recommended, Vitest plugin for test files, and `pluginOxlint` to sync disabled rules from oxlint config

## Code Style

- No semicolons, single quotes, 100 char print width (Prettier)
- 2-space indentation, LF line endings (EditorConfig)
- All components use `<script setup lang="ts">` — no Options API

## Node Version

Requires Node `^20.19.0 || >=22.12.0`
