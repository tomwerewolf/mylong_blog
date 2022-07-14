module Admin
  class UsersController < AdminBaseController
    include UserAction
    before_action :load_user, except: %i[index search]
    def index
      @users = User.includes(:roles).recent
      @users = @users.page(params[:page]).per(5)
    end

    def show; end

    def edit_roles; end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path, notice: I18n.t('flash.update.success')
      else
        render :show
      end
    end

    def update_roles
      # binding.pry
      change_roles #unless @user == current_user
      redirect_to edit_roles_admin_user_path, notice: I18n.t('flash.update.success')
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path
    end

    def search
      @users = User.search_by_username(params[:username])
      @users = @users.page(params[:page])
      render :index
    end

    private

    def search_params
      params.require(:user).permit(:username, :email)
    end

    def change_roles
      roles = params[:user]
      roles.each do |k, v|
        @user.add_role k
        @user.remove_role k if v == 'cancel'
      end
    end
  end
end
