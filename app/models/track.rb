class Track < ApplicationRecord
  belongs_to :artist

  validates :title, presence: true
  validates :length_sec, numericality: { only_integer: true, greater_than: 0 }
end
