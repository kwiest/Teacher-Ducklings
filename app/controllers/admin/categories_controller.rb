class Admin::CategoriesController < AdminController
  rescue_from ActiveRecord::RecordNotFound, with: :category_not_found

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      flash[:success] = 'Category was successfully created.'
      redirect_to admin_categories_path
    else
      render :action => 'new'
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(params[:category])
      flash[:success] = 'Category was successfully updated.'
      redirect_to admin_categories_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = 'Category was successfully deleted.'
    redirect_to admin_categories_path
  end
  
  
  protected
  
  def category_not_found(exception)
    flash[:error] = 'Sorry, but that category could not be found.'
    redirect_to admin_categories_path
  end
  
end
