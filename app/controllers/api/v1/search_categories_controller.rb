module Api
  module V1
    class SearchCategoriesController < ApiBaseController
      authorize_resource :class => :controller
      
      def index
        @categories = Category.search_by_name(params[:name])
        #@categories = @categories.page(params[:page]).per(5)
        render json: @categories
      end
    end
  end
end
