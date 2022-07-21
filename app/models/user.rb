class User < ApplicationRecord
  rolify
  has_secure_password

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  NAME_REGEX = /^[a-zA-Z\s]*$/

  validates :birth_date, presence: true
  validates :email, :username, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true,
                                     format: { with: NAME_REGEX, multiline: true, message: I18n.t('errors.messages.no_digits') }
  validate :check_birth_date

  before_validation :fill_full_name, :downcase_fields
  after_create :assign_default_role

  scope :recent, -> { order(updated_at: :desc) }
  scope :search_by_username, ->(username) { where('username ILIKE :username', username: "%#{username}%") }

  private

  def fill_full_name
    self.full_name = "#{first_name} #{last_name}"
  end

  def downcase_fields
    self.email = email.downcase
    self.username = username.downcase
  end

  def check_birth_date
    errors.add(:birth_date, I18n.t('activerecord.errors.messages.adult')) if birth_date >= 16.years.ago
  end

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
