class UsersController < ApplicationBaseController
  skip_before_action :require_login, only: %i[new create]
  before_action :load_user, except: %i[new show create update]

  def new
    @user = User.new
  end

  def show
    @user = current_user
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

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to show, notice: I18n.t('flash.update.success')
    else
      render :show, status: :unprocessable_entity
    end
  end

  def posts
    @articles = @user.articles.page(params[:page]).per(5)
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :birth_date, :password,
                                 :password_confirmation)
  end
end
