class UploadsController < ApplicationController
  before_filter :login_required
  
  def create
    @video = current_user.videos.create(params[:video])
    @video.title = "#{current_user.full_name} - #{Date.today.to_s(:long)}"
    @video.save
    @video.send_later(:encode)
    render :partial => 'videos/video'
  end
end
