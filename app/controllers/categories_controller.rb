class CategoriesController < ApplicationController
  before_filter :admin_required, :except => [ "show" ]

  # GET /categories/1
  def show
    @category = Category.find(params[:id])
    @posts = @category.posts
    @links = @category.links
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the category you're looking for cannot be found."
      redirect_to root_path
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the category you're looking for cannot be found."
      redirect_to root_path
  end

  # POST /categories
  def create
    @category = Category.new(params[:category])

    if @category.save
      flash[:success] = "Category was successfully created."
      redirect_to @category
    else
      render :action => 'new'
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the category you're looking for cannot be found."
      redirect_to root_path
  end

  # PUT /categories/1
  def update
    @category = Category.find(params[:id])
    
    if @category.update_attributes(params[:category])
      flash[:success] = 'Category was successfully updated.'
      redirect_to @category
    else
      render :action => 'edit'
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the category you're looking for cannot be found."
      redirect_to root_path
  end

  # DELETE /categories/1
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    
    flash[:notice] = "Category was successfully deleted."
    redirect_to root_path
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the category you're looking for cannot be found."
      redirect_to root_path
  end
end
