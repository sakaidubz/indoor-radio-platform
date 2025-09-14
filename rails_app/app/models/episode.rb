class Episode < ApplicationRecord
  belongs_to :artist
  has_many :social_posts, dependent: :destroy

  validates :title, presence: true
end

