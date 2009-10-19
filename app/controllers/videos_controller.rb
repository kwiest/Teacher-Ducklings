class VideosController < ApplicationController
  before_filter :login_required, :only => [:index, :create, :destroy]
  before_filter :authorized?, :except => [:index, :create, :destroy]
  before_filter :admin_required, :only => :destroy
  
  # GET /user/id/videos
  def index
    @user = User.find(params[:user_id])
    if @user.admin
      @videos = Video.all
      render :layout => 'admin'
    else
      @videos = @user.videos
    end
  end

  # GET /user/id/videos/1
  def show
  end

  # POST /user/id/videos
  def create
    params[:video][:user_id] = params[:user_id]
    @video = Video.new(params[:video])
    @video.video_content_type = MIME::Types.type_for(@video.video_file_name)
    
    @video.save
    render :text => "<a href=\"#{user_video_path(current_user, @video)}\">Watch Now</a>"
  end

  # DELETE /user/id/videos/1
  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    
    flash[:notice] = "Video successfully deleted"
    redirect_to :back
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the video you're looking for cannot be found."
      redirect_to root_path
  end
  
  private
  
  def authorized?
    @video = Video.find(params[:id])
    @video.changeable_by?(current_user) || access_denied
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the video you're looking for cannot be found."
      redirect_to root_path
  end
  
end
