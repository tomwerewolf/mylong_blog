class Admin::UsersController < AdminsController    
  def index
    @users = User.page(params[:page]).per(5)
  end

  def edit
    #@user = current_user
  end  

  def update
    #binding.pry
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
  
  private
  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :birth_date, :password, :password_confirmation)
  end

end  