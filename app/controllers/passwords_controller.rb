class PasswordsController < ApplicationController
  skip_before_action :require_login, except: [:edit, :update]

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if authenticated?
      if @user.update(password_params)
        log_out
        flash[:success] = "Your changes have been saved. Login again!"
        redirect_to login_path
      else
        render :edit
      end    
    else
      #binding.pry
      flash[:alert] = "Current password is incorrect!"
      render :edit
    end     
  end
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      generate_token
      PasswordMailer.with(user: @user, reset_token: @reset_token).reset_password.deliver_now
    end  
    flash[:success] = "We sent you a mail to reset your password if your email exists."
    redirect_to root_path
  end
  
  def forgot
    #@user = User.find_signed(params[:token], purpose: "password_reset")
    @user = User.find_by(password_reset_token: params[:reset_token])
  end

  def reset
    @user = User.find_by(password_reset_token: params[:reset_token])
    if @user.present? && valid_token?
      reset_params = password_params.merge(password_reset_token: nil, password_reset_token_created_at: nil)
      if @user.update(reset_params)
        @user.update(password_reset_token: nil, password_reset_token_created_at: nil)
        flash[:success] = "Your password has been reset. Login again!"
        redirect_to login_path
      else
        render :edit
      end
    else
      flash[:alert] = "Time out. Please make a new request!"
      render :edit  
    end      
  end 
  
  private
  
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def authenticated?
    @user.authenticate(params[:user][:current_password]).present?
  end
  
  def generate_token
    @reset_token = SecureRandom.alphanumeric(20)
    @user.update(password_reset_token: @reset_token, password_reset_token_created_at: DateTime.current)
  end

  def valid_token?
    DateTime.current < @user.password_reset_token_created_at + 5.minutes
  end

end  