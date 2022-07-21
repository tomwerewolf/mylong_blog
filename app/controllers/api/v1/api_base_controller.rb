module Api
  module V1
    class ApiBaseController < ::ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :require_sign_in

      rescue_from CanCan::AccessDenied do |exception|
        render json: { message: exception.message }
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        render json: e.message, status: :not_found
      end

      def require_sign_in
        render json: { message: 'Please sign in' } unless signed_in?
      end

      def sign_in(user)
        token = SecureRandom.alphanumeric(20)
        user.user_tokens.delete_all
        user.user_tokens.create(token: token)
      end

      def sign_out
        token = request.headers['HTTP_ACCESS_TOKEN']
        UserToken.find_by(token: token).delete
        render json: { message: 'You have been signed out' }
      end

      def current_user
        # token = UserToken.find_by(token: request.headers["HTTP_ACCESS_TOKEN"])
        # @current_user ||= token.user if token.present?
        @current_user ||= User.joins(:user_tokens).find_by(user_tokens: { token: request.headers['HTTP_ACCESS_TOKEN'] })
      end

      def signed_in?
        current_user.present?
      end
    end
  end
end
