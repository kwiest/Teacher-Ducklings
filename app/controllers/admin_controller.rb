class AdminController < ApplicationController
  before_filter :admin_required
  before_filter :find_upcoming_meetings
  before_filter :find_recent_videos
  layout 'admin'
  
  protected
  
  def admin_required
    access_denied unless logged_in? && admin?
  end

  def find_upcoming_meetings
    @upcoming_meetings = Meeting.find_upcoming_meetings
  end

  def find_recent_videos
    @recent_videos = Video.find_recent_uploads
  end

end
