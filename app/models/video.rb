class Video < ActiveRecord::Base
  include Permissions
  
  belongs_to :user
  has_many :meetings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_attached_file :video,
    :url => "/videos/:id/:style/:basename.:extension",
    :path => ":rails_root/public/videos/:id/:style/:basename.:extension"
  
  validates_attachment_presence :video
  
  # Before the record is deleted, delete all converted flash files
  # to save space
  before_destroy :delete_flv_files
  
  
  # fast_video=(file) method to use nginx fast upload module
  # file should be an array with:
  # [name], [content_type], [path]
  # Temporarily store videos in /var/www/rails_apps/teacherducklings/shared/upload_tmps
  def fast_video=(file)
    if file && file.respond_to?('[]')
      tmp_upload_dir = "/var/www/rails_apps/teacherducklings/shared/upload_tmps"
      tmp_file_path = "#{tmp_upload_dir}/#{file['name']}"
      FileUtils.mv(file['path'], tmp_file_path)
      video = File.new(tmp_file_path)
    end
  end
  
  
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
      capture_screenshot
      converted!
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.error(e.message)
      error!
    end
  end
  
  def capture_screenshot
    transcoder = RVideo::Transcoder.new(video.path)
    transcoder.capture_frame('10s')
  end
  
  
  protected

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
