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
  
  def verbose_title
    "#{user.full_name} - #{title}"
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
    
    if system(convert_command)
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
      ffmpeg -i #{RAILS_ROOT + '/public' + self.video.url } -ar 22050 -ab 32 -s 480x272 -vcodec flv -r 25 -qscale 8 -f flv -y #{RAILS_ROOT + '/public' + self.video.url + '.flv'}
    end_command
    
    logger.debug "Converting video...command:" + command
    command 
  end
  
  def set_new_filename
    update_attribute(:video_file_name, video_file_name + '.flv')
    update_attribute(:video_content_type, "application/x-flash-video")
  end
  
end
