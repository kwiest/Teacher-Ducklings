class Admin::CategoriesController < AdminController
  before_filter :load_category, :except => [:index, :new, :create]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      flash[:success] = "Category was successfully created."
      redirect_to @category
    else
      render :action => 'new'
    end
  end

  def update
    if @category.update_attributes(params[:category])
      flash[:success] = 'Category was successfully updated.'
      redirect_to @category
    else
      render :action => 'edit'
    end
  end

  def destroy
    @category.destroy
    
    flash[:notice] = "Category was successfully deleted."
    redirect_to root_path
  end
  
  
  protected
  
  def load_category
    load_model(Category)
  end
  
end
