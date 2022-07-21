module Api
  module V1
    class Api::V1::UsersController < ApiBaseController
      skip_before_action :require_sign_in, only: %i[new create]
      before_action :load_user, except: %i[new show create update]
      load_and_authorize_resource

      def show
        @user = load_user
        render json: @user.profile
      end

      def create
        @user = User.new(user_params)
        respond_to do |format|
          if @user.save
            # Tell the UserMailer to send a welcome email after save
            UserMailer.with(user: @user).welcome_email.deliver_later
            format.json { render json: @user.profile, status: :created, location: @user }
          else
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end

      def update
        if @user.update(user_params)
          render json: @user.profile
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def posts
        @articles = @user.articles.page(params[:page]).per(5)
      end

      def destroy
        @user.destroy
        render json: @user, status: :ok
      end

      private

      def load_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(
          :username,
          :first_name,
          :last_name,
          :full_name,
          :email,
          :birth_date,
          :password,
          :password_confirmation
        )
      end
    end
  end
end
