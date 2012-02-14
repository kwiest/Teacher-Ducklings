class Admin::VideosController < AdminController
  before_filter :load_video, :only => [:show, :destroy]

  def show
    @video.check_zencoder_status
  end
  
  def index
    @videos = Video.all(:order => 'created_at DESC')
  end

  def new
    @video = current_user.videos.new
  end

  def create
    @video = current_user.videos.create(params[:video])
    if @video.save
      @video.encode
      flash[:success] = 'Video successfully created!'
      redirect_to admin_videos_path
    else
      render :action => 'new'
    end
  end

  def destroy
    @video.delete_files_from_s3
    @video.destroy
    
    flash[:notice] = "Video successfully deleted"
    redirect_to admin_videos_path
  end
  
  protected
  
  def load_video
    @video = load_model(Video)
  end
end
