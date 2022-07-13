class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    user = User.where(username: params[:session][:username_email].downcase)
               .or(User.where(email: params[:session][:username_email].downcase)).first
    if user && user.authenticate(params[:session][:password])
      flash[:success] = I18n.t('flashs.login.success')
      log_in user
      current_user
      routing
    else
      flash[:danger] = I18n.t('flashs.login.fail')
      redirect_to login_path
    end
  end

  def destroy
    log_out
    flash[:success] = I18n.t('flashs.logout.success')
    redirect_to login_path
  end

  private

  def routing
    if admin?
      redirect_to admin_articles_path
    else
      redirect_to articles_path
    end
  end
end
