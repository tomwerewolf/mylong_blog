class ArticlesController < ApplicationController
  skip_before_action :require_login, except: [:new, :create, :edit, :update]

  include UsersHelper
  
  def index
    @articles = Article.order(:created_at).where(status: :published).page(params[:page]).per(5)
  end

  def show
    @article = load_article
    @comments = Comment.includes(:user).where(article: @article)
    #@author = @article.user
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
    @article = load_article
  end

  def update
    @article = load_article
  
    if author?(@article)
      if @article.update(article_params)
        redirect_to article_path(@article)
      else
        render :edit, status: :unprocessable_entity
      end  
    else
      flash.now[:alert] = "You don't have permission!"
      redirect_to article_path(@article)
    end
  end

  def search
    @articles = Article.all
    @articles = @articles.search_title(params[:title]) if params[:title].present?
    @articles = @articles.search_cat(params[:category_id]) if params[:category_id].present?
    @articles = @articles.search_range(params[:date1], params[:date2]) if params[:date1].present? && params[:date2].present?
    @articles = @articles.page(params[:page]).per(4)
    render :index
  end

  def destroy
    #binding.pry
    @article = load_article
    if author? @article
      @article.destroy
      redirect_to my_posts_path, status: :see_other
    else 
      flash.now[:alert] = "You don't have permission!"
      redirect_to article_path(@article)
    end  
  end

  def my_posts
    @articles = current_user.articles.page(params[:page]).per(5)
  end

  def category_posts
    @articles = Article.where(category_id: params[:id]).page(params[:page]).per(5)
  end  

  private
  def article_params
    params.require(:article).permit(:title, :body, :status, :category_id, :image)
  end

  def load_article
    Article.find(params[:id])
  end
end