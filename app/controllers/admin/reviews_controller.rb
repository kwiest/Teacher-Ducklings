class Admin::ReviewsController < AdminController
  rescue_from ActiveRecord::RecordNotFound, with: :review_not_found
  before_filter :load_video
  
  def show
    @review = @video.reviews.find(params[:id])
  end

  def new
    @review = @video.reviews.new
  end

  def edit
    @review = @video.reviews.find(params[:id])
  end

  def create
    @review_params = params[:review].merge(user_id: current_user.id)
    @review = @video.reviews.new(@review_params)
    
    if @review.save
      flash[:success] = 'Your review was successfully recorded.'
      redirect_to admin_video_path(@video)
    else
      render action: 'new'
    end
  end

  def update
    @review = @video.reviews.find(params[:id])

    if @review.update_attributes(params[:review])
      flash[:success] = 'Your review was successfully updated.'
      redirect_to admin_video_path(@video)
    else
      render action: 'edit'
    end
  end

  def destroy
    @review = @video.reviews.find(params[:id])
    @review.destroy
    
    redirect_to admin_video_path(@video), notice: 'Your review was successfully deleted.'
  end
  
  
  protected
  
  def load_video
    @video = Video.find(params[:video_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_videos_path, notice: 'Sorry, but we cannot find that video.'
  end
  
  def review_not_found
    redirect_to admin_video_path(@video), notice: 'Sorry, but we cannot find that review.'
  end
end
