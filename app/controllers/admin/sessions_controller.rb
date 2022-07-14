module Admin
  class SessionsController < AdminBaseController
    skip_before_action :require_admin_login, only: %i[new create]
    include SessionAction
    def new
      redirect_to admin_articles_path if logged_in?
    end

    def create
      if @user.has_role?(:admin) && @user.authenticate(params[:session][:password])
        log_in @user
        redirect_to admin_articles_path, notice: I18n.t('flash.login.success')
      else
        redirect_to admin_login_path, notice: I18n.t('flash.login.fail')
      end
    end

    def destroy
      log_out
      redirect_to admin_login_path, notice: I18n.t('flash.logout.success')
    end
  end
end
