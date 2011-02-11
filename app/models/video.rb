class Video < ActiveRecord::Base
  include Permissions
  
  belongs_to :user
  has_many :meetings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_attached_file :video,
    :url => "/videos/:id/:style/:basename.:extension",
    :path => ":rails_root/:public/videos/:id/:style/:basename.:extension"
  
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
      logger.debug "Video could not be converted! #{e.message}"
      error!
    end
  end
  
  
  private
  
  def clean_tmp_upload_dir
    FileUtils.rm_r(tmp_upload_dir) if self.tmp_upload_dir && File.directory?(tmp_upload_dir)
  end

  def delete_files
    FileUtils.rm("#{video.path}.flv")
  rescue Exception => e
    logger.debug "Flash file for #{video.path} could not be removed. #{e.message}"
  end
  
  def set_title
    title = "#{user.full_name} - #{Date.today.to_s(:med)}"
  end
  
end
