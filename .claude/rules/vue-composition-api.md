# Vue Composition API Rules

All Vue components in this project MUST use Composition API with `<script setup lang="ts">`. No Options API.

## Component Structure

```vue
<script setup lang="ts">
// 1. Imports (vue, libraries, composables, types)
import { ref, computed, onMounted } from 'vue'

// 2. Props & Emits
const props = defineProps<{ count: number }>()
const emit = defineEmits<{ update: [value: number] }>()

// 3. Reactive state
const isLoading = ref(false)

// 4. Computed properties
const doubled = computed(() => props.count * 2)

// 5. Methods / functions
function handleClick() { ... }

// 6. Lifecycle hooks
onMounted(() => { ... })

// 7. Watchers (if needed)
</script>

<template>
  ...
</template>

<style scoped>
...
</style>
```

## Reactivity

- Use `ref()` for primitives and `reactive()` for objects. Prefer `ref()` as the default.
- Access ref values with `.value` in `<script>`, but NOT in `<template>` (auto-unwrapped).
- Use `computed()` for derived state. Never compute derived values with `watch`.
- Use `watch()` or `watchEffect()` for side effects. Prefer `watch()` with explicit source for clarity.

```ts
// Correct
const count = ref(0)
const doubled = computed(() => count.value * 2)

// Wrong - don't use reactive for primitives
const count = reactive({ value: 0 })
```

## Props & Emits

Use type-based declaration (not runtime). This project uses TypeScript.

```ts
// Props with defaults
const props = withDefaults(defineProps<{
  title: string
  count?: number
}>(), {
  count: 0,
})

// Emits
const emit = defineEmits<{
  change: [value: string]
  delete: [id: number]
}>()
```

## Composables (Logic Reuse)

Extract reusable logic into composable functions under `src/composables/`.

```ts
// src/composables/useCounter.ts
import { ref, computed } from 'vue'

export function useCounter(initial = 0) {
  const count = ref(initial)
  const doubled = computed(() => count.value * 2)
  function increment() { count.value++ }
  return { count, doubled, increment }
}
```

Name composables with `use` prefix. Return reactive refs and functions.

## Lifecycle Hooks

Use Composition API lifecycle hooks, not Options API equivalents:

| Options API       | Composition API      |
|-------------------|----------------------|
| `created`         | (runs in setup body) |
| `mounted`         | `onMounted()`        |
| `updated`         | `onUpdated()`        |
| `unmounted`       | `onUnmounted()`      |
| `beforeUnmount`   | `onBeforeUnmount()`  |

## What to Avoid

- **No Options API**: No `data()`, `methods`, `computed: {}`, `watch: {}`, `mounted()`, etc.
- **No `this`**: Composition API with `<script setup>` has no component instance `this`.
- **No mixins**: Use composables instead.
- **No `reactive()` for primitives**: Use `ref()` for primitives.
- **No `watch` for derived state**: Use `computed()` instead.
- **No `defineComponent`**: Use `<script setup>` — it's more concise and performant.

## Template Refs

```ts
const inputRef = ref<HTMLInputElement | null>(null)

onMounted(() => {
  inputRef.value?.focus()
})
```

```html
<input ref="inputRef" />
```

## TypeScript

- All props, emits, and refs should be typed.
- Use `defineProps<T>()` and `defineEmits<T>()` with generic type arguments.
- Prefer type imports: `import type { Foo } from './types'`
