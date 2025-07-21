package routes

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sakaidubz/indoor-radio-platform/internal/api/handlers"
	"github.com/sakaidubz/indoor-radio-platform/internal/api/middleware"
	"github.com/sakaidubz/indoor-radio-platform/internal/config"
	"github.com/sakaidubz/indoor-radio-platform/internal/domain/repositories"
	"github.com/sakaidubz/indoor-radio-platform/internal/domain/services"
	"gorm.io/gorm"
)

// SetupRoutes sets up all routes for the application
func SetupRoutes(router *gin.Engine, db *gorm.DB, cfg *config.Config) {
	// Add CORS middleware
	router.Use(middleware.CORS())

	// Initialize services and repositories
	authService := services.NewAuthService(cfg.JWT.Secret)
	userRepo := repositories.NewUserRepository(db)
	authHandler := handlers.NewAuthHandler(userRepo, authService)

	// Health check endpoint
	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "healthy",
			"message": "Indoor Radio Platform API is running",
		})
	})

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		// Authentication routes (public)
		auth := v1.Group("/auth")
		{
			auth.POST("/login", authHandler.Login)
			auth.POST("/register", authHandler.Register)
			auth.POST("/logout", authHandler.Logout)
		}

		// Protected routes
		protected := v1.Group("")
		protected.Use(middleware.AuthMiddleware(authService))
		{
			// User profile routes
			protected.GET("/profile", authHandler.GetProfile)
			protected.PUT("/profile", authHandler.UpdateProfile)
			protected.POST("/change-password", authHandler.ChangePassword)
		}

		// Artists routes (protected)
		artists := protected.Group("/artists")
		{
			artists.GET("", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Get artists - TODO"})
			})
			artists.POST("", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Create artist - TODO"})
			})
			artists.GET("/:id", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Get artist by ID - TODO"})
			})
			artists.PUT("/:id", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Update artist - TODO"})
			})
			artists.DELETE("/:id", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Delete artist - TODO"})
			})
		}

		// Episodes routes (protected)
		episodes := protected.Group("/episodes")
		{
			episodes.GET("", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Get episodes - TODO"})
			})
			episodes.POST("", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Create episode - TODO"})
			})
			episodes.GET("/:id", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Get episode by ID - TODO"})
			})
			episodes.PUT("/:id", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Update episode - TODO"})
			})
			episodes.DELETE("/:id", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Delete episode - TODO"})
			})
		}

		// Social posts routes (protected)
		social := protected.Group("/social")
		{
			social.GET("/posts", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Get social posts - TODO"})
			})
			social.POST("/posts", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Create social post - TODO"})
			})
			social.POST("/posts/:id/schedule", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Schedule social post - TODO"})
			})
		}
	}
}
