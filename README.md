# 🎧 Indoor Radio Platform

月1回のMix配信プロジェクト「INDOOR RADIO」の運営管理システム

## 📋 概要

このプラットフォームは、SoundCloudで配信されるゲストMixの情報管理と、X（旧Twitter）・Instagramでの配信告知を自動化するためのWebアプリケーションです。

## 🛠 技術スタック

### バックエンド
- **Go** 1.22+
- **Gin** - HTTP Web Framework
- **GORM** - ORM
- **PostgreSQL** - データベース

### フロントエンド
- **Vue.js 3** - フロントエンドフレームワーク
- **Tailwind CSS** - CSSフレームワーク
- **Pinia** - 状態管理

### インフラ
- **AWS EC2** - アプリケーションサーバー
- **AWS RDS** - データベース
- **AWS S3** - ファイルストレージ

## 🚀 クイックスタート

### 前提条件
- Go 1.22+
- Node.js 18+
- PostgreSQL 15+
- Docker (オプション)

### 環境変数設定

`.env` ファイルを作成し、以下の環境変数を設定してください：

```bash
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=indoor_radio
DB_PASSWORD=your_password
DB_NAME=indoor_radio_db
DB_SSL_MODE=disable

# JWT
JWT_SECRET=your_jwt_secret_key

# AWS
AWS_REGION=ap-northeast-1
AWS_S3_BUCKET=indoor-radio-assets

# External APIs
X_API_KEY=your_x_api_key
X_API_SECRET=your_x_api_secret
INSTAGRAM_ACCESS_TOKEN=your_instagram_token
SOUNDCLOUD_CLIENT_ID=your_soundcloud_client_id
```

### ローカル開発

1. **リポジトリのクローン**
```bash
git clone https://github.com/sakaidubz/indoor-radio-platform.git
cd indoor-radio-platform
```

2. **依存関係のインストール**
```bash
# Go dependencies
go mod tidy

# Frontend dependencies (将来実装)
cd web && npm install
```

3. **データベースの準備**
```bash
# PostgreSQLデータベースを作成
createdb indoor_radio_db
```

4. **アプリケーションの起動**
```bash
# バックエンドサーバーの起動
go run cmd/server/main.go

# フロントエンド開発サーバーの起動 (将来実装)
cd web && npm run dev
```

## 📁 プロジェクト構造

```
indoor-radio-platform/
├── cmd/
│   └── server/              # アプリケーションエントリーポイント
├── internal/
│   ├── api/                 # HTTP API層
│   │   ├── handlers/        # HTTPハンドラー
│   │   ├── middleware/      # ミドルウェア
│   │   └── routes/          # ルーティング
│   ├── domain/              # ドメイン層
│   │   ├── entities/        # エンティティ
│   │   ├── repositories/    # リポジトリインターフェース
│   │   └── services/        # ビジネスロジック
│   ├── infrastructure/      # インフラ層
│   │   ├── database/        # データベース
│   │   ├── external/        # 外部API
│   │   └── storage/         # ファイルストレージ
│   └── config/              # 設定管理
├── web/                     # フロントエンド
├── deployments/             # デプロイ設定
├── docs/                    # ドキュメント
├── memory-bank/             # プロジェクト管理ドキュメント
└── scripts/                 # ビルド・デプロイスクリプト
```

## 🎯 主要機能

### ✅ 実装済み
- [x] プロジェクト基盤構築
- [x] Clean Architecture設計
- [x] データベース設計
- [x] 基本的なAPI構造

### 🔄 開発中
- [ ] ユーザー認証システム
- [ ] アーティスト管理機能
- [ ] エピソード管理機能
- [ ] SNS投稿管理機能

### ⏳ 予定
- [ ] アートワーク自動生成
- [ ] フロントエンド実装
- [ ] AWS環境構築
- [ ] CI/CD パイプライン

## 🔌 API エンドポイント

### 認証
- `POST /api/v1/auth/login` - ログイン
- `POST /api/v1/auth/register` - ユーザー登録

### アーティスト管理
- `GET /api/v1/artists` - アーティスト一覧取得
- `POST /api/v1/artists` - アーティスト作成
- `GET /api/v1/artists/:id` - アーティスト詳細取得
- `PUT /api/v1/artists/:id` - アーティスト更新
- `DELETE /api/v1/artists/:id` - アーティスト削除

### エピソード管理
- `GET /api/v1/episodes` - エピソード一覧取得
- `POST /api/v1/episodes` - エピソード作成
- `GET /api/v1/episodes/:id` - エピソード詳細取得
- `PUT /api/v1/episodes/:id` - エピソード更新
- `DELETE /api/v1/episodes/:id` - エピソード削除

### SNS投稿管理
- `GET /api/v1/social/posts` - 投稿一覧取得
- `POST /api/v1/social/posts` - 投稿作成
- `POST /api/v1/social/posts/:id/schedule` - 投稿スケジュール

## 🧪 テスト

```bash
# 全テスト実行
go test ./...

# カバレッジ付きテスト実行
go test -cover ./...
```

## 📊 開発進捗

現在の進捗状況は [memory-bank/progress.md](memory-bank/progress.md) で確認できます。

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add some amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 📞 サポート

質問や問題がある場合は、GitHubのIssuesを作成してください。

---

**Indoor Radio Platform** - Mix配信を、もっとスマートに 🎵
