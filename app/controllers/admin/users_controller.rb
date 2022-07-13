module Admin
  class UsersController < AdminBaseController    
    def index
      @users = User.order(updated_at: :desc).page(params[:page]).per(5)
    end

    def show
      @user = current_user
    end  

    def update
      @user = current_user
      if @user.update(user_params)
        flash[:success] = "Profile updated!"
        redirect_to show
      end  
    end
    
    def destroy
      @user = User.find(params[:id])
      if admin?
        @user.destroy
        redirect_to admin_user_path, status: :see_other
      else 
        flash.now[:alert] = "You don't have permission!"
        redirect_to root_path
      end  
    end

    def search
      @users = User.where("username ILIKE :input or email ILIKE :input",
                          input: "%#{params[:input]}%").page(params[:page])
      render :index
    end  
    
    private

    def user_params
      params.require(:user).permit(:username, :first_name, :last_name, :email, :birth_date, :password, :password_confirmation)
    end

    def search_params
      params.require(:user).permit(:username, :email)
    end

  end
end  