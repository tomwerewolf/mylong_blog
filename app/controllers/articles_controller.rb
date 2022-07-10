class ArticlesController < ApplicationController
  def index
    @articles = Article.order(:created_at).page(params[:page]).per(5)
  end

  def show
    @article = Article.find(params[:id])
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
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
  
    if author?(@article)
      @article.update(article_params)
      redirect_to article_path(@article)
    else
      flash.now[:alert] = "You don't have permission!"
      redirect_to article_path(@article)
    end
  end

  def search
    @articles = Article.all
    @articles = @articles.search_title(params[:title]) if params[:title].present?
    @articles = @articles.search_cat(params[:category_id]) if params[:category_id].present?
    @articles = @articles.search_range(params[:date1],params[:date2]) if params[:date1].present? && params[:date2].present?
    @articles = @articles.page(params[:page]).per(4)
    render :index
  end

  def destroy
    #binding.pry
    @article = Article.find(params[:id])
    if author? @article
      @article.destroy
      redirect_to root_path, status: :see_other
    else 
      flash.now[:alert] = "You don't have permission!"
      redirect_to article_path(@article)
    end  
  end

  def my_posts
    @articles = current_user.articles.page(params[:page]).per(4)
  end

  def category_posts
    @articles = Articls.where(category_id: params[:id]).page(params[:page]).per(5)
  end  

  private
  def article_params
    params.require(:article).permit(:title, :body, :status, :category_id, :image)
  end
 
end