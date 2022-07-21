module Admin
  class AdminBaseController < ::ApplicationController
    layout 'admin'
    before_action :require_admin_login

    def require_admin_login
      redirect_to admin_login_path unless logged_in? && is_admin?
    end
  end
end
