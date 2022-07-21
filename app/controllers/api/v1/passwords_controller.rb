module Api
  module V1
    class PasswordsController < ApiBaseController
      skip_before_action :require_sign_in, except: %i[edit update]

      def edit
        @user = current_user
        render json: @user.profile
      end

      def update
        @user = current_user
        if authenticated? && @user.update(password_params)
          sign_out
          render json: @user.profile, status: :ok
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def new; end

      def create
        @user = User.find_by(email: params[:email])
        if @user.present?
          generate_token
          PasswordMailer.with(user: @user, reset_token: @reset_token).reset_password.deliver_now
        end

        render json: { message: I18n.t('flash.password.mail') }
      end

      def forgot
        @user = User.find_by(password_reset_token: params[:reset_token])
      end

      def reset
        @user = User.find_by(password_reset_token: params[:reset_token])
        if @user.present? && !token_expired?
          reset_params = password_params.merge(password_reset_token: nil, password_reset_token_created_at: nil)
          if @user.update(reset_params)
            render json: @user.profile, message: I18n.t('flash.password.reset'), status: :ok
          else
            render json: @user.errors, status: :unprocessable_entity
          end

        else
          render json: { message: I18n.t('flash.password.again') }
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

      def token_expired?
        DateTime.current > @user.password_reset_token_created_at + 5.minutes
      end
    end
  end
end
