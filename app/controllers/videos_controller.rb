class VideosController < ApplicationController
  before_filter :login_required
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
    params[:video][:user_id] = current_user.id
    @video = Video.new(params[:video])
    @video.title = "#{current_user.full_name} - #{Date.today.to_s(:long)}"
    
    @video.save
    @video.convert!
    Delayed::Job.enqueue EncodingJob.new(@video.id)
    render :partial => 'video'
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
