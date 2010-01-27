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
    video_recipe  = "ffmpeg -i $input_file$ -ar 22050 -b 500k -i_qfactor 0.9 -qmin 6 -qmax 6 -g 500 -f flv -s $resolution$ -y $output_file$"
    options = { :input_file => video.path,
                :output_file => "#{video.path}.flv",
                :resolution => "640x360"
              }

    video_transcoder = RVideo::Transcoder.new
    begin
      video_transcoder.execute(video_recipe, options)
      self.converted!
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.error(e.message)
      self.error!
    end
  end

  def delete_flv_files
    each_attachment do |name, attachment|
      begin
        path = "#{attachment.path}.flv"
        RAILS_DEFAULT_LOGGER.info("Attempting to delete #{path}")
        FileUtils.rm(path) if File.exist?(path)
      rescue Errno::ENOENT => e
        RAILS_DEFAULT_LOGGER.info(e.message)
        # Log it, then ignore and move on
      end
    end
  end
  
end
