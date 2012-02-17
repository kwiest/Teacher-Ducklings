require 'opentok'

class Meeting < ActiveRecord::Base
  belongs_to :video
  belongs_to :moderator, foreign_key: 'creator_id', class_name: 'User'
  belongs_to :user,      foreign_key: 'user_to_meet_with_id'
    
  validates :date,  presence: true
  validates :time,  presence: true
  validates :video, presence: true
  validates :user,  presence: true

  default_scope includes(:video, :moderator, :user).order('date ASC')
  scope :for_user, lambda { |user| where(user_to_meet_with_id: user) }
  scope :for_moderator, lambda { |mod| where(creator_id: mod) }

  def self.find_upcoming_meetings
    now      = Date.today
    upcoming = now + 7

    where("date >= :start_date AND date < :end_date",
          { start_date: now, end_date: upcoming }) 
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
