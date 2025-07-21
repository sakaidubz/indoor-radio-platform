package entities

import (
	"time"
)

// Episode represents an episode in the system
type Episode struct {
	ID            uint      `json:"id" gorm:"primaryKey"`
	ArtistID      uint      `json:"artist_id" gorm:"not null"`
	Title         string    `json:"title" gorm:"not null"`
	ScheduledDate *time.Time `json:"scheduled_date"`
	SoundCloudURL string    `json:"soundcloud_url"`
	ArtworkURL    string    `json:"artwork_url"`
	Status        string    `json:"status" gorm:"default:planning"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`

	// Relationships
	Artist      Artist       `json:"artist,omitempty" gorm:"foreignKey:ArtistID"`
	SocialPosts []SocialPost `json:"social_posts,omitempty" gorm:"foreignKey:EpisodeID"`
}

// TableName returns the table name for Episode
func (Episode) TableName() string {
	return "episodes"
}
