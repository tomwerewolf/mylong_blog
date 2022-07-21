module Admin
  class ArticlesController < AdminBaseController
    before_action :load_article, only: %i[edit update destroy]

    def index
      @articles = Article.includes(:category, :user).order(updated_at: :desc)
      @articles = @articles.page(params[:page]).per(5)
    end

    def new
      @article = Article.new
    end

    def my_posts
      @articles = Article.includes(:category).recent.where(user: current_user)
      @articles = @articles.page(params[:page]).per(5)
    end

    def show
      @article = Article.includes(comments: :user).find(params[:id])
      @author = @article.user
    end

    def create
      @article = current_user.articles.new(article_params)

      if @article.save
        redirect_to admin_articles_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @article.update(article_params)
        @article.image.purge if params[:article][:delete_image] == 'delete'
        redirect_to admin_articles_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @article.destroy
      redirect_to admin_articles_path, status: :see_other
    end

    def destroy_selected
      Article.where(id: params[:article_ids]).destroy_all if params[:article_ids]
      redirect_to admin_articles_path
    end

    def search
      @articles = Article.includes(:category).order(updated_at: :desc)
      @articles = Articles::SearchService.new(articles: @articles, params: params).call
      @articles = @articles.page(params[:page]).per(5)
      render :index
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
end
