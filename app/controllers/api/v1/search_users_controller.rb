module Api
  module V1
    class SearchUsersController < ApiBaseController
      authorize_resource :class => false
      def index
        @users = User.search_by_username(params[:username])
        #@users = @users.page(params[:page])
        render json: @users
      end
    end
  end
end
