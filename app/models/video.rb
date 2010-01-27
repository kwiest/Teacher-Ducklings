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
      logger.debug(e.message)
      self.error!
    end
  end

  # Override default "flush_deletes" paperclip method
  def flush_deletes
    @queued_for_delete.each do |path|
      begin
        RAILS_DEFAULT_LOGGER.error("Paperclip deleting #{path}, and #{path}.flv")
	FileUtils.rm(path) if File.exist?(path)
	FileUtils.rm("#{path}.flv") if File.exist?("#{path}.flv")
      rescue Errno::ENOENT => e
        RAILS_DEFAULT_LOGGER.error(e.message)
        # ignore file-not found. let everything else pass
      end
      begin
        while(true)
          path = File.dirname(path)
	  FileUtils.rmdir(path)
	end
      rescue Errno::EEXIST, Errno::ENOTEMPTY, Errno::ENOENT, Errno::EINVAL, Errno::ENOTDIR
        # Stop trying to remove parent directories
      rescue SystemCallError => e
        RAILS_DEFAULT_LOGGER("There was an error while deleting directories: #{e.class}")
	# Ignore it
      end
    end
    @queued_for_delete = []
  end
  
end
