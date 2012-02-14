require 'opentok'

class Meeting < ActiveRecord::Base
  belongs_to :video
  belongs_to :user, :foreign_key => 'creator_id'
    
  validates_presence_of :date, :time, :video, :user

  def self.find_upcoming_meetings
    upcoming = Date.today + 7
    find(:all, :conditions => [ 'date < ? AND date >= ?', upcoming, Date.today ], :order => 'date')
  end
  
  def days_from_today_to_meeting
    date - Date.today
  end
  
  def expired?
    date < Date.today
  end

  def set_tok_session_id(addr)
    open_tok = OpenTok::OpenTokSDK.new ENV['TOKBOX_API_KEY'], ENV['TOKBOX_API_SECRET']
    session = open_tok.create_session(addr)
    self.tok_session_id = session.session_id
  end
  
end
