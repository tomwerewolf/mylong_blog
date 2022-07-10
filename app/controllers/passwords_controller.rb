class PasswordsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.authenticate(params[:user][:current_password])
      @user.update(password_params)
      log_out
      flash[:success] = "Your changes have been saved. Login again!"
      redirect_to login_path
    else
      flash[:alert] = "Current password is incorrect!"
      render :edit
    end     
  end 
  
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end  