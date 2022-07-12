module UsersHelper
  def author? thing
    current_user == thing.user 
  end
end
