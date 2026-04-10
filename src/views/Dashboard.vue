<script setup lang="ts">
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Activity, Server, Cpu, HardDrive, ArrowUpRight, ArrowDownRight } from 'lucide-vue-next'

const stats = [
  { name: 'Total Requests', value: '8.2m', change: '+12.5%', trend: 'up', icon: Activity, color: 'text-blue-500' },
  { name: 'Active Servers', value: '42', change: '+2', trend: 'up', icon: Server, color: 'text-indigo-500' },
  { name: 'Avg CPU Usage', value: '64%', change: '-4.1%', trend: 'down', icon: Cpu, color: 'text-amber-500' },
  { name: 'Memory Usage', value: '8.4 GB', change: '+1.2%', trend: 'up', icon: HardDrive, color: 'text-emerald-500' },
]
</script>

<template>
  <div class="space-y-6">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-zinc-900 dark:text-zinc-50">Dashboard Overview</h1>
      <p class="text-zinc-500 dark:text-zinc-400">Welcome back. Here is what's happening with your applications today.</p>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
      <Card v-for="stat in stats" :key="stat.name" class="overflow-hidden border-zinc-200 dark:border-zinc-800 transition-all hover:shadow-md hover:-translate-y-1">
        <CardContent class="p-6">
          <div class="flex items-center justify-between">
            <div class="flex-shrink-0">
              <component :is="stat.icon" class="h-6 w-6" :class="stat.color" />
            </div>
            <div class="flex items-center space-x-1" :class="stat.trend === 'up' ? 'text-emerald-600' : 'text-rose-600'">
              <span class="text-sm font-medium">{{ stat.change }}</span>
              <ArrowUpRight v-if="stat.trend === 'up'" class="h-4 w-4" />
              <ArrowDownRight v-else class="h-4 w-4" />
            </div>
          </div>
          <div class="mt-4">
            <p class="text-sm font-medium text-zinc-500 dark:text-zinc-400">{{ stat.name }}</p>
            <h3 class="text-2xl font-bold text-zinc-900 dark:text-zinc-50 mt-1">{{ stat.value }}</h3>
          </div>
        </CardContent>
      </Card>
    </div>

    <!-- Charts Area placeholders -->
    <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
      <Card class="border-zinc-200 dark:border-zinc-800">
        <CardHeader>
          <CardTitle>Global Traffic</CardTitle>
          <CardDescription>Requests per minute across all regions</CardDescription>
        </CardHeader>
        <CardContent>
          <div class="h-72 w-full bg-zinc-100 dark:bg-zinc-800/50 rounded-md border border-dashed border-zinc-300 dark:border-zinc-700 flex items-center justify-center">
            <span class="text-zinc-500 font-medium">Chart visualization area</span>
          </div>
        </CardContent>
      </Card>
      
      <Card class="border-zinc-200 dark:border-zinc-800">
        <CardHeader>
          <CardTitle>System Errors</CardTitle>
          <CardDescription>Error classifications for the last 24h</CardDescription>
        </CardHeader>
        <CardContent>
          <div class="h-72 w-full bg-zinc-100 dark:bg-zinc-800/50 rounded-md border border-dashed border-zinc-300 dark:border-zinc-700 flex items-center justify-center">
            <span class="text-zinc-500 font-medium">Donut chart area</span>
          </div>
        </CardContent>
      </Card>
    </div>
  </div>
</template>
