class MeetingsController < ApplicationController
  before_filter :login_required
  
  def index
    @meetings = Meeting.for_user(current_user)
  end
  
  def show
    @meeting = Meeting.find(params[:id])
    unless (@meeting.user_to_meet_with_id.to_i == current_user.id) || current_user.admin
      flash[:error] = "Sorry, but you're not scheduled to attend this meeting."
      redirect_to root_path
    else
      @token = current_user.generate_tok_token(@meeting.tok_session_id)
      @video = @meeting.video
      render :layout => 'meeting'
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Sorry, but that meeting could not be found.'
    redirect_to meetings_path
  end
end
