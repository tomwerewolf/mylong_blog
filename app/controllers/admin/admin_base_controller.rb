module Admin
  class AdminBaseController < ::ApplicationController
    layout 'admin'
    before_action :check_admin

    # def require_login
    #   unless logged_in?
    #     redirect_to login_path
    #   end
    # end

    def check_admin
      redirect_to root_path unless admin?
    end
  end
end
