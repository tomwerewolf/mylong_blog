class ArticlesController < ApplicationBaseController
  skip_before_action :require_login, except: %i[new create edit update]
  before_action :load_article, only: %i[edit update destroy]

  def index
    @articles = Article.public_show
    @articles = @articles.page(params[:page]).per(5)
  end

  def show
    @article = Article.includes(comments: :user).find(params[:id])
    raise ActiveRecord::RecordNotFound if @article.personal? && !author?(@article)

    @author = @article.user
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)

    if @article.save
      redirect_to article_path(@article)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    raise ActiveRecord::RecordNotFound if @article.personal? && !author?(@article)
  end

  def search
    @articles = Article.public_show
    @articles = Articles::SearchService.new(articles: @articles, params: search_params).call
    @articles = @articles.page(params[:page]).per(5)
    render :index
  end

  def update
    if @article.update(article_params)
      @article.image.purge if params[:article][:delete_image] == 'delete'
      redirect_to article_path(@article)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to my_posts_path, status: :see_other
  end

  def category_posts
    @articles = Article.joins(:category).public_show.where(category_id: params[:id])
    @articles = @articles.page(params[:page]).per(5)
  end

  def my_posts
    @articles = Article.includes(:category).where(user: current_user)
    @articles = @articles.page(params[:page]).per(5)
  end

  def destroy_selected
    Article.where(id: params[:article_ids]).destroy_all if params[:article_ids]
    redirect_to my_posts_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :status, :category_id, :image)
  end

  def search_params
    params.permit(:title, :category_id, :date_from, :date_to, :commit)
  end

  def load_article
    @article = Article.find(params[:id])
  end
end
