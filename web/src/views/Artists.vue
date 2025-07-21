<template>
  <div class="artists">
    <div class="mb-8">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-3xl font-bold text-gray-900 mb-2">Artists</h1>
          <p class="text-gray-600">アーティスト管理</p>
        </div>
        <button class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
          新規アーティスト追加
        </button>
      </div>
    </div>

    <!-- Artists List -->
    <div class="bg-white rounded-lg shadow">
      <div class="px-6 py-4 border-b border-gray-200">
        <h2 class="text-lg font-medium text-gray-900">アーティスト一覧</h2>
      </div>
      <div class="p-6">
        <div v-if="artists.length === 0" class="text-center text-gray-500 py-8">
          <p>登録されたアーティストはありません</p>
          <p class="text-sm mt-2">「新規アーティスト追加」ボタンから追加してください</p>
        </div>
        <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div v-for="artist in artists" :key="artist.id" class="border rounded-lg p-4 hover:shadow-md transition-shadow">
            <div class="flex items-center mb-3">
              <div class="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center">
                <span class="text-lg font-semibold text-gray-600">{{ artist.name.charAt(0) }}</span>
              </div>
              <div class="ml-3">
                <h3 class="font-semibold text-gray-900">{{ artist.name }}</h3>
                <p class="text-sm text-gray-600">{{ artist.genre }}</p>
              </div>
            </div>
            <div class="flex justify-between items-center">
              <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                    :class="getStatusClass(artist.status)">
                {{ getStatusText(artist.status) }}
              </span>
              <div class="flex space-x-2">
                <button class="text-blue-600 hover:text-blue-800 text-sm">編集</button>
                <button class="text-red-600 hover:text-red-800 text-sm">削除</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'

export default {
  name: 'Artists',
  setup() {
    const artists = ref([])

    const loadArtists = async () => {
      // TODO: API呼び出しでデータを取得
      // 現在はダミーデータ
      artists.value = []
    }

    const getStatusClass = (status) => {
      switch (status) {
        case 'active':
          return 'bg-green-100 text-green-800'
        case 'draft':
          return 'bg-yellow-100 text-yellow-800'
        default:
          return 'bg-gray-100 text-gray-800'
      }
    }

    const getStatusText = (status) => {
      switch (status) {
        case 'active':
          return 'アクティブ'
        case 'draft':
          return '下書き'
        default:
          return '不明'
      }
    }

    onMounted(() => {
      loadArtists()
    })

    return {
      artists,
      getStatusClass,
      getStatusText
    }
  }
}
</script>
