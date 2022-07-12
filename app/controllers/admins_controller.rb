class AdminsController < ApplicationController
  before_action :check_admin

  def require_login
    unless logged_in?
      redirect_to login_path
    end
  end

  def check_admin
    unless admin?
      flash[:danger] = "You dont have permission!"
      redirect_to root_path
    end  
  end 

end
