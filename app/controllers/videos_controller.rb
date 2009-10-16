class VideosController < ApplicationController
  before_filter :admin_required, :only => [:all_videos]
  before_filter :authorized?, :except => [:all_videos]
  
  # GET /user/id/videos
  # GET /user/id/videos.xml
  def index
    @videos = Video.find_all_by_user_id(params[:user_id])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end

  # GET /user/id/videos/1
  # GET /user/id/videos/1.xml
  def show
    @video = Video.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the video you're looking for cannot be found."
      redirect_to root_path
  end

  # GET /user/id/videos/new
  # GET /user/id/videos/new.xml
  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /user/id/videos/1/edit
  def edit
    @video = Video.find(params[:id])
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "We're sorry, but the video you're looking for cannot be found."
    redirect_to root_path
  end

  # POST /user/id/videos
  # POST /user/id/videos.xml
  def create
    @video = Video.new(params[:video])

    respond_to do |format|
      if @video.save
        flash[:success] = 'Video was successfully uploaded.'
        format.html { redirect_to user_videos_path }
        format.xml  { render :xml => @video, :status => :created, :location => @video }
      else
        flash[:error] = 'We\'re sorry, but there was an error while trying to upload your video.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user/id/videos/1
  # PUT /user/id/videos/1.xml
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        flash[:success] = 'Video was successfully updated.'
        format.html { redirect_to user_video_path(@video.user_id, @video) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "We're sorry, but the video you're looking for cannot be found."
    redirect_to root_path
  end

  # DELETE /user/id/videos/1
  # DELETE /user/id/videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    
    flash[:notice] = "Video successfully deleted"
    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "We're sorry, but the video you're looking for cannot be found."
    redirect_to root_path
  end
  
  # All videos
  # Admin only
  def all_videos
    @videos = Video.find(:all, :order => 'created_at')
    
    respond_to do |format|
      format.html { render :layout => "admin" }
      format.xml { render :xml => @videos }
    end
  end
  
  private
  
end
