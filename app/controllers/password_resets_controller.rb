class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new
  end
  
  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      PasswordMailer.with(user: @user).reset_password.deliver_now

    end  
    flash[:notice] = "We sent you a mail to reset your password."
    redirect_to root_path
  end
  
  def edit
    @user = User.find_signed(params[:token], purpose: "password_reset")
  end

  def update
    @user = User.find_signed(params[:token], purpose: "password_reset")
    if @user.update(password_params)
      flash[:success] = "Your password has been reset. Login again!"
      redirect_to login_path
    else
      render :edit
    end  
  end  

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end  