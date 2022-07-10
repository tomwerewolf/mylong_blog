class Article < ApplicationRecord
  belongs_to :category, counter_cache: true
  belongs_to :user, counter_cache: true

  has_one_attached :image

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  enum status: {published: "published", persional: "persional", archived: "archived"}

  scope :search_title, -> (title) { where "title LIKE :title", title: "%#{title}%" }
  scope :search_cat, -> (category) { where category_id: category}
  scope :search_range, -> (date1, date2) { where(created_at: date1.to_datetime..date2.to_datetime)}
end
