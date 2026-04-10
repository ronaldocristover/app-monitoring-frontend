<script setup lang="ts">
import { useRoute, useRouter } from 'vue-router'
import { ref } from 'vue'
import cronstrue from 'cronstrue'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { ScrollArea } from '@/components/ui/scroll-area'
import { ArrowLeft, Clock, Tags, Globe, Database, Server, Github, CheckCircle2, AlertCircle, ChevronDown, ChevronUp } from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const fallbackId = route.params.id

// Mock parsed JSON response
const appData = ref({
  id: fallbackId,
  app_name: "E-Commerce Microservices",
  created_at: "2024-01-10T10:00:00Z",
  description: "Main orchestrator for the backend microservices architecture.",
  tags: "production, critical, backend",
  environments: [
    {
      id: "ENV-1",
      name: "Production",
      created_at: "2024-01-11T12:00:00Z",
      services: [
        {
          id: "SRV-1",
          name: "Payment Gateway",
          type: "API",
          stack_language: "Go",
          stack_framework: "Echo",
          url: "api.production.example.com",
          repository: "github.com/org/payment-gateway",
          db_type: "PostgreSQL",
          db_host: "db.internal.example.com",
          server: {
            id: "SER-1",
            name: "us-east-cluster-primary",
            ip: "192.168.1.100",
            provider: "AWS",
          },
          deployments: [
            {
              id: "DEP-1",
              container_name: "payments-svc-prod",
              method: "Docker",
              port: 8080,
              created_at: "2024-04-09T08:30:00Z",
            }
          ],
          backups: [
            {
              id: "BAK-1",
              enabled: true,
              schedule: "0 2 * * *",
              last_backup_time: "2024-04-10T02:00:00Z",
              status: "Success",
              path: "s3://backups/payments"
            }
          ],
          monitoring_logs: [
            {
              id: "LOG-1",
              checked_at: "2024-04-10T12:28:00Z",
              status_code: 200,
              response_time_ms: 45,
              status: "Healthy",
            },
            {
              id: "LOG-2",
              checked_at: "2024-04-10T12:27:00Z",
              status_code: 200,
              response_time_ms: 48,
              status: "Healthy",
            }
          ]
        },
        {
          id: "SRV-2",
          name: "Frontend Storefront",
          type: "Web",
          stack_language: "TypeScript",
          stack_framework: "Next.js",
          url: "shop.example.com",
          repository: "github.com/org/storefront",
          db_type: "None",
          db_host: "N/A",
          server: {
            id: "SER-2",
            name: "vercel-edge",
            ip: "20.120.10.5",
            provider: "Vercel",
          },
          deployments: [
            {
              id: "DEP-2",
              container_name: "N/A",
              method: "Vercel CLI",
              port: 443,
              created_at: "2024-04-09T14:15:00Z",
            }
          ],
          backups: [],
          monitoring_logs: [
            {
              id: "LOG-3",
              checked_at: "2024-04-10T12:30:00Z",
              status_code: 200,
              response_time_ms: 120,
              status: "Healthy",
            }
          ]
        }
      ]
    },
    {
      id: "ENV-2",
      name: "Staging",
      created_at: "2024-01-11T12:00:00Z",
      services: []
    }
  ]
})

const expandedServiceId = ref<string | null>(appData.value.environments[0]?.services[0]?.id || null)

const toggleService = (id: string) => {
  expandedServiceId.value = expandedServiceId.value === id ? null : id
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleString()
}

const formatCron = (cron: string) => {
  try {
    return cronstrue.toString(cron)
  } catch (e) {
    return cron
  }
}
</script>

<template>
  <div class="space-y-8 pb-12">
    <!-- Header Section -->
    <div class="flex flex-col md:flex-row md:items-start justify-between gap-4">
      <div class="flex items-start gap-4">
        <Button variant="outline" size="icon" @click="router.push('/apps')" class="shrink-0">
          <ArrowLeft class="w-4 h-4" />
        </Button>
        <div class="space-y-1">
          <h1 class="text-3xl font-bold tracking-tight text-zinc-900 dark:text-zinc-50">{{ appData.app_name }}</h1>
          <p class="text-base text-zinc-500 dark:text-zinc-400 max-w-2xl">{{ appData.description }}</p>
          
          <div class="flex flex-wrap items-center gap-4 pt-2">
            <div class="flex items-center gap-1.5 text-sm text-zinc-500">
              <Clock class="w-4 h-4" />
              <span>Created {{ formatDate(appData.created_at) }}</span>
            </div>
            <div class="flex items-center gap-2">
              <Tags class="w-4 h-4 text-zinc-500" />
              <div class="flex gap-1.5">
                <Badge variant="secondary" v-for="tag in appData.tags.split(', ')" :key="tag">{{ tag }}</Badge>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Right Side Actions (stub) -->
      <div class="flex items-center gap-3">
        <Button variant="outline">Settings</Button>
      </div>
    </div>

    <!-- Environments Tabs -->
    <Tabs :default-value="appData.environments[0]?.id" class="w-full">
      <TabsList class="mb-4">
        <TabsTrigger v-for="env in appData.environments" :key="env.id" :value="env.id">
          {{ env.name }} Environment
        </TabsTrigger>
      </TabsList>
      
      <TabsContent v-for="env in appData.environments" :key="env.id" :value="env.id" class="space-y-4">
        <div v-if="env.services.length === 0" class="text-center p-12 bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800">
          <p class="text-zinc-500 dark:text-zinc-400">No services deployed to this environment yet.</p>
        </div>

        <!-- Services Table -->
        <div v-else class="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl shadow-sm overflow-hidden">
          <Table>
            <TableHeader class="bg-zinc-50/50 dark:bg-zinc-800/50">
              <TableRow>
                <TableHead class="w-[50px]"></TableHead>
                <TableHead>Service Name</TableHead>
                <TableHead>Type</TableHead>
                <TableHead>Stack</TableHead>
                <TableHead>Server IP</TableHead>
                <TableHead class="text-right">Provider</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <template v-for="service in env.services" :key="service.id">
                <!-- Master Row -->
                <TableRow class="hover:bg-zinc-50 dark:hover:bg-zinc-800/50 cursor-pointer transition-colors" :class="expandedServiceId === service.id ? 'bg-zinc-50/80 dark:bg-zinc-800/40' : ''" @click="toggleService(service.id)">
                  <TableCell>
                    <Button variant="ghost" size="icon" class="h-6 w-6">
                      <ChevronUp v-if="expandedServiceId === service.id" class="h-4 w-4 text-zinc-500" />
                      <ChevronDown v-else class="h-4 w-4 text-zinc-500" />
                    </Button>
                  </TableCell>
                  <TableCell class="font-semibold text-zinc-900 dark:text-zinc-100">
                    {{ service.name }}
                  </TableCell>
                  <TableCell>
                    <div class="flex items-center gap-1.5 text-zinc-600 dark:text-zinc-400">
                      <Server class="w-3.5 h-3.5"/> {{ service.type }}
                    </div>
                  </TableCell>
                  <TableCell>
                    <span class="text-zinc-600 dark:text-zinc-400">{{ service.stack_language }} / {{ service.stack_framework }}</span>
                  </TableCell>
                  <TableCell>
                    <a :href="'http://' + service.server.ip" target="_blank" @click.stop class="text-indigo-600 dark:text-indigo-400 hover:underline font-mono text-sm">
                      {{ service.server.ip }}
                    </a>
                  </TableCell>
                  <TableCell class="text-right">
                    <span class="bg-indigo-50 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-400 px-2 py-0.5 rounded border border-indigo-200 dark:border-indigo-800 text-xs">
                      {{ service.server.provider }}
                    </span>
                  </TableCell>
                </TableRow>

                <!-- Expanded Details Row -->
                <TableRow v-if="expandedServiceId === service.id" class="bg-zinc-50/30 dark:bg-zinc-900/30 border-b border-zinc-200 dark:border-zinc-800 hover:bg-transparent">
                  <TableCell colspan="6" class="p-0">
                    <div class="p-6 md:p-8 space-y-8 animate-in slide-in-from-top-2 fade-in duration-200">
                      <!-- Service Details Grid -->
                      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <div class="space-y-1">
                          <span class="text-xs font-medium text-zinc-500 uppercase tracking-wider">Repository</span>
                          <div class="flex items-center gap-2 text-sm text-zinc-900 dark:text-zinc-100 font-medium">
                            <Github class="w-4 h-4 text-zinc-400"/>
                            <a :href="'https://' + service.repository" target="_blank" class="hover:underline text-indigo-600 dark:text-indigo-400 break-all">
                              {{ service.repository }}
                            </a>
                          </div>
                        </div>
                        
                        <div class="space-y-1">
                          <span class="text-xs font-medium text-zinc-500 uppercase tracking-wider">Public URL</span>
                          <div class="flex items-center gap-2 text-sm text-zinc-900 dark:text-zinc-100 font-medium">
                            <Globe class="w-4 h-4 text-zinc-400"/>
                            <a :href="'https://' + service.url" target="_blank" class="hover:underline text-indigo-600 dark:text-indigo-400 break-all">
                              {{ service.url }}
                            </a>
                          </div>
                        </div>
                        
                        <div class="space-y-1">
                          <span class="text-xs font-medium text-zinc-500 uppercase tracking-wider">Database</span>
                          <div class="flex items-center gap-2 text-sm text-zinc-900 dark:text-zinc-100 font-medium">
                            <Database class="w-4 h-4 text-zinc-400"/>
                            {{ service.db_type }} <span class="text-zinc-500 font-normal">({{ service.db_host }})</span>
                          </div>
                        </div>

                        <div class="space-y-1">
                          <span class="text-xs font-medium text-zinc-500 uppercase tracking-wider">Server Name</span>
                          <div class="text-sm text-zinc-900 dark:text-zinc-100 font-medium">
                            {{ service.server.name }}
                          </div>
                        </div>
                      </div>

                      <!-- Deep Details (Deployments & Logs) -->
                      <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
                        <!-- Left logic: Deployments & Backups -->
                        <div class="space-y-8">
                          <div class="space-y-3">
                            <h4 class="text-sm font-semibold text-zinc-900 dark:text-zinc-100">Recent Deployments</h4>
                            <Table class="border border-zinc-200 dark:border-zinc-800 rounded-md overflow-hidden bg-white dark:bg-zinc-950">
                              <TableHeader class="bg-zinc-100/50 dark:bg-zinc-800/30">
                                <TableRow>
                                  <TableHead class="text-xs py-2 h-auto">Container</TableHead>
                                  <TableHead class="text-xs py-2 h-auto">Method</TableHead>
                                  <TableHead class="text-xs py-2 h-auto">Time</TableHead>
                                </TableRow>
                              </TableHeader>
                              <TableBody>
                                <TableRow v-for="dep in service.deployments" :key="dep.id">
                                  <TableCell class="py-2 text-sm">{{ dep.container_name }}</TableCell>
                                  <TableCell class="py-2 text-sm">{{ dep.method }}</TableCell>
                                  <TableCell class="py-2 text-xs text-zinc-500">{{ formatDate(dep.created_at) }}</TableCell>
                                </TableRow>
                                <TableRow v-if="!service.deployments.length"><TableCell colspan="3" class="text-center text-xs py-4 text-zinc-500">No deployments</TableCell></TableRow>
                              </TableBody>
                            </Table>
                          </div>

                          <div class="space-y-3" v-if="service.backups.length">
                            <h4 class="text-sm font-semibold text-zinc-900 dark:text-zinc-100">Backups Configuration</h4>
                            <Table class="border border-zinc-200 dark:border-zinc-800 rounded-md overflow-hidden bg-white dark:bg-zinc-950">
                              <TableHeader class="bg-zinc-100/50 dark:bg-zinc-800/30">
                                <TableRow>
                                  <TableHead class="text-xs py-2 h-auto">Status</TableHead>
                                  <TableHead class="text-xs py-2 h-auto">Schedule</TableHead>
                                  <TableHead class="text-xs py-2 h-auto">Last Backup</TableHead>
                                </TableRow>
                              </TableHeader>
                              <TableBody>
                                <TableRow v-for="bak in service.backups" :key="bak.id">
                                  <TableCell class="py-2 text-sm font-medium text-emerald-600">{{ bak.status }}</TableCell>
                                  <TableCell class="py-2 text-sm">{{ formatCron(bak.schedule) }} <span class="text-xs text-zinc-400 block border-t mt-1 pt-1 border-dashed">Raw: {{ bak.schedule }}</span></TableCell>
                                  <TableCell class="py-2 text-xs text-zinc-500">{{ formatDate(bak.last_backup_time) }}</TableCell>
                                </TableRow>
                              </TableBody>
                            </Table>
                          </div>
                        </div>

                        <!-- Right logic: Monitoring logs -->
                        <div class="space-y-3 xl:border-l xl:pl-8 border-zinc-200 dark:border-zinc-800">
                          <h4 class="text-sm font-semibold text-zinc-900 dark:text-zinc-100">Monitoring Logs</h4>
                          <div class="border border-zinc-200 dark:border-zinc-800 rounded-md overflow-hidden bg-white dark:bg-zinc-950">
                            <ScrollArea class="h-[300px] w-full">
                              <Table>
                                <TableHeader class="bg-zinc-50/50 dark:bg-zinc-800/50 sticky top-0 border-b border-zinc-200 dark:border-zinc-800 z-10 backdrop-blur-md">
                                  <TableRow>
                                    <TableHead class="text-xs py-2 h-auto">Status</TableHead>
                                    <TableHead class="text-xs py-2 h-auto">Ping</TableHead>
                                    <TableHead class="text-xs py-2 h-auto">Checked At</TableHead>
                                  </TableRow>
                                </TableHeader>
                                <TableBody>
                                  <TableRow v-for="log in service.monitoring_logs" :key="log.id">
                                    <TableCell class="py-2 text-sm">
                                      <div class="flex items-center gap-1.5" :class="log.status === 'Healthy' ? 'text-emerald-600' : 'text-rose-600'">
                                        <CheckCircle2 v-if="log.status === 'Healthy'" class="w-4 h-4"/>
                                        <AlertCircle v-else class="w-4 h-4"/>
                                        {{ log.status }} ({{ log.status_code }})
                                      </div>
                                    </TableCell>
                                    <TableCell class="py-2 text-sm text-zinc-600 dark:text-zinc-400">{{ log.response_time_ms }}ms</TableCell>
                                    <TableCell class="py-2 text-xs text-zinc-500">{{ formatDate(log.checked_at) }}</TableCell>
                                  </TableRow>
                                  <TableRow v-if="!service.monitoring_logs.length"><TableCell colspan="3" class="text-center text-xs py-8 text-zinc-500">No logs generated</TableCell></TableRow>
                                </TableBody>
                              </Table>
                            </ScrollArea>
                          </div>
                        </div>
                      </div>
                    </div>
                  </TableCell>
                </TableRow>
              </template>
            </TableBody>
          </Table>
        </div>
      </TabsContent>
    </Tabs>
  </div>
</template>
