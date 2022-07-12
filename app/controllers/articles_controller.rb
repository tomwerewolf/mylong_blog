class ArticlesController < ApplicationController
  skip_before_action :require_login, except: [:new, :create, :edit, :update]

  include UsersHelper
  
  def index
    @articles = Article.published.recent.page(params[:page]).per(5)
  end

  def show
    @article = load_article
    if @article.personal?
      raise ActiveRecord::RecordNotFound unless author?(@article)
    end  
    @comments = Comment.includes(:user).where(article: @article)
    @author = @article.user
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params) 

    if @article.save
      #ResizeImageJob.perform_later(@article)
      redirect_to article_path(@article)
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
    @article = load_article
    if @article.personal?
      raise ActiveRecord::RecordNotFound unless author?(@article)
    end 
  end

  def update
    @article = load_article
    if @article.update(article_params)
      redirect_to article_path(@article)
    else
      render :edit, status: :unprocessable_entity
    end  
  end

  def search
    @articles = Article.published.recent
    @articles = Articles::SearchService.new(articles: @articles, params: params).call
    @articles = @articles.page(params[:page]).per(5)
    render :index
  end

  def destroy
    @article = load_article
    @article.image.purge
    @article.destroy
    redirect_to my_posts_path, status: :see_other
  end

  def my_posts
    @articles = current_user.articles.page(params[:page]).per(5)
  end

  def category_posts
    @articles = Article.published.recent.where(category_id: params[:id]).page(params[:page]).per(5)
  end 

  private

  def article_params
    params.require(:article).permit(:title, :body, :status, :category_id, :image)
  end

  def search_params
    params.permit(:title, :category_id, :date_from, :date_to)
  end

  def load_article
    Article.find(params[:id])
  end
  
end