class MyMeetingsController < ApplicationController
  before_filter :login_required
  
  def index
    @meetings = Meeting.find_by_user_to_meet_with_id(current_user.id, :order => 'date DESC')
  end

end
