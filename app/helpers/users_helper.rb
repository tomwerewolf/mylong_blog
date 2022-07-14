module UsersHelper
  def author?(thing)
    current_user == thing.user
  end

  def is_admin?
    current_user.has_role? :admin
  end

  def is_user?
    current_user.has_role? :user
  end
end
