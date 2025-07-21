package config

import (
	"os"
)

// Config holds all configuration for the application
type Config struct {
	Environment string
	Database    DatabaseConfig
	JWT         JWTConfig
	AWS         AWSConfig
	External    ExternalConfig
}

// DatabaseConfig holds database configuration
type DatabaseConfig struct {
	Host     string
	Port     string
	User     string
	Password string
	Name     string
	SSLMode  string
}

// JWTConfig holds JWT configuration
type JWTConfig struct {
	Secret string
}

// AWSConfig holds AWS configuration
type AWSConfig struct {
	Region   string
	S3Bucket string
}

// ExternalConfig holds external API configuration
type ExternalConfig struct {
	XAPIKey              string
	XAPISecret           string
	InstagramAccessToken string
	SoundCloudClientID   string
}

// Load loads configuration from environment variables
func Load() *Config {
	return &Config{
		Environment: getEnv("ENVIRONMENT", "development"),
		Database: DatabaseConfig{
			Host:     getEnv("DB_HOST", "localhost"),
			Port:     getEnv("DB_PORT", "5432"),
			User:     getEnv("DB_USER", "indoor_radio"),
			Password: getEnv("DB_PASSWORD", ""),
			Name:     getEnv("DB_NAME", "indoor_radio_db"),
			SSLMode:  getEnv("DB_SSL_MODE", "disable"),
		},
		JWT: JWTConfig{
			Secret: getEnv("JWT_SECRET", "your-secret-key"),
		},
		AWS: AWSConfig{
			Region:   getEnv("AWS_REGION", "ap-northeast-1"),
			S3Bucket: getEnv("AWS_S3_BUCKET", "indoor-radio-assets"),
		},
		External: ExternalConfig{
			XAPIKey:              getEnv("X_API_KEY", ""),
			XAPISecret:           getEnv("X_API_SECRET", ""),
			InstagramAccessToken: getEnv("INSTAGRAM_ACCESS_TOKEN", ""),
			SoundCloudClientID:   getEnv("SOUNDCLOUD_CLIENT_ID", ""),
		},
	}
}

// getEnv gets an environment variable with a fallback value
func getEnv(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
