# INDOOR RADIO PLATFORM - アクティブコンテキスト

## 🎯 現在の作業フォーカス

### 今日のタスク (2025/7/21)
1. **プロジェクト初期化** ✅ 進行中
   - メモリーバンク構築 ✅ 完了
   - GitHub リポジトリ初期化 🔄 次のステップ
   - Go プロジェクト構造作成 ⏳ 待機中

2. **設計ドキュメント作成** 🔄 進行中
   - システム設計書作成 ⏳ 待機中
   - API仕様書作成 ⏳ 待機中
   - 進捗管理表作成 ⏳ 待機中

## 📋 直近の変更・決定事項

### メモリーバンク構築 (完了)
- `projectbrief.md`: プロジェクト全体の概要と目標を定義
- `productContext.md`: プロダクトビジョンとユーザー体験設計
- `techContext.md`: 技術スタック、アーキテクチャ、AWS構成
- `systemPatterns.md`: 実装パターンとコード設計指針

### 重要な技術決定
1. **アーキテクチャ**: Clean Architecture + Repository Pattern
2. **バックエンド**: Go + Gin + GORM + PostgreSQL
3. **フロントエンド**: Vue.js 3 + Composition API + Tailwind CSS
4. **インフラ**: AWS (EC2 t3.micro + RDS PostgreSQL t3.micro)
5. **認証**: JWT ベース認証
6. **ファイルストレージ**: AWS S3

## 🚀 次のステップ

### 即座に実行すべきタスク

#### 1. GitHub リポジトリ初期化
```bash
# 現在のリモートを削除して新しいリポジトリを設定
git remote remove origin
git remote add origin https://github.com/sakaidubz/indoor-radio-platform.git
git branch -M main
git add .
git commit -m "Initial commit: Project setup with memory bank"
git push -u origin main
```

#### 2. Go プロジェクト構造作成
- `go.mod` 初期化
- ディレクトリ構造作成 (Clean Architecture準拠)
- 基本的な依存関係追加

#### 3. 設計ドキュメント作成
- システム設計書 (`docs/system-design.md`)
- API仕様書 (`docs/api-specification.md`)
- 進捗管理表 (`docs/progress-tracker.md`)

## 🎨 UI/UX 設計方針

### 既存システムからの継承要素
- **シンプルなナビゲーション**: ハンバーガーメニュー + 中央ボタン配置
- **カラーパレット**: 既存のテーマカラーを参考
- **レスポンシブデザイン**: モバイルファーストアプローチ

### 改善ポイント
- **ダッシュボード強化**: 全体概況の可視化
- **進捗表示**: 各配信の準備状況を明確に表示
- **自動化UI**: SNS投稿予約の直感的な操作

## 🔧 開発環境設定

### ローカル開発要件
```bash
# 必要なツール確認
go version    # 1.21+
node --version # 18+
psql --version # 15+
docker --version # 24+
```

### 環境変数テンプレート
```bash
# .env.example として作成予定
DB_HOST=localhost
DB_PORT=5432
DB_USER=indoor_radio
DB_PASSWORD=your_password
DB_NAME=indoor_radio_db
JWT_SECRET=your_jwt_secret_key
AWS_REGION=ap-northeast-1
AWS_S3_BUCKET=indoor-radio-assets
```

## 📊 プロジェクト制約・考慮事項

### 技術的制約
- **AWS コスト**: 月額 $20 以下を維持
- **外部API制限**: 
  - X API: 月300ツイート (Free Tier)
  - Instagram: 1時間200リクエスト
  - SoundCloud: 1時間15,000リクエスト

### ビジネス制約
- **配信スケジュール**: 月1回の固定サイクル
- **既存データ**: 移行不要（新規スタート）
- **運用工数**: 月4時間以内の目標

## 🎯 成功指標の追跡

### 開発フェーズ指標
- [ ] プロジェクト構造完成度: 0%
- [ ] 基本機能実装率: 0%
- [ ] テストカバレッジ: 目標80%
- [ ] ドキュメント完成度: 30% (メモリーバンクのみ)

### 運用フェーズ指標 (将来)
- 配信準備時間短縮: 目標50%
- SNS投稿自動化率: 目標90%
- システム稼働率: 目標99%

## 🔄 学習・洞察

### プロジェクト開始時の重要な洞察
1. **Clean Architecture の採用**: 将来の機能拡張に対応するため
2. **AWS コスト最適化**: t3.micro インスタンスでの運用計画
3. **外部API統合**: Circuit Breaker パターンで信頼性確保
4. **フロントエンド技術**: Vue.js 3 Composition API で保守性向上

### 注意すべきリスク
1. **外部API制限**: 特にX APIの月300ツイート制限
2. **AWS コスト**: 予想以上の利用料発生の可能性
3. **開発スケジュール**: 一人開発での時間管理
4. **データ設計**: 将来の機能拡張を考慮した柔軟性

## 📅 今後のマイルストーン

### Week 1: 基盤構築
- [x] メモリーバンク作成
- [ ] GitHub リポジトリ初期化
- [ ] Go プロジェクト構造
- [ ] 設計ドキュメント

### Week 2: コア機能開発
- [ ] ユーザー認証システム
- [ ] アーティスト管理機能
- [ ] データベース設計・実装

### Week 3: 統合・テスト
- [ ] フロントエンド開発
- [ ] 外部API統合
- [ ] テスト実装

### Week 4: デプロイ・運用
- [ ] AWS環境構築
- [ ] CI/CD パイプライン
- [ ] 本番デプロイ

## 🎪 現在の優先順位

### High Priority
1. GitHub リポジトリの正しい初期化
2. Go プロジェクト構造の作成
3. 基本的な設計ドキュメントの完成

### Medium Priority
1. ローカル開発環境の整備
2. データベース設計の詳細化
3. 外部API連携の調査

### Low Priority
1. UI/UXの詳細デザイン
2. パフォーマンス最適化
3. 高度な監視・ログ機能
