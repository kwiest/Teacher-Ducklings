class Admin::VideosController < AdminController
  before_filter :load_video, :only => [:show, :destroy]
  
  def index
    @videos = Video.all(:order => 'created_at')
  end

  def show
  end

  def destroy
    @video.destroy
    
    flash[:notice] = "Video successfully deleted"
    redirect_to admin_videos_path
  end
  
  protected
  
  def load_video
    @video = load_model(Video)
  end
end
