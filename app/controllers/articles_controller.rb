class ArticlesController < ApplicationBaseController
  skip_before_action :require_login, except: %i[new create edit update]
  include ArticleAction
  def index
    @articles = Article.public_show
    @articles = @articles.page(params[:page]).per(5)
  end

  def show
    @article = Article.includes(comments: :user).find(params[:id])
    raise ActiveRecord::RecordNotFound if @article.personal? && !author?(@article)

    @author = @article.user
  end

  def create
    @article = current_user.articles.new(article_params)

    if @article.save
      redirect_to article_path(@article)
    else
      render :new
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
      render :edit
    end
  end

  def destroy
    @article.image.purge
    @article.destroy
    redirect_to my_posts_path
  end

  def category_posts
    @articles = Article.joins(:category).public_show.where(category_id: params[:id])
    @articles = @articles.page(params[:page]).per(5)
  end
end
