class Performance < ApplicationRecord
  belongs_to :stage
  belongs_to :artist

  validates :starts_at, presence: true
end
