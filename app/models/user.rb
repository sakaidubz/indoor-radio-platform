class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
end

