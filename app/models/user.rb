class User < ApplicationRecord
  has_secure_password

  validates :first_name, :last_name, presence: true
  validates :email, :username, presence: true, uniqueness: true
  before_validation :fill_full_name

  def fill_full_name
    self.full_name = "#{first_name} #{last_name}"
  end
  
end
