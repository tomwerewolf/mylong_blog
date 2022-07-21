module Api
  module V1
    class ArticlesController < ApiBaseController
      skip_before_action :require_sign_in, except: %i[new create edit update]
      before_action :load_article, only: %i[edit update destroy]
      load_and_authorize_resource

      def index
        @articles = Article.order(created_at: :desc).accessible_by(current_ability)
        render json: @articles, status: :ok
        # respond_to do |format|
        #   format.json { render json: @articles.to_json }
        # end
      end

      def show
        @article = Article.includes(comments: :user).find(params[:id])
        # raise ActiveRecord::RecordNotFound if @article.personal? && !author?(@article)
        render json: @article, status: :ok
      end

      def create
        @article = current_user.articles.new(article_params)

        if @article.save
          render json: @article, status: :created
        else
          render json: @article.errors, status: :unprocessable_entity
        end
      end

      def update
        if @article.update(article_params)
          render json: @article, status: :created
        else
          render json: @article.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @article.destroy
        render json: @article, status: :ok
      end

      def category_posts
        @articles = Article.joins(:category).public_show.where(category_id: params[:id])
        #@articles = @articles.page(params[:page]).per(5)
        render json: @articles, status: :ok
      end

      def my_posts
        @articles = Article.includes(:category).where(user: current_user)
        render json: @articles, status: :ok
      end

      private

      def article_params
        params.require(:article).permit(:title, :body, :status, :category_id, :image)
      end

      def load_article
        @article = Article.find(params[:id])
      end
    end
  end
end
