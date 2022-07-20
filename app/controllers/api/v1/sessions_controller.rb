module Api
  module V1
    class SessionsController < ApiBaseController
      skip_before_action :require_sign_in, only: %i[new create]
      before_action :find_user, only: :create
      skip_authorization_check

      def create
        if @user && authenticated?
          sign_in @user
          render json: @user.result, status: :ok
        else
          render json: { message: 'Wrong' }
        end
      end

      def destroy
        sign_out
      end

      private

      def find_user
        @user = User.find_by(username: params[:session][:username].downcase)
      end

      def authenticated?
        @user.authenticate(params[:session][:password])
      end
    end
  end
end
