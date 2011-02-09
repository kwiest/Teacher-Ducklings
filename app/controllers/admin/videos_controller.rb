class Admin::VideosController < AdminController
  before_filter :load_video, :except => [:index, :new, :create]
  
  def index
    @videos = Video.all
  end

  def show
  end

  def create
    @video = current_user.videos.create(params[:video])
    @video.title = "#{current_user.full_name} - #{Date.today.to_s(:long)}"
    @video.save
    @video.send_later(:encode)
    render :partial => 'video'
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
