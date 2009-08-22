class AdminController < ApplicationController
  before_filter :admin_required
  
  def index
    @videos = Video.find_recent_uploads
    @upcoming_meetings = Meeting.find_upcoming_meetings
  end

end
