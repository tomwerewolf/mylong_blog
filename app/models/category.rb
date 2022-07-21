class Category < ApplicationRecord
  has_many :articles, dependent: :destroy

  validates :name, presence: true

  scope :recent, -> { order(updated_at: :desc) }
  scope :search_by_name, ->(name) { where('name ILIKE :name', name: "%#{name}%") }
end
