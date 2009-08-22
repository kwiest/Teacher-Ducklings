class Video < ActiveRecord::Base
  belongs_to :user
  has_many :meetings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_attached_file :video
  
  validates_presence_of :title
  validates_attachment_presence :video
  
  
  # Recent Uploads
  def self.find_recent_uploads
    time = Date.today - 7.days
    find(:all, :conditions => [ 'created_at > ?', time ], :order => 'created_at DESC' )
  end
  
  
  # Overwrite default Paperclip method
  # Don't change the name of the file after conversion to .flv
  def rename_file
    true
  end
  
  
  # State Machine
  acts_as_state_machine :initial => :pending
  state :pending
  state :converting
  state :converted, :enter => :set_new_filename
  state :error
  
  event :convert do
    transitions :from => :pending, :to => :converting
  end
  
  event :converted do
    transitions :from => :converting, :to => :converted
  end
  
  event :failure do
    transitions :from => :converting, :to => :error
  end
  
  # Convert video to .flv
  def convert
    self.convert!
    success = system(convert_command)
    debugger
    if success && $?.exitstatus == 0
      self.converted!
    else
      self.failure!
    end
  end
  
  
  protected
  
  def convert_command
    # New file extension
    flv = video_file_name + ".flv"
    
    # Command to execute ffmpeg
    command = <<-end_command
      ffmpeg -i #{RAILS_ROOT + '/public' + self.video.url } #{RAILS_ROOT + '/public' + self.video.url + '.flv'}
    end_command
    
    logger.debug "Converting video...command:" + command
    command 
  end
  
  def set_new_filename
    update_attribute(:filename, flv)
    update_attribute(:content_type, "application/x-flash-video")
  end
  
end
