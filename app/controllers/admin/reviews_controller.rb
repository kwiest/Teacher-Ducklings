class Admin::ReviewsController < AdminController
  before_filter :load_review, :except => [:index, :new, :create]
  
  def index
    @reviews = Review.all
  end

  def show
  end

  def new
    @review = current_user.reviews.build
  end

  def edit
  end

  def create
    @review = current_user.reviews.create(params[:review])
    
    if @review.save
      flash[:success] = "You successfully reviewed a video."
      redirect_to admin_reviews_path
    else
      render :new
    end
  end

  def update
    if @review.update_attributes(params[:review])
      flash[:success] = "Your review was successfully updated"
      redirect_to admin_reviews_path
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    
    flash[:notice] = "Your review was successfully deleted."
    redirect_to admin_reviews_path
  end
  
  
  protected
  
  def load_review
    @review = load_model(Review)
  end
end
