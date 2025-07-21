# INDOOR RADIO PLATFORM - 技術コンテキスト

## 🛠 技術スタック

### バックエンド
- **言語**: Go 1.21+
- **フレームワーク**: Gin (HTTP router)
- **ORM**: GORM (Go Object Relational Mapping)
- **認証**: JWT (JSON Web Tokens)
- **バリデーション**: go-playground/validator

### データベース
- **メイン**: PostgreSQL 15 (AWS RDS)
- **キャッシュ**: Redis (ElastiCache - 必要に応じて)
- **ファイルストレージ**: AWS S3

### フロントエンド
- **フレームワーク**: Vue.js 3 + Composition API
- **UI**: Tailwind CSS
- **状態管理**: Pinia
- **HTTP クライアント**: Axios
- **ビルドツール**: Vite

### インフラストラクチャ (AWS)
- **コンピュート**: EC2 t3.micro (Free Tier対象)
- **データベース**: RDS PostgreSQL t3.micro
- **ストレージ**: S3 Standard
- **ネットワーク**: VPC, Security Groups
- **ロードバランサー**: Application Load Balancer (必要に応じて)
- **SSL**: AWS Certificate Manager

## 🏗 アーキテクチャ設計

### システム構成図

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   (Vue.js)      │◄──►│   (Go/Gin)      │◄──►│   (PostgreSQL)  │
│   Port: 3000    │    │   Port: 8080    │    │   Port: 5432    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   AWS S3        │    │   External APIs │    │   File System   │
│   (Static Files)│    │   - X API       │    │   (Temp Files)  │
│                 │    │   - Instagram   │    │                 │
│                 │    │   - SoundCloud  │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### ディレクトリ構造

```
indoor-radio-platform/
├── cmd/
│   └── server/
│       └── main.go              # アプリケーションエントリーポイント
├── internal/
│   ├── api/
│   │   ├── handlers/            # HTTPハンドラー
│   │   ├── middleware/          # ミドルウェア
│   │   └── routes/              # ルーティング設定
│   ├── domain/
│   │   ├── entities/            # ドメインエンティティ
│   │   ├── repositories/        # リポジトリインターフェース
│   │   └── services/            # ビジネスロジック
│   ├── infrastructure/
│   │   ├── database/            # データベース接続・マイグレーション
│   │   ├── external/            # 外部API連携
│   │   └── storage/             # ファイルストレージ
│   └── config/                  # 設定管理
├── web/
│   ├── src/
│   │   ├── components/          # Vueコンポーネント
│   │   ├── views/               # ページコンポーネント
│   │   ├── stores/              # Pinia ストア
│   │   └── utils/               # ユーティリティ
│   ├── public/                  # 静的ファイル
│   └── package.json
├── deployments/
│   ├── docker/                  # Docker設定
│   └── aws/                     # AWS CloudFormation/Terraform
├── docs/                        # ドキュメント
├── scripts/                     # ビルド・デプロイスクリプト
└── go.mod
```

## 🔧 開発環境

### 必要なツール
- **Go**: 1.21+
- **Node.js**: 18+
- **PostgreSQL**: 15+ (ローカル開発用)
- **Docker**: 24+ (コンテナ化)
- **AWS CLI**: 2.0+ (デプロイ用)

### 環境変数設定

```bash
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=indoor_radio
DB_PASSWORD=your_password
DB_NAME=indoor_radio_db

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

## 📊 データベース設計

### 主要テーブル

#### users (ユーザー管理)
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'editor',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### artists (アーティスト情報)
```sql
CREATE TABLE artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    theme_color VARCHAR(7), -- HEXカラーコード
    bio TEXT,
    photo_url VARCHAR(255),
    logo_url VARCHAR(255),
    x_id VARCHAR(50),
    instagram_id VARCHAR(50),
    soundcloud_id VARCHAR(50),
    other_links TEXT,
    status VARCHAR(20) DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### episodes (配信エピソード)
```sql
CREATE TABLE episodes (
    id SERIAL PRIMARY KEY,
    artist_id INTEGER REFERENCES artists(id),
    title VARCHAR(200) NOT NULL,
    scheduled_date DATE,
    soundcloud_url VARCHAR(255),
    artwork_url VARCHAR(255),
    status VARCHAR(20) DEFAULT 'planning',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### social_posts (SNS投稿管理)
```sql
CREATE TABLE social_posts (
    id SERIAL PRIMARY KEY,
    episode_id INTEGER REFERENCES episodes(id),
    platform VARCHAR(20) NOT NULL, -- 'x' or 'instagram'
    content TEXT NOT NULL,
    scheduled_at TIMESTAMP,
    posted_at TIMESTAMP,
    post_id VARCHAR(100), -- プラットフォーム側のID
    status VARCHAR(20) DEFAULT 'scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🔌 外部API連携

### X (Twitter) API v2
- **認証**: OAuth 2.0
- **機能**: ツイート投稿、メディアアップロード
- **制限**: 月300ツイート (Free Tier)

### Instagram Basic Display API
- **認証**: OAuth 2.0
- **機能**: 投稿、ストーリー投稿
- **制限**: 1時間あたり200リクエスト

### SoundCloud API
- **認証**: OAuth 2.0
- **機能**: トラック情報取得、再生数確認
- **制限**: 1時間あたり15,000リクエスト

## 💰 AWS コスト見積もり

### 月額料金 (東京リージョン)

| サービス | 仕様 | 月額料金 |
|---------|------|----------|
| EC2 t3.micro | 1vCPU, 1GB RAM | $8.50 |
| RDS PostgreSQL t3.micro | 1vCPU, 1GB RAM, 20GB | $12.60 |
| S3 Standard | 5GB ストレージ | $0.12 |
| データ転送 | 1GB/月 | $0.09 |
| **合計** | | **$21.31** |

### コスト最適化案
- **EC2**: Reserved Instance (1年契約) で30%削減
- **RDS**: Multi-AZ無効化で50%削減
- **S3**: Intelligent Tiering で20%削減
- **目標月額**: $15以下

## 🚀 デプロイメント戦略

### CI/CD パイプライン
1. **GitHub Actions** でビルド・テスト自動化
2. **Docker** でアプリケーションコンテナ化
3. **AWS ECR** でコンテナイメージ管理
4. **AWS ECS** または **EC2** でデプロイ

### 環境構成
- **Development**: ローカル環境
- **Staging**: AWS EC2 (本番同等環境)
- **Production**: AWS EC2 (本番環境)

## 🔒 セキュリティ考慮事項

### 認証・認可
- JWT トークンベース認証
- ロールベースアクセス制御 (RBAC)
- パスワードハッシュ化 (bcrypt)

### データ保護
- HTTPS通信の強制
- 機密情報の環境変数管理
- データベース接続の暗号化
- ファイルアップロードの検証

### AWS セキュリティ
- Security Groups での通信制限
- IAM ロールでの最小権限原則
- VPC での ネットワーク分離
- CloudWatch でのログ監視
