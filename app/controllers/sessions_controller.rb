class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
  end

  def create
    #binding.pry
    user = User.where(username: params[:session][:username_email])
               .or(User.where(email: params[:session][:username_email])).first
    #user = User.find_by(username: params[:session][:username_email])
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "Login successfully!"
      log_in user
      redirect_to articles_path
    else
      flash[:danger] = "Invalid username/password combination"
      redirect_to login_path
    end
  end

  def destroy
    log_out
    flash[:success] = "You are logged out"
    redirect_to login_path
  end

end
