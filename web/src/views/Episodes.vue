<template>
  <div class="episodes">
    <div class="mb-8">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-3xl font-bold text-gray-900 mb-2">Episodes</h1>
          <p class="text-gray-600">エピソード管理</p>
        </div>
        <button class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
          新規エピソード追加
        </button>
      </div>
    </div>

    <!-- Episodes List -->
    <div class="bg-white rounded-lg shadow">
      <div class="px-6 py-4 border-b border-gray-200">
        <h2 class="text-lg font-medium text-gray-900">エピソード一覧</h2>
      </div>
      <div class="p-6">
        <div v-if="episodes.length === 0" class="text-center text-gray-500 py-8">
          <p>登録されたエピソードはありません</p>
          <p class="text-sm mt-2">「新規エピソード追加」ボタンから追加してください</p>
        </div>
        <div v-else class="space-y-4">
          <div v-for="episode in episodes" :key="episode.id" class="border rounded-lg p-4 hover:shadow-md transition-shadow">
            <div class="flex justify-between items-start">
              <div class="flex-1">
                <h3 class="font-semibold text-gray-900 mb-2">{{ episode.title }}</h3>
                <div class="flex items-center space-x-4 text-sm text-gray-600">
                  <span>アーティスト: {{ episode.artist?.name || '未設定' }}</span>
                  <span v-if="episode.scheduled_date">配信予定: {{ formatDate(episode.scheduled_date) }}</span>
                </div>
              </div>
              <div class="flex items-center space-x-3">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                      :class="getStatusClass(episode.status)">
                  {{ getStatusText(episode.status) }}
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
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'

export default {
  name: 'Episodes',
  setup() {
    const episodes = ref([])

    const loadEpisodes = async () => {
      // TODO: API呼び出しでデータを取得
      // 現在はダミーデータ
      episodes.value = []
    }

    const getStatusClass = (status) => {
      switch (status) {
        case 'published':
          return 'bg-green-100 text-green-800'
        case 'scheduled':
          return 'bg-blue-100 text-blue-800'
        case 'planning':
          return 'bg-yellow-100 text-yellow-800'
        default:
          return 'bg-gray-100 text-gray-800'
      }
    }

    const getStatusText = (status) => {
      switch (status) {
        case 'published':
          return '配信済み'
        case 'scheduled':
          return '配信予定'
        case 'planning':
          return '企画中'
        default:
          return '不明'
      }
    }

    const formatDate = (dateString) => {
      if (!dateString) return ''
      const date = new Date(dateString)
      return date.toLocaleDateString('ja-JP')
    }

    onMounted(() => {
      loadEpisodes()
    })

    return {
      episodes,
      getStatusClass,
      getStatusText,
      formatDate
    }
  }
}
</script>
