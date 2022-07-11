class UsersController < ApplicationController  
  skip_before_action :require_login, only: [:new, :create]
  
  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # if @user.save
    #   flash[:success] = "Register successfully!"
    #   redirect_to login_path
    # else
    #   flash[:success] = "Register failed!"
    #   redirect_to :new
    # end
    respond_to do |format|
      if @user.save
        # Tell the UserMailer to send a welcome email after save
        UserMailer.with(user: @user).welcome_email.deliver_later
        format.html { redirect_to(@user, notice: 'Register successfully!') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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
  
  def posts
    #@articles = Article.where(user_id: params[:id]).page(params[:page]).per(5)
    @user = User.find(params[:id])
    @articles = @user.articles.page(params[:page]).per(5)
  end 
  
  private
  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :birth_date, :password, :password_confirmation)
  end

end  