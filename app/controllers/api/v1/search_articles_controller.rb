module Api
  module V1
    class SearchArticlesController < ApiBaseController
      skip_before_action :require_sign_in
      def index
        @articles = Article.includes(:category).order(updated_at: :desc).accessible_by(current_ability)
        @articles = Articles::SearchService.new(articles: @articles, params: params).call
        render json: @articles
      end

      private

      def search_params
        params.permit(:title, :category_id, :date_from, :date_to)
      end
    end
  end
end
