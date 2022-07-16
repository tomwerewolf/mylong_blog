module Admin
  class SessionsController < AdminBaseController
    skip_before_action :require_admin_login, only: %i[new create]
    before_action :find_user, only: :create

    def new
      redirect_to admin_articles_path if logged_in?
    end

    def create
      if @user&.has_role?(:admin) && admin_authenticated?
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

    private

    def find_user
      @user = User.find_by(username: params[:session][:username].downcase)
    end

    def admin_authenticated?
      @user.authenticate(params[:session][:password])
    end
  end
end
