class Admin::MeetingsController < AdminController
  rescue_from ActiveRecord::RecordNotFound, with: :meeting_not_found

  def index
    @meetings = Meeting.all
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end

  def new
    @meeting = Meeting.new
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def create
    @meeting = Meeting.new(params[:meeting])
    @meeting.set_tok_session_id request.remote_addr

    if @meeting.save
      flash[:success] = 'Meeting was successfully scheduled.'
      redirect_to admin_meetings_path
    else
      render action: 'new'
    end
  end

  def update
    @meeting = Meeting.find(params[:id])
    @meeting.set_tok_session_id request.remote_addr

    if @meeting.update_attributes(params[:meeting])
      flash[:success] = 'Meeting was successfully updated.'
      redirect_to admin_meetings_path
    else
      render action: 'edit'
    end
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.destroy

    flash[:notice] = "Meeting was successfully deleted."
    redirect_to admin_meetings_path
  end
  
  
  protected
  
  def meeting_not_found
    flash[:error] = 'Sorry, but that meeting could not be found.'
    redirect_to admin_meetings_path
  end
end
