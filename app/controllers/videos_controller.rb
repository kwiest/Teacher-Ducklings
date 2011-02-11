class VideosController < ApplicationController
  before_filter :login_required
  
  def index
    @videos = current_user.videos.all(:order => 'created_at DESC')
  end

  def show
    @video = current_user.videos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "We're sorry, but the video you're looking for cannot be found."
    redirect_to user_path(current_user)
  end
end
