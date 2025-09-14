# 🎧 Indoor Radio Platform

![CI](https://github.com/sakaidubz/indoor-radio-platform/actions/workflows/ci.yml/badge.svg?branch=main)

月1回のMix配信プロジェクト「INDOOR RADIO」の運営管理システム

## 📋 概要

このプラットフォームは、SoundCloudで配信されるゲストMixの情報管理と、X（旧Twitter）・Instagramでの配信告知を自動化するためのWebアプリケーションです。

## 🛠 技術スタック

- **Ruby on Rails 7**（モノリス）
- **PostgreSQL**
- **Slim**（テンプレート）+ **jQuery**（最小限のUI補助）
- **Puma**（アプリケーションサーバ）

### インフラ
- **AWS EC2** - アプリケーションサーバー
- **AWS RDS** - データベース
- **AWS S3** - ファイルストレージ

## 🚀 クイックスタート

### 前提条件
- Ruby 3.2+
- PostgreSQL 15+

### 環境変数設定

`.env` ファイルを作成（または `scripts/setup-rails-postgres.sh` で自動生成）し、以下の環境変数を設定してください：

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

### ローカル開発（Rails）

1. リポジトリ取得
```bash
git clone https://github.com/sakaidubz/indoor-radio-platform.git
cd indoor-radio-platform
```

2. Postgres と .env の準備
```bash
# Postgres が未準備ならスクリプトで作成
bash scripts/setup-rails-postgres.sh
```

3. Rails セットアップと起動（Rails はリポジトリ直下に配置）
```bash
bundle install
bin/rails db:create db:migrate
bin/rails server
# http://localhost:3000 （/dashboard, /artists, /episodes）
```

補足: 詳細なRailsの説明は docs/rails-README.md も参照してください。

### トラブルシューティング

#### データベース接続エラー
```
FATAL: role "indoor_radio" does not exist
```
このエラーが出た場合は、データベースセットアップスクリプトを実行してください：
```bash
./scripts/setup-rails-postgres.sh
```

#### PostgreSQLが起動していない場合
```bash
# macOS
brew services start postgresql

# Ubuntu
sudo systemctl start postgresql
```

## 📁 プロジェクト構造（Rails）

```
indoor-radio-platform/
├── app/                 # MVC, assets (Slim/jQuery)
├── bin/                 # Rails 実行スクリプト
├── config/              # ルーティング・DB設定
├── db/                  # マイグレーション
├── log/                 # ログ
├── storage/             # ActiveStorage 等
├── tmp/                 # 一時ファイル
├── scripts/
│   └── setup-rails-postgres.sh  # Postgresと.envの初期化
├── docs/                # ドキュメント（docs/rails-README.md など）
└── memory-bank/         # プロジェクトメモ
```

## 🎯 主要機能

### ✅ 実装済み
- [x] プロジェクト基盤構築
- [x] Clean Architecture設計
- [x] データベース設計
- [x] 基本的なAPI構造

### 🔄 開発中
- [ ] Rails上での機能拡充（認証/管理UI）

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

## 🧪 テスト（Rails / RSpec）

```bash
# 依存関係のインストール・DB準備は bin/setup で一括
bin/setup

# RSpec 実行
bundle exec rspec
```

## 📊 開発進捗

現在の進捗状況は [memory-bank/progress.md](memory-bank/progress.md) で確認できます。

## 🔁 CI（GitHub Actions）

main と Pull Request に対し、自動で以下を実行します：
- Ruby 3.2.2 のセットアップ + bundler cache
- PostgreSQL サービス起動（test 環境）
- `rails db:prepare` によるDB初期化
- 簡易スモークテスト（`rails about`）とテスト実行（テストが存在すれば）

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
