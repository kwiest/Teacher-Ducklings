class Video < ActiveRecord::Base
  include Permissions
  
  acts_as_state_machine :initial => :uploaded
  state :uploaded
  state :converting
  state :converted
  state :error
  
  event :convert do
    transitions :to => :converting, :from => :uploaded
  end
  
  event :converted do
    transitions :to => :converted, :from => :converting
  end
  
  event :error do
    transitions :to => :error, :from => :converting
  end
  
  default_scope :order => "created_at DESC"
  
  belongs_to :user
  has_many :meetings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_attached_file :video
  
  #validates_presence_of :title
  validates_attachment_presence :video
  
  
  # Recent Uploads
  def self.find_recent_uploads
    time = Date.today - 7.days
    find(:all, :conditions => [ 'created_at > ?', time ], :order => 'created_at DESC' )
  end
  
  def verbose_title
    "#{title} - #{video_file_name}"
  end
  
  def encode
    recipe  = "ffmpeg -i $input_file$ -ar 22050 -ab 64 -f flv -r 29.97 -s $resolution$ -y $output_file$"
    recipe += "\nflvtool2 -U $output_file$"
    options = { :input_file => video.path,
                :output_file => "#{video.path}.flv",
                :resolution => "640x360"
              }
    
    transcoder = RVideo::Transcoder.new
    begin
      transcoder.execute(recipe, options)
      self.converted!
    rescue Exception => e
      logger.debug(e.message)
      self.error!
    end
  end
  
end
