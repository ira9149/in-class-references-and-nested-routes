class Artist < ApplicationRecord
  has_many :tracks, dependent: :destroy
  has_many :performances, dependent: :destroy
  has_many :stages, through: :performances

  validates :name, :genre, presence: true
end
