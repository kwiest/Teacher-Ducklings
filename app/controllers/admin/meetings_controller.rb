class Admin::MeetingsController < AdminController
  before_filter :load_meeting, :except => [:index, :new, :create]

  def index
    @meetings = Meeting.all(:order => "date")
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
  end

  def show
    @video = @meeting.video
  end

  def new
    @meeting = Meeting.new
  end

  def edit
  end

  def create
    @meeting = current_user.meetings.new(params[:meeting])

    if @meeting.save
      flash[:success] = 'Meeting was successfully created.'
      redirect_to admin_meetings_path
    else
      render :new
    end
  end

  def update
    if @meeting.update_attributes(params[:meeting])
      flash[:success] = 'Meeting was successfully updated.'
      redirect_to admin_meetings_path
    else
      render :edit
    end
  end

  def destroy
    @meeting.destroy

    flash[:notice] = "Meeting Deleted"
    redirect_to admin_meetings_path
  end
  
  
  protected
  
  def load_meeting
    @meeting = load_model(Meeting)
  end
end
