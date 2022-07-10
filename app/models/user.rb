class User < ApplicationRecord
  has_secure_password

  def fill_full_name
    self.full_name = "#{first_name} #{last_name}"
  end 
end
