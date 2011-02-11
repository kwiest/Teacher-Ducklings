class UploadsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    @user = User.find(params[:user_id])
    @video = @user.videos.create(params[:video])
    @video.save
    @video.send_later(:encode)
    render :partial => 'admin/videos/video', :video => @video
  end
end
