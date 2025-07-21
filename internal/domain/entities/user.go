package entities

import (
	"time"
)

// User represents a user in the system
type User struct {
	ID        uint      `json:"id" gorm:"primaryKey"`
	Username  string    `json:"username" gorm:"uniqueIndex;not null"`
	Email     string    `json:"email" gorm:"uniqueIndex;not null"`
	Password  string    `json:"-" gorm:"not null"`
	Role      string    `json:"role" gorm:"default:editor"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

// TableName returns the table name for User
func (User) TableName() string {
	return "users"
}
