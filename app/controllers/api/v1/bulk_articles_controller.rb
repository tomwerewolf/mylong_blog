module Api
  module V1
    class BulkArticlesController < ApiBaseController
      authorize_resource :class => :controller

      def destroy
        @articles = Article.order(created_at: :desc).accessible_by(current_ability)
        @articles = @articles.where(id: params[:article_ids])
        @articles.destroy_all if params[:article_ids]
        render json: { head: :no_content }, status: :no_content
      end
    end
  end
end
