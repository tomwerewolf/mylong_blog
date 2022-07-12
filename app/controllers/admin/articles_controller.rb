class Admin::ArticlesController < AdminsController 
  def index
    @articles = Article.order(:created_at).page(params[:page]).per(5)
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
  
    if admin?
      @article.update(article_params)
      redirect_to index
    else
      flash.now[:alert] = "You don't have permission!"
      redirect_to index
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if admin?
      @article.destroy
      redirect_to my_posts_path, status: :see_other
    else 
      flash.now[:alert] = "You don't have permission!"
      redirect_to article_path(@article)
    end  
  end
 

  private
  def article_params
    params.require(:article).permit(:title, :body, :status, :category_id, :image)
  end
 
end