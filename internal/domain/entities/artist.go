package entities

import (
	"time"
)

// Artist represents an artist in the system
type Artist struct {
	ID           uint      `json:"id" gorm:"primaryKey"`
	Name         string    `json:"name" gorm:"not null"`
	Genre        string    `json:"genre"`
	ThemeColor   string    `json:"theme_color"`
	Bio          string    `json:"bio"`
	PhotoURL     string    `json:"photo_url"`
	LogoURL      string    `json:"logo_url"`
	XID          string    `json:"x_id"`
	InstagramID  string    `json:"instagram_id"`
	SoundCloudID string    `json:"soundcloud_id"`
	OtherLinks   string    `json:"other_links"`
	Status       string    `json:"status" gorm:"default:draft"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`

	// Relationships
	Episodes []Episode `json:"episodes,omitempty" gorm:"foreignKey:ArtistID"`
}

// TableName returns the table name for Artist
func (Artist) TableName() string {
	return "artists"
}
