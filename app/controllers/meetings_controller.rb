class MeetingsController < ApplicationController
  before_filter :get_users_and_videos
  layout :choose_layout
  
  # GET /meetings
  # GET /meetings.xml
  def index
    @meetings = Meeting.all(:order => "date")
  end

  # GET /meetings/1
  def show
    @meeting = Meeting.find(params[:id])
    @video = @meeting.video
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
    @meeting = Meeting.find(params[:id])
  end

  # POST /meetings
  def create
    @meeting = Meeting.new(params[:meeting])

    if @meeting.save
      flash[:success] = 'Meeting was successfully created.'
      redirect_to meetings_path
    else
      render :action => "new"
    end
  end

  # PUT /meetings/1
  def update
    @meeting = Meeting.find(params[:id])

    if @meeting.update_attributes(params[:meeting])
      flash[:success] = 'Meeting was successfully updated.'
      redirect_to meetings_path
    else
      render :action => "edit"
    end
  end

  # DELETE /meetings/1
  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.destroy

    flash[:notice] = "Meeting Deleted"
    redirect_to meetings_path
  end
  
  private
  
  def get_users_and_videos
    @users = User.find(:all, :order => "last_name")
    @videos = Video.find(:all, :order => "created_at")
  end

  def choose_layout
    if["show"].include? action_name
      "meeting"
    else
      "admin"
    end
  end
  
end
