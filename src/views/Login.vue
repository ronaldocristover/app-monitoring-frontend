<script setup lang="ts">
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Hexagon, Lock, Mail } from 'lucide-vue-next'
import { useRouter } from 'vue-router'

const router = useRouter()

const handleLogin = () => {
  // Simulate login
  router.push('/dashboard')
}
</script>

<template>
  <div class="min-h-screen bg-zinc-50 dark:bg-zinc-950 flex flex-col justify-center py-12 sm:px-6 lg:px-8 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] dark:bg-[url('https://www.transparenttextures.com/patterns/stardust.png')]">
    <div class="sm:mx-auto sm:w-full sm:max-w-md backdrop-blur-sm">
      <div class="flex justify-center">
        <div class="rounded-full bg-indigo-600/10 p-3 ring-1 ring-indigo-600/20">
          <Hexagon class="h-10 w-10 text-indigo-600 dark:text-indigo-400" />
        </div>
      </div>
      <h2 class="mt-6 text-center text-3xl font-extrabold tracking-tight text-zinc-900 dark:text-white">
        Welcome back
      </h2>
      <p class="mt-2 text-center text-sm text-zinc-600 dark:text-zinc-400">
        Sign in to access your AppMonitor dashboard
      </p>
    </div>

    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
      <Card class="border-zinc-200 dark:border-zinc-800 shadow-xl bg-white/80 dark:bg-zinc-900/80 backdrop-blur-md">
        <CardContent class="pt-6">
          <form @submit.prevent="handleLogin" class="space-y-6">
            <div>
              <label for="email" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Email address
              </label>
              <div class="mt-1 relative rounded-md shadow-sm">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Mail class="h-4 w-4 text-zinc-400" />
                </div>
                <Input
                  id="email"
                  type="email"
                  required
                  placeholder="admin@monitor.app"
                  class="pl-10"
                />
              </div>
            </div>

            <div>
              <label for="password" class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Password
              </label>
              <div class="mt-1 relative rounded-md shadow-sm">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <Lock class="h-4 w-4 text-zinc-400" />
                </div>
                <Input
                  id="password"
                  type="password"
                  required
                  placeholder="••••••••"
                  class="pl-10"
                />
              </div>
            </div>

            <div class="flex items-center justify-between">
              <div class="flex items-center">
                <input
                  id="remember-me"
                  name="remember-me"
                  type="checkbox"
                  class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-zinc-300 rounded"
                />
                <label for="remember-me" class="ml-2 block text-sm text-zinc-900 dark:text-zinc-300">
                  Remember me
                </label>
              </div>

              <div class="text-sm">
                <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500 dark:text-indigo-400">
                  Forgot your password?
                </a>
              </div>
            </div>

            <div>
              <Button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white shadow-md transition-transform hover:-translate-y-0.5">
                Sign in
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  </div>
</template>
