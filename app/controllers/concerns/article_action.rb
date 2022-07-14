module ArticleAction
  extend ActiveSupport::Concern
  included do
    before_action :load_article, only: %i[edit destroy update]
  end

  def new
    @article = Article.new
  end

  def my_posts
    @articles = Article.includes(:category).recent.where(user: current_user)
    @articles = @articles.page(params[:page]).per(5)
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
