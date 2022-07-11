class User < ApplicationRecord
  #rolify
  has_secure_password

  has_many :articles, dependent: :destroy 

  validates :first_name, :last_name, presence: true
  validates :email, :username, presence: true, uniqueness: true
  before_validation :fill_full_name

  def fill_full_name
    self.full_name = "#{first_name} #{last_name}"
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end
  
  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  private
  def generate_token
    SecureRandom.hex(10)
  end
  
end
