class User < ApplicationRecord
  has_secure_password

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy  

  validates :first_name, :last_name, :birth_date, presence: true
  validates :email, :username, presence: true, uniqueness: true
  validate :check_birth_date

  before_validation :fill_full_name, :downcase_fields
  #before_save :downcase_fields

  def fill_full_name
    self.full_name = "#{first_name} #{last_name}"
  end

  def downcase_fields
    self.email = email.downcase
    self.username = username.downcase
  end

  def check_birth_date
    if self.birth_date > 18.years.ago
      errors.add(:birth_date, I18n.t("activerecord.errors.messages.adult"))
    end  
  end

end
