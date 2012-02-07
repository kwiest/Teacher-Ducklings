class MeetingsController < ApplicationController
  before_filter :login_required
  
  def index
    @meetings = Meeting.all(:conditions => { :user_to_meet_with_id => current_user.id }, :order => 'date ASC')
  end
  
  def show
    @meeting = Meeting.find(params[:id])
    unless (@meeting.user_to_meet_with_id.to_i == current_user.id) || current_user.admin
      flash[:error] = "Sorry, this meeting isn't for you!"
      redirect_to root_path
    else
      @token = current_user.generate_tok_token(@meeting.tok_session_id)
      @video = @meeting.video
      render :layout => 'meeting'
    end
  end
end
