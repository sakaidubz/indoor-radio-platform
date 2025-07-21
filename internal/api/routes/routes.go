package routes

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

// SetupRoutes sets up all routes for the application
func SetupRoutes(router *gin.Engine, db *gorm.DB) {
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
		// Authentication routes
		auth := v1.Group("/auth")
		{
			auth.POST("/login", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Login endpoint - TODO"})
			})
			auth.POST("/register", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"message": "Register endpoint - TODO"})
			})
		}

		// Artists routes
		artists := v1.Group("/artists")
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

		// Episodes routes
		episodes := v1.Group("/episodes")
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

		// Social posts routes
		social := v1.Group("/social")
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
