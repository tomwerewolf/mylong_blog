module Admin
  class ArticlesController < AdminBaseController
    def index
      @articles = Article.includes(:category).order(updated_at: :desc).page(params[:page]).per(5)
    end

    def show
      @article = load_article
      #raise ActiveRecord::RecordNotFound if @article.personal? && !author?(@article)

      @comments = Comment.includes(:user).where(article: @article)
      @author = @article.user
    end

    def new
      @article = Article.new
    end

    def edit
      @article = load_article
    end

    def update
      @article = load_article

      if admin? && @article.update(article_params)
        redirect_to admin_articles_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @article = load_article
      if admin?
        @article.destroy
        redirect_to my_posts_path, status: :see_other
      else
        flash.now[:alert] = "You don't have permission!"
        redirect_to admin_articles_path
      end
    end

    def search
      @articles = Article.all
      @articles = Articles::SearchService.new(articles: @articles, params: params).call
      @articles = @articles.page(params[:page]).per(5)
      render :index
    end

    def my_posts
      @articles = current_user.articles.page(params[:page]).per(5)
    end

    private

    def article_params
      params.require(:article).permit(:title, :body, :status, :category_id, :image)
    end

    def load_article
      Article.find(params[:id])
    end
  end
end
