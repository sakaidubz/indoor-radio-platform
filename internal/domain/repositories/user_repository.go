package repositories

import (
	"github.com/sakaidubz/indoor-radio-platform/internal/domain/entities"
	"gorm.io/gorm"
)

// UserRepository defines the interface for user data operations
type UserRepository interface {
	Create(user *entities.User) error
	GetByID(id uint) (*entities.User, error)
	GetByUsername(username string) (*entities.User, error)
	GetByEmail(email string) (*entities.User, error)
	Update(user *entities.User) error
	Delete(id uint) error
	List(limit, offset int) ([]*entities.User, error)
}

// userRepository implements UserRepository
type userRepository struct {
	db *gorm.DB
}

// NewUserRepository creates a new UserRepository
func NewUserRepository(db *gorm.DB) UserRepository {
	return &userRepository{db: db}
}

// Create creates a new user
func (r *userRepository) Create(user *entities.User) error {
	return r.db.Create(user).Error
}

// GetByID retrieves a user by ID
func (r *userRepository) GetByID(id uint) (*entities.User, error) {
	var user entities.User
	err := r.db.First(&user, id).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

// GetByUsername retrieves a user by username
func (r *userRepository) GetByUsername(username string) (*entities.User, error) {
	var user entities.User
	err := r.db.Where("username = ?", username).First(&user).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

// GetByEmail retrieves a user by email
func (r *userRepository) GetByEmail(email string) (*entities.User, error) {
	var user entities.User
	err := r.db.Where("email = ?", email).First(&user).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

// Update updates a user
func (r *userRepository) Update(user *entities.User) error {
	return r.db.Save(user).Error
}

// Delete deletes a user by ID
func (r *userRepository) Delete(id uint) error {
	return r.db.Delete(&entities.User{}, id).Error
}

// List retrieves a list of users with pagination
func (r *userRepository) List(limit, offset int) ([]*entities.User, error) {
	var users []*entities.User
	err := r.db.Limit(limit).Offset(offset).Find(&users).Error
	return users, err
}
