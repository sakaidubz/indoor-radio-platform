# INDOOR RADIO PLATFORM - システムパターン

## 🏛 アーキテクチャパターン

### Clean Architecture
プロジェクトは Clean Architecture パターンを採用し、依存関係を内側に向けて構成します。

```
┌─────────────────────────────────────────────────────────────┐
│                    External Interfaces                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Web UI    │  │   REST API  │  │   External APIs     │ │
│  │  (Vue.js)   │  │   (Gin)     │  │  (X, Instagram)     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                Interface Adapters                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │  Handlers   │  │ Controllers │  │   Repositories      │ │
│  │             │  │             │  │   (Database)        │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                   Use Cases                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Artist    │  │   Episode   │  │   Social Media      │ │
│  │  Services   │  │  Services   │  │    Services         │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Entities                                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Artist    │  │   Episode   │  │    SocialPost       │ │
│  │   Entity    │  │   Entity    │  │     Entity          │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Repository Pattern
データアクセス層の抽象化により、テスタビリティと保守性を向上させます。

```go
// Domain Layer - Interface
type ArtistRepository interface {
    Create(artist *Artist) error
    GetByID(id uint) (*Artist, error)
    GetAll() ([]*Artist, error)
    Update(artist *Artist) error
    Delete(id uint) error
}

// Infrastructure Layer - Implementation
type PostgreSQLArtistRepository struct {
    db *gorm.DB
}

func (r *PostgreSQLArtistRepository) Create(artist *Artist) error {
    return r.db.Create(artist).Error
}
```

## 🔄 データフローパターン

### Request-Response Flow

```
Client Request
    ↓
Middleware (Auth, CORS, Logging)
    ↓
Router (Gin)
    ↓
Handler (HTTP Layer)
    ↓
Service (Business Logic)
    ↓
Repository (Data Access)
    ↓
Database/External API
    ↓
Response (JSON)
```

### Event-Driven Pattern
SNS投稿やアートワーク生成などの非同期処理に使用します。

```go
type Event interface {
    Type() string
    Payload() interface{}
}

type ArtistCreatedEvent struct {
    ArtistID uint
    Name     string
}

type EventBus interface {
    Publish(event Event) error
    Subscribe(eventType string, handler EventHandler) error
}
```

## 🛡 セキュリティパターン

### JWT Authentication Middleware

```go
func JWTAuthMiddleware() gin.HandlerFunc {
    return func(c *gin.Context) {
        token := extractTokenFromHeader(c.GetHeader("Authorization"))
        
        claims, err := validateJWT(token)
        if err != nil {
            c.JSON(401, gin.H{"error": "Unauthorized"})
            c.Abort()
            return
        }
        
        c.Set("user_id", claims.UserID)
        c.Set("role", claims.Role)
        c.Next()
    }
}
```

### Role-Based Access Control

```go
func RequireRole(role string) gin.HandlerFunc {
    return func(c *gin.Context) {
        userRole := c.GetString("role")
        if userRole != role && userRole != "admin" {
            c.JSON(403, gin.H{"error": "Forbidden"})
            c.Abort()
            return
        }
        c.Next()
    }
}
```

## 📁 ファイル管理パターン

### S3 Upload Strategy

```go
type FileUploader interface {
    Upload(file multipart.File, filename string) (string, error)
    Delete(url string) error
}

type S3Uploader struct {
    client *s3.Client
    bucket string
}

func (u *S3Uploader) Upload(file multipart.File, filename string) (string, error) {
    key := fmt.Sprintf("uploads/%s/%s", time.Now().Format("2006/01"), filename)
    
    _, err := u.client.PutObject(context.TODO(), &s3.PutObjectInput{
        Bucket: aws.String(u.bucket),
        Key:    aws.String(key),
        Body:   file,
    })
    
    if err != nil {
        return "", err
    }
    
    return fmt.Sprintf("https://%s.s3.amazonaws.com/%s", u.bucket, key), nil
}
```

## 🔌 外部API統合パターン

### API Client Factory

```go
type SocialMediaClient interface {
    Post(content string, mediaURL string) (*PostResult, error)
    SchedulePost(content string, mediaURL string, scheduledTime time.Time) (*ScheduleResult, error)
}

type ClientFactory struct {
    xClient        *XClient
    instagramClient *InstagramClient
}

func (f *ClientFactory) GetClient(platform string) SocialMediaClient {
    switch platform {
    case "x":
        return f.xClient
    case "instagram":
        return f.instagramClient
    default:
        return nil
    }
}
```

### Circuit Breaker Pattern
外部API呼び出しの信頼性向上のため実装します。

```go
type CircuitBreaker struct {
    maxFailures int
    timeout     time.Duration
    failures    int
    lastFailure time.Time
    state       CircuitState
}

func (cb *CircuitBreaker) Call(fn func() error) error {
    if cb.state == Open {
        if time.Since(cb.lastFailure) > cb.timeout {
            cb.state = HalfOpen
        } else {
            return ErrCircuitOpen
        }
    }
    
    err := fn()
    if err != nil {
        cb.failures++
        cb.lastFailure = time.Now()
        if cb.failures >= cb.maxFailures {
            cb.state = Open
        }
        return err
    }
    
    cb.failures = 0
    cb.state = Closed
    return nil
}
```

## 🎨 フロントエンドパターン

### Composition API Pattern (Vue.js)

```typescript
// composables/useArtist.ts
export function useArtist() {
    const artists = ref<Artist[]>([])
    const loading = ref(false)
    const error = ref<string | null>(null)
    
    const fetchArtists = async () => {
        loading.value = true
        try {
            const response = await api.get('/artists')
            artists.value = response.data
        } catch (err) {
            error.value = 'Failed to fetch artists'
        } finally {
            loading.value = false
        }
    }
    
    return {
        artists: readonly(artists),
        loading: readonly(loading),
        error: readonly(error),
        fetchArtists
    }
}
```

### Store Pattern (Pinia)

```typescript
// stores/artist.ts
export const useArtistStore = defineStore('artist', () => {
    const artists = ref<Artist[]>([])
    const currentArtist = ref<Artist | null>(null)
    
    const addArtist = (artist: Artist) => {
        artists.value.push(artist)
    }
    
    const updateArtist = (updatedArtist: Artist) => {
        const index = artists.value.findIndex(a => a.id === updatedArtist.id)
        if (index !== -1) {
            artists.value[index] = updatedArtist
        }
    }
    
    return {
        artists,
        currentArtist,
        addArtist,
        updateArtist
    }
})
```

## 🧪 テストパターン

### Repository Test Pattern

```go
func TestArtistRepository_Create(t *testing.T) {
    // Setup
    db := setupTestDB()
    repo := NewPostgreSQLArtistRepository(db)
    
    artist := &Artist{
        Name:  "Test Artist",
        Genre: "Electronic",
    }
    
    // Execute
    err := repo.Create(artist)
    
    // Assert
    assert.NoError(t, err)
    assert.NotZero(t, artist.ID)
    
    // Verify in database
    var saved Artist
    db.First(&saved, artist.ID)
    assert.Equal(t, "Test Artist", saved.Name)
}
```

### Service Test Pattern with Mock

```go
func TestArtistService_CreateArtist(t *testing.T) {
    // Setup
    mockRepo := &MockArtistRepository{}
    service := NewArtistService(mockRepo)
    
    mockRepo.On("Create", mock.AnythingOfType("*Artist")).Return(nil)
    
    // Execute
    artist, err := service.CreateArtist("Test Artist", "Electronic")
    
    // Assert
    assert.NoError(t, err)
    assert.Equal(t, "Test Artist", artist.Name)
    mockRepo.AssertExpectations(t)
}
```

## 📊 ログ・監視パターン

### Structured Logging

```go
type Logger interface {
    Info(msg string, fields ...Field)
    Error(msg string, err error, fields ...Field)
    Debug(msg string, fields ...Field)
}

type Field struct {
    Key   string
    Value interface{}
}

func LoggerMiddleware(logger Logger) gin.HandlerFunc {
    return func(c *gin.Context) {
        start := time.Now()
        
        c.Next()
        
        logger.Info("HTTP Request",
            Field{"method", c.Request.Method},
            Field{"path", c.Request.URL.Path},
            Field{"status", c.Writer.Status()},
            Field{"duration", time.Since(start)},
        )
    }
}
```

### Health Check Pattern

```go
type HealthChecker interface {
    Check() error
}

type DatabaseHealthChecker struct {
    db *gorm.DB
}

func (h *DatabaseHealthChecker) Check() error {
    sqlDB, err := h.db.DB()
    if err != nil {
        return err
    }
    return sqlDB.Ping()
}

func HealthCheckHandler(checkers []HealthChecker) gin.HandlerFunc {
    return func(c *gin.Context) {
        status := "healthy"
        checks := make(map[string]string)
        
        for _, checker := range checkers {
            if err := checker.Check(); err != nil {
                status = "unhealthy"
                checks[reflect.TypeOf(checker).String()] = err.Error()
            } else {
                checks[reflect.TypeOf(checker).String()] = "ok"
            }
        }
        
        c.JSON(200, gin.H{
            "status": status,
            "checks": checks,
        })
    }
}
```

## 🔄 データ変換パターン

### DTO Pattern

```go
// Request DTO
type CreateArtistRequest struct {
    Name       string `json:"name" binding:"required"`
    Genre      string `json:"genre"`
    ThemeColor string `json:"theme_color" binding:"hexcolor"`
}

// Response DTO
type ArtistResponse struct {
    ID         uint   `json:"id"`
    Name       string `json:"name"`
    Genre      string `json:"genre"`
    ThemeColor string `json:"theme_color"`
    CreatedAt  string `json:"created_at"`
}

// Mapper
func ToArtistResponse(artist *Artist) *ArtistResponse {
    return &ArtistResponse{
        ID:         artist.ID,
        Name:       artist.Name,
        Genre:      artist.Genre,
        ThemeColor: artist.ThemeColor,
        CreatedAt:  artist.CreatedAt.Format(time.RFC3339),
    }
}
```

これらのパターンにより、保守性、テスタビリティ、拡張性を確保したシステムを構築します。
