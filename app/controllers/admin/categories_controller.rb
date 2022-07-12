class Admin::CategoriesController < AdminsController
  def index
    @categories = Category.page(params[:page]).per(5)
  end

  def new
    @category = Category.new
  end

  def create
    if @category.save
      redirect_to category_path(@category)
    else
      render :new, status: :unprocessable_entity 
    end
  end

  def edit
    @category = Category.find(params[:id])
  end
end
