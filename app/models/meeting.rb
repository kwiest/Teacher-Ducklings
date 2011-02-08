class Meeting < ActiveRecord::Base
  belongs_to :video
    
  validates_presence_of :date, :time
  
  def self.find_upcoming_meetings
    upcoming = Date.today + 7
    find(:all, :conditions => [ 'date < ? AND date >= ?', upcoming, Date.today ], :order => 'date')
  end
  
  def self.find_recent_meetings
    past = Date.today - 7
    find(:all, :conditions => [ 'date > ? AND date < ?', past, Date.today ], :order => 'date')
  end
  
  def days_from_today_to_meeting
    date - Date.today
  end
  
  def expired?
    date < Date.today
  end
  
end
