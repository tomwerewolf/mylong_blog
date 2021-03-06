class PasswordsController < ApplicationBaseController
  skip_before_action :require_login, except: %i[edit update]

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if authenticated? && @user.update(password_params)
      log_out
      redirect_to login_path, notice: I18n.t('flash.password.reset')
    else
      flash[:notice] = I18n.t('flash.password.wrong')
      render :edit
    end
  end

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      generate_token
      PasswordMailer.with(user: @user, reset_token: @reset_token).reset_password.deliver_now
    end
    flash[:success] = I18n.t('flash.password.mail')
    redirect_to root_path
  end

  def forgot
    # @user = User.find_signed(params[:token], purpose: "password_reset")
    @user = User.find_by(password_reset_token: params[:reset_token])
  end

  def reset
    @user = User.find_by(password_reset_token: params[:reset_token])
    if @user.present? && valid_token?
      reset_params = password_params.merge(password_reset_token: nil, password_reset_token_created_at: nil)
      if @user.update(reset_params)
        flash[:success] = I18n.t('flash.password.reset')
        redirect_to login_path
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash[:alert] = I18n.t('flash.password.again')
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def authenticated?
    @user.authenticate(params[:user][:current_password])
  end

  def generate_token
    @reset_token = SecureRandom.alphanumeric(20)
    @user.update(password_reset_token: @reset_token, password_reset_token_created_at: DateTime.current)
  end

  def valid_token?
    DateTime.current < @user.password_reset_token_created_at + 5.minutes
  end
end
