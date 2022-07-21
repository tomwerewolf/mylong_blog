module Admin
  class CategoriesController < AdminBaseController
    def index
      @categories = Category.recent
      @categories = @categories.page(params[:page]).per(5)
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @category = load_category
    end

    def update
      @category = load_category
      if @category.update(category_params)
        redirect_to admin_categories_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category = load_category
      @category.destroy
      redirect_to admin_categories_path
    end

    def search
      @categories = Category.search_by_name(params[:name])
      @categories = @categories.page(params[:page]).per(5)
      render :index
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
