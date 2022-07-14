class UsersController < ApplicationBaseController
  skip_before_action :require_login, only: %i[new create]

  include UserAction
  def show
    @user = current_user
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
end
