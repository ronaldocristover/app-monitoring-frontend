<script setup lang="ts">
import { ref } from 'vue'
import { RouterView, RouterLink, useRoute } from 'vue-router'
import { LayoutDashboard, Settings, User, LogOut, Bell, Search, Hexagon } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from '@/components/ui/dropdown-menu'

const route = useRoute()

const navigation = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'App Management', href: '/apps', icon: Settings },
]
</script>

<template>
  <div class="min-h-screen bg-zinc-50 dark:bg-zinc-950 flex flex-col md:flex-row">
    <!-- Sidebar -->
    <aside class="w-full md:w-64 bg-white dark:bg-zinc-900 border-r border-zinc-200 dark:border-zinc-800 flex flex-col transition-all">
      <div class="h-16 flex items-center px-6 border-b border-zinc-200 dark:border-zinc-800">
        <Hexagon class="w-6 h-6 text-indigo-600 dark:text-indigo-400 mr-2" />
        <span class="font-bold text-lg text-zinc-900 dark:text-white tracking-tight">AppMonitor</span>
      </div>
      
      <nav class="flex-1 p-4 space-y-1">
        <RouterLink
          v-for="item in navigation"
          :key="item.name"
          :to="item.href"
          class="flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium transition-colors"
          :class="[
            route.path.startsWith(item.href) 
              ? 'bg-zinc-100 text-zinc-900 dark:bg-zinc-800 dark:text-zinc-50' 
              : 'text-zinc-600 hover:bg-zinc-50 hover:text-zinc-900 dark:text-zinc-400 dark:hover:bg-zinc-800/50 dark:hover:text-zinc-50'
          ]"
        >
          <component :is="item.icon" class="w-5 h-5 flex-shrink-0" />
          {{ item.name }}
        </RouterLink>
      </nav>

      <!-- Bottom User Section -->
      <div class="p-4 border-t border-zinc-200 dark:border-zinc-800">
        <div class="flex items-center gap-3 px-3 py-2">
          <div class="w-8 h-8 rounded-full bg-indigo-100 dark:bg-indigo-900/50 flex items-center justify-center text-indigo-600 dark:text-indigo-400 font-bold">
            A
          </div>
          <div class="flex flex-col">
            <span class="text-sm font-medium text-zinc-900 dark:text-zinc-50">Admin User</span>
            <span class="text-xs text-zinc-500">admin@monitor.app</span>
          </div>
        </div>
      </div>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 flex flex-col min-w-0 overflow-hidden">
      <!-- Top header -->
      <header class="h-16 bg-white dark:bg-zinc-900 border-b border-zinc-200 dark:border-zinc-800 flex items-center justify-between px-6 shrink-0">
        <div class="flex-1 flex items-center">
          <div class="max-w-md w-full relative hidden md:block">
            <Search class="absolute left-2.5 top-2.5 h-4 w-4 text-zinc-500" />
            <input
              type="text"
              placeholder="Search across workspace..."
              class="w-full bg-zinc-50 dark:bg-zinc-800 border-none rounded-md pl-9 pr-4 py-2 text-sm focus:ring-2 focus:ring-indigo-500 focus:outline-none dark:text-zinc-100"
            />
          </div>
        </div>
        
        <div class="flex items-center gap-4">
          <Button variant="ghost" size="icon" class="text-zinc-500 hover:text-zinc-900 dark:hover:text-zinc-50">
            <Bell class="w-5 h-5" />
          </Button>

          <DropdownMenu>
            <DropdownMenuTrigger as-child>
              <Button variant="ghost" size="icon" class="rounded-full">
                <User class="w-5 h-5" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" class="w-56">
              <DropdownMenuLabel>My Account</DropdownMenuLabel>
              <DropdownMenuSeparator />
              <DropdownMenuItem>
                <User class="w-4 h-4 mr-2" />
                Profile
              </DropdownMenuItem>
              <DropdownMenuItem>
                <Settings class="w-4 h-4 mr-2" />
                Settings
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <RouterLink to="/login" class="w-full">
                <DropdownMenuItem class="text-red-600 dark:text-red-400 cursor-pointer">
                  <LogOut class="w-4 h-4 mr-2" />
                  Logout
                </DropdownMenuItem>
              </RouterLink>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </header>

      <!-- Scrollable content area -->
      <div class="flex-1 overflow-auto bg-zinc-50 dark:bg-zinc-950 p-6">
        <div class="w-full">
          <RouterView />
        </div>
      </div>
    </main>
  </div>
</template>
