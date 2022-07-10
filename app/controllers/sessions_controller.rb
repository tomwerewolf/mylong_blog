class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "Login successfully!"
      log_in user
      redirect_to articles_path
    else
      flash[:danger] = "Invalid email/password combination"
      redirect_to login_path
    end
  end

  def destroy
    log_out
    flash[:success] = "You are logged out"
    redirect_to login_path
  end
end
