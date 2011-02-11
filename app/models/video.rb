class Video < ActiveRecord::Base
  include Permissions
  
  belongs_to :user
  has_many :meetings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  
  # Path to the temp file uploaded
  attr_accessor :tmp_path
  
  # Create directories and move files before saving
  before_create :finalize_files, :set_title
  
  # Before the record is deleted, delete all files
  before_destroy :delete_files
    
  
  # State machine
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
  
  
  # Recent Uploads
  def self.find_recent_uploads
    time = Date.today - 7.days
    find(:all, :conditions => [ 'created_at > ?', time ], :order => 'created_at DESC' )
  end
  
  def verbose_title
    "#{title} - #{video_file_name}"
  end
  
  def encode
    convert!
    video_recipe  = "ffmpeg -i $input_file$ -ar 22050 -b 500k -i_qfactor 0.9 -qmin 6 -qmax 6 -g 500 -f flv -s $resolution$ -y $output_file$"
    options = { :input_file => video.path,
                :output_file => "#{video.path}.flv",
                :resolution => "640x360"
              }

    video_transcoder = RVideo::Transcoder.new
    begin
      video_transcoder.execute(video_recipe, options)
      converted!
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.error(e.message)
      error!
    end
  end
  
  
  private

  def delete_files
    FileUtils.rm("/var/www/rails_apps/teacherducklings/shared/#{file_path}.flv")
    FileUtils.rm("/var/www/rails_apps/teacherducklings/shared/#{file_path}")
    FileUtils.rmdir("/var/www/rails_apps/teacherducklings/shared/videos/#{id}")
  end
  
  def set_title
    title = "#{current_user.full_name} - #{Date.today.to_s(:long)}"
  end
  
  def finalize_files
    file_path = "/videos/#{id}/#{name}"
    FileUtils.mkdir(file_path)
    FileUtils.mv(tmp_path, file_path)
  end
  
end
