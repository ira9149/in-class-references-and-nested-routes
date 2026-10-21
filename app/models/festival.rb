class Festival < ApplicationRecord
  has_many :stages, dependent: :destroy
  has_many :tickets, dependent: :destroy

  validates :name, :starts_on, :city, presence: true
end
