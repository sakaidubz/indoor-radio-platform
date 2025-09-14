class Artist < ApplicationRecord
  has_many :episodes, dependent: :destroy

  validates :name, presence: true
end

