class Category < ApplicationRecord
  #resourcify

  has_many :articles, dependent: :destroy

  validates :name, presence: true
end
