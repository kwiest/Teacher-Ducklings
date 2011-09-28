class Video < ActiveRecord::Base
  include Permissions
  
  belongs_to :user
  has_many :meetings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_attached_file :video,
    :storage        => :s3,
    :bucket         => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id      => ENV['S3_KEY'],
      :secret_access_key  => ENV['S3_SECRET']
    },
    :url  => "/videos/:id/:basename.:extension",
    :path => "/videos/:id/:basename.:extension"
  
  # Path to the temp file uploaded
  attr_accessor :tmp_upload_dir
  
  def fast_video=(file)
    if file && file.respond_to?('[]')
      self.tmp_upload_dir = "#{file['tmp_path']}_1"
      tmp_file_path = "#{self.tmp_upload_dir}/#{file['file_name']}"
      FileUtils.mkdir_p self.tmp_upload_dir
      FileUtils.mv(file['tmp_path'], tmp_file_path)
      self.video = File.new(tmp_file_path, 'rb')
    end
  end
  
  # Clean up
  before_create :set_title
  after_save :clean_tmp_upload_dir
    
  
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
      logger.info "Video could not be converted! #{e.message}"
      error!
    end
  end
  
  # Override default flush_deletes paperclip method
  def flush_deletes
    @queued_for_delete.each do |path|
      begin
        logger.info "[paperclip] Deleting #{path} and #{path}.flv"
        FileUtils.rm(path) if File.exist?(path)
        FileUtils.rm("#{path}.flv") if File.exist?("#{path}.flv")
      rescue Errno::ENOENT => e
        logger.info "[paperclip] ERROR - Could not delete files: #{e.message}"
      end
      
      # Now wind through dirs to remove them
      begin
        while(true)
          path = File.dirname(path)
          FileUtils.rmdir(path)
        end
      rescue Errno::EEXIST, Errno::ENOTEMPTY, Errno::ENOENT, Errno::EINVAL, Errno::ENOTDIR
        # Stop!
      rescue SystemCallError => e
        logger.info "[paperclip] ERROR - Could not delete directories: #{e.class}"
      end
    end
    @queued_for_delete = []
  end
  
  
  private
  
  def clean_tmp_upload_dir
    FileUtils.rm_r(tmp_upload_dir) if self.tmp_upload_dir && File.directory?(tmp_upload_dir)
  end

  def set_title
    title = "#{user.full_name} - #{Date.today.to_s(:med)}"
  end
  
end
