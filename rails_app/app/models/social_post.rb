class SocialPost < ApplicationRecord
  belongs_to :episode

  validates :platform, presence: true
  validates :content, presence: true
end

