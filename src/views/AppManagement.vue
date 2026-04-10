<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from '@/components/ui/breadcrumb'
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationFirst,
  PaginationItem,
  PaginationLast,
  PaginationNext,
  PaginationPrevious,
} from '@/components/ui/pagination'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Search, MoreHorizontal, Activity, ArrowUpDown } from 'lucide-vue-next'

// Mock Data
const applications = ref(Array.from({ length: 45 }).map((_, i) => ({
  id: `APP-${1000 + i}`,
  name: `Production Service ${i + 1}`,
  environment: ['Production', 'Staging', 'Development'][i % 3],
  status: ['Healthy', 'Warning', 'Critical'][Math.floor(Math.random() * 3)],
  cpu: Math.floor(Math.random() * 100) + '%',
  memory: (Math.random() * 4 + 0.5).toFixed(1) + ' GB',
  lastDeployed: new Date(Date.now() - Math.floor(Math.random() * 10000000000)).toISOString().split('T')[0],
})))

// State
const router = useRouter()
const isEditOpen = ref(false)
const selectedApp = ref<any>(null)

const handleEdit = (app: any) => {
  selectedApp.value = { ...app } // Copy to avoid immediately mutating table
  isEditOpen.value = true
}

const handleView = (app: any) => {
  router.push(`/apps/${app.id}`)
}

const searchQuery = ref('')
const statusFilter = ref('All')
const currentPage = ref(1)
const itemsPerPage = 10

// Computed
const filteredApps = computed(() => {
  return applications.value.filter(app => {
    const matchesSearch = app.name.toLowerCase().includes(searchQuery.value.toLowerCase()) || 
                          app.id.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchesFilter = statusFilter.value === 'All' || app.status === statusFilter.value
    return matchesSearch && matchesFilter
  })
})

const totalItems = computed(() => filteredApps.value.length)
const totalPages = computed(() => Math.ceil(totalItems.value / itemsPerPage))

const paginatedApps = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredApps.value.slice(start, end)
})

const getStatusColor = (status: string) => {
  switch(status) {
    case 'Healthy': return 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-400 border-emerald-200 dark:border-emerald-800'
    case 'Warning': return 'bg-amber-100 text-amber-800 dark:bg-amber-900/30 dark:text-amber-400 border-amber-200 dark:border-amber-800'
    case 'Critical': return 'bg-rose-100 text-rose-800 dark:bg-rose-900/30 dark:text-rose-400 border-rose-200 dark:border-rose-800'
    default: return 'bg-zinc-100 text-zinc-800 border-zinc-200'
  }
}
</script>

<template>
  <div class="space-y-6">
    <!-- Breadcrumb -->
    <Breadcrumb>
      <BreadcrumbList>
        <BreadcrumbItem>
          <BreadcrumbLink href="/dashboard">Dashboard</BreadcrumbLink>
        </BreadcrumbItem>
        <BreadcrumbSeparator />
        <BreadcrumbItem>
          <BreadcrumbPage>Application Management</BreadcrumbPage>
        </BreadcrumbItem>
      </BreadcrumbList>
    </Breadcrumb>

    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold tracking-tight text-zinc-900 dark:text-zinc-50">Applications</h1>
        <p class="text-sm text-zinc-500 dark:text-zinc-400">Manage and monitor all your deployed applications.</p>
      </div>
      <Button class="bg-indigo-600 hover:bg-indigo-700 text-white">Create Application</Button>
    </div>

    <!-- Controls Bar -->
    <div class="bg-white dark:bg-zinc-900 p-4 rounded-xl border border-zinc-200 dark:border-zinc-800 flex flex-col sm:flex-row gap-4 justify-between items-center shadow-sm">
      <div class="relative w-full sm:w-72">
        <Search class="absolute left-2.5 top-2.5 h-4 w-4 text-zinc-500" />
        <Input 
          v-model="searchQuery" 
          placeholder="Search applications..." 
          class="pl-9 bg-zinc-50 dark:bg-zinc-800/50" 
        />
      </div>
      
      <div class="flex items-center gap-3 w-full sm:w-auto">
        <Select v-model="statusFilter">
          <SelectTrigger class="w-full sm:w-[180px] bg-zinc-50 dark:bg-zinc-800/50">
            <SelectValue placeholder="Filter by status" />
          </SelectTrigger>
          <SelectContent>
            <SelectGroup>
              <SelectLabel>Status</SelectLabel>
              <SelectItem value="All">All Statuses</SelectItem>
              <SelectItem value="Healthy">Healthy</SelectItem>
              <SelectItem value="Warning">Warning</SelectItem>
              <SelectItem value="Critical">Critical</SelectItem>
            </SelectGroup>
          </SelectContent>
        </Select>
      </div>
    </div>

    <!-- Table -->
    <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 shadow-sm overflow-hidden">
      <Table>
        <TableHeader class="bg-zinc-50/50 dark:bg-zinc-800/50">
          <TableRow>
            <TableHead class="w-[100px]">App ID</TableHead>
            <TableHead>
              <div class="flex items-center gap-1 cursor-pointer hover:text-zinc-900 dark:hover:text-zinc-300">
                Name <ArrowUpDown class="h-3 w-3" />
              </div>
            </TableHead>
            <TableHead>Environment</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Metrics</TableHead>
            <TableHead>Last Deployed</TableHead>
            <TableHead class="text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          <TableRow v-for="app in paginatedApps" :key="app.id" class="hover:bg-zinc-50/50 dark:hover:bg-zinc-800/30 transition-colors">
            <TableCell class="font-medium text-zinc-500 dark:text-zinc-400">{{ app.id }}</TableCell>
            <TableCell>
              <div class="font-medium text-zinc-900 dark:text-zinc-100">{{ app.name }}</div>
            </TableCell>
            <TableCell>
              <span class="inline-flex items-center px-2 py-1 rounded-md text-xs font-medium bg-zinc-100 text-zinc-700 dark:bg-zinc-800 dark:text-zinc-300">
                {{ app.environment }}
              </span>
            </TableCell>
            <TableCell>
              <span 
                class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium border"
                :class="getStatusColor(app.status)"
              >
                <span class="w-1.5 h-1.5 rounded-full mr-1.5" :class="app.status === 'Healthy' ? 'bg-emerald-500' : (app.status === 'Warning' ? 'bg-amber-500' : 'bg-rose-500')"></span>
                {{ app.status }}
              </span>
            </TableCell>
            <TableCell>
              <div class="flex items-center gap-3 text-xs text-zinc-500">
                <span class="flex items-center gap-1"><Activity class="h-3 w-3" /> {{ app.cpu }}</span>
                <span>{{ app.memory }}</span>
              </div>
            </TableCell>
            <TableCell class="text-zinc-500 text-sm">
              {{ app.lastDeployed }}
            </TableCell>
            <TableCell class="text-right">
              <DropdownMenu>
                <DropdownMenuTrigger as-child>
                  <Button variant="ghost" size="icon" class="h-8 w-8 text-zinc-500">
                    <MoreHorizontal class="h-4 w-4" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end">
                  <DropdownMenuItem @click="handleView(app)" class="cursor-pointer">
                    View
                  </DropdownMenuItem>
                  <DropdownMenuItem @click="handleEdit(app)" class="cursor-pointer">
                    Edit
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </TableCell>
          </TableRow>
          
          <TableRow v-if="paginatedApps.length === 0">
            <TableCell colspan="7" class="h-32 text-center text-zinc-500">
              No applications found matching your criteria.
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>
      
      <!-- Pagination -->
      <div class="border-t border-zinc-200 dark:border-zinc-800 p-4 flex items-center justify-between">
        <span class="text-sm text-zinc-500">
          Showing <strong>{{ (currentPage - 1) * itemsPerPage + 1 }}</strong> to <strong>{{ Math.min(currentPage * itemsPerPage, totalItems) }}</strong> of <strong>{{ totalItems }}</strong> results
        </span>
        
        <Pagination v-slot="{ page }" :total="totalItems" :sibling-count="1" show-edges :default-page="1" :items-per-page="itemsPerPage" @update:page="p => currentPage = p">
          <PaginationContent>
            <PaginationFirst @click="currentPage = 1" />
            <PaginationPrevious @click="currentPage > 1 ? currentPage-- : null" />

            <template v-for="(item, index) in totalPages" :key="index">
              <!-- Simply showing a few pages to avoid complex ellipsis logic in mock -->
              <PaginationItem v-if="Math.abs(item - currentPage) <= 2">
                <Button 
                  :variant="item === currentPage ? 'default' : 'outline'"
                  class="w-9 h-9 p-0"
                  @click="currentPage = item"
                >
                   {{ item }}
                </Button>
              </PaginationItem>
            </template>

            <PaginationNext @click="currentPage < totalPages ? currentPage++ : null" />
            <PaginationLast @click="currentPage = totalPages" />
          </PaginationContent>
        </Pagination>
      </div>
    </div>

    <!-- Edit Dialog -->
    <Dialog v-model:open="isEditOpen">
      <DialogContent class="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Edit Application</DialogTitle>
          <DialogDescription>
            Make changes to the configuration of {{ selectedApp?.name }} ({{ selectedApp?.id }}).
          </DialogDescription>
        </DialogHeader>
        <div class="grid gap-4 py-4" v-if="selectedApp">
          <div class="grid grid-cols-4 items-center gap-4">
            <span class="text-sm font-medium text-right">Name</span>
            <Input v-model="selectedApp.name" class="col-span-3" />
          </div>
          <div class="grid grid-cols-4 items-center gap-4">
            <span class="text-sm font-medium text-right">Environment</span>
            <Select v-model="selectedApp.environment">
              <SelectTrigger class="col-span-3">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectItem value="Production">Production</SelectItem>
                  <SelectItem value="Staging">Staging</SelectItem>
                  <SelectItem value="Development">Development</SelectItem>
                </SelectGroup>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button type="button" @click="isEditOpen = false">Save changes</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>
