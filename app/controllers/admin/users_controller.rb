module Admin
  class UsersController < AdminBaseController
    before_action :load_user, except: %i[index show new create]

    def index
      @users = User.includes(:roles).recent
      @users = @users.page(params[:page]).per(5)
    end

    def show
      @user = current_user
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          # Tell the UserMailer to send a welcome email after save
          UserMailer.with(user: @user).welcome_email.deliver_later
          format.html { redirect_to(@user, I18n.t('flash.register.success')) }
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def edit; end

    def edit_roles; end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: I18n.t('flash.update.success')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def update_roles
      change_roles
      redirect_to edit_roles_admin_user_path, notice: I18n.t('flash.update.success')
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, status: :see_other
    end

    def search
      @users = User.search_by_username(params[:username])
      @users = @users.page(params[:page])
      render :index
    end

    private
  
    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :email, :birth_date, :password,
                                   :password_confirmation)
    end

    def load_user
      @user = User.find(params[:id])
    end

    def search_params
      params.require(:user).permit(:username, :email)
    end

    def change_roles
      roles = params[:user]
      roles.each do |role, check|
        @user.add_role role if check == role
        @user.remove_role role if check == "cancel"
        end

    end
  end
end
