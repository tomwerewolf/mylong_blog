class Category < ApplicationRecord
  #resourcify

  has_many :articles

  validates :name, presence: true
end
