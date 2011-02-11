class UploadsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    @video = current_user.videos.create(params[:fast_video])
    @video.title = "#{current_user.full_name} - #{Date.today.to_s(:long)}"
    @video.save
    @video.send_later(:encode)
    render :partial => 'videos/video'
  end
end
