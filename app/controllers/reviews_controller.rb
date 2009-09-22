class ReviewsController < ApplicationController
  layout "admin"
  
  # GET /reviews
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  def show
    @review = Review.find(params[:id])
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  # POST /reviews
  def create
    @review = Review.new(params[:review])
    @review.user_id = current_user.id
    
    if @review.save
      flash[:success] = "You successfully reviewed a video."
      redirect_to reviews_path
    else
      render :action => "new"
    end
  end

  # PUT /reviews/1
  def update
    @review = Review.find(params[:id])
    
    if @review.update_attributes(params[:review])
      flash[:success] = "Your review was successfully updated"
      redirect_to @review
    else
      render :action => "edit"
    end
  end

  # DELETE /reviews/1
  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    
    flash[:notice] = "Your review was successfully deleted."
    redirect_to reviews_path
  end
  
end
