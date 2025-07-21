package entities

import (
	"time"
)

// SocialPost represents a social media post in the system
type SocialPost struct {
	ID          uint       `json:"id" gorm:"primaryKey"`
	EpisodeID   uint       `json:"episode_id" gorm:"not null"`
	Platform    string     `json:"platform" gorm:"not null"` // 'x' or 'instagram'
	Content     string     `json:"content" gorm:"not null"`
	ScheduledAt *time.Time `json:"scheduled_at"`
	PostedAt    *time.Time `json:"posted_at"`
	PostID      string     `json:"post_id"` // Platform-specific post ID
	Status      string     `json:"status" gorm:"default:scheduled"`
	CreatedAt   time.Time  `json:"created_at"`
	UpdatedAt   time.Time  `json:"updated_at"`

	// Relationships
	Episode Episode `json:"episode,omitempty" gorm:"foreignKey:EpisodeID"`
}

// TableName returns the table name for SocialPost
func (SocialPost) TableName() string {
	return "social_posts"
}
