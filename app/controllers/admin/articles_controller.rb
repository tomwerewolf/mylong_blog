module Admin
  class ArticlesController < AdminBaseController
    include ArticleAction
    def index
      @articles = Article.includes(:category).order(updated_at: :desc)
      @articles = @articles.page(params[:page]).per(5)
    end

    def show
      @article = Article.includes(comments: :user).find(params[:id])
      @author = @article.user
    end

    def edit; end

    def update
      if @article.update(article_params)
        @article.image.purge if params[:article][:delete_image] == 'delete'
        redirect_to admin_articles_path
      else
        render :edit
      end
    end

    def destroy
      @article.destroy
      redirect_to admin_articles_path
    end

    def search
      @articles = Article.includes(:category).order(updated_at: :desc)
      @articles = Articles::SearchService.new(articles: @articles, params: params).call
      @articles = @articles.page(params[:page]).per(5)
      render :index
    end
  end
end
