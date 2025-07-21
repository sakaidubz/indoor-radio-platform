package database

import (
	"fmt"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"github.com/sakaidubz/indoor-radio-platform/internal/config"
	"github.com/sakaidubz/indoor-radio-platform/internal/domain/entities"
)

// Initialize initializes the database connection
func Initialize(cfg config.DatabaseConfig) (*gorm.DB, error) {
	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
		cfg.Host, cfg.User, cfg.Password, cfg.Name, cfg.Port, cfg.SSLMode)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %w", err)
	}

	return db, nil
}

// Migrate runs database migrations
func Migrate(db *gorm.DB) error {
	return db.AutoMigrate(
		&entities.User{},
		&entities.Artist{},
		&entities.Episode{},
		&entities.SocialPost{},
	)
}
