class VideosController < ApplicationController
  before_filter :login_required
  before_filter :assign_categories
  before_filter :find_recent_posts
  
  def index
    @videos = current_user.videos
  end

  def show
    @video = current_user.videos.find(params[:id])
    @video.check_encoding_status
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "We're sorry, but the video you're looking for cannot be found."
    redirect_to videos_path
  end

  def new
    @video = current_user.videos.new
    render template: 'shared/videos/new'
  end

  def create
    @video = current_user.videos.create(params[:video])
    if @video.save
      @video.encode!
      redirect_to videos_path, notice: 'Video successfully uploaded. Please give it a few minutes to encode.'
    else
      render template: 'shared/videos/new'
    end
  end
end
