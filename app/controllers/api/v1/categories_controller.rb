module Api
  module V1
    class CategoriesController < ApiBaseController
      authorize_resource

      def index
        @categories = Category.recent
        render json: @categories, status: :ok
      end

      def edit
        #binding.pry
        @category = load_category
        render json: @category
      end

      def create
        @category = Category.new(category_params)
        if @category.save
          render json: @category, status: :created
        else
          render json: @category.errors, status: :unprocessable_entity
        end
      end

      def update
        @category = load_category
        if @category.update(category_params)
          render json: @category, status: :ok
        else
          render json: @category.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @category = load_category
        @category.destroy
        render json: @category, status: :ok
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end

      def load_category
        Category.find(params[:id])
      end
    end
  end
end
