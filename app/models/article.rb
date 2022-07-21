class Article < ApplicationRecord
  belongs_to :category, counter_cache: true
  belongs_to :user, counter_cache: true

  has_many :comments, dependent: :destroy

  has_one_attached :image

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  enum status: { published: 'published', personal: 'personal' }

  scope :recent, -> { order(updated_at: :desc) }
  scope :public_show, -> { published.order(created_at: :desc) }

  scope :search_title, ->(title) { where('title ILIKE :title', title: "%#{title}%") }
  scope :search_cat, ->(category) { where(category_id: category) }
  scope :search_range, ->(date_from, date_to) { where(created_at: date_from.to_datetime..date_to.to_datetime) }
end
