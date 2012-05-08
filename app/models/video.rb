class Video < ActiveRecord::Base
  include Permissions
  
  belongs_to :user
  has_many :meetings, dependent: :destroy
  has_many :reviews,  dependent: :destroy
  
  validates :user,            presence: true
  validates :title,           presence: true
  validates :video_file_name, presence: true

  default_scope :order => "created_at DESC"

  before_destroy :delete_files_from_s3
  
  def self.find_recent_uploads
    time = Date.today - 7.days
    find(:all, :conditions => [ 'created_at > ?', time ], :order => 'created_at DESC' )
  end

  # State machine
  state_machine :initial => :uploaded do
    event :convert do
      transition all => :converting
    end
    
    event :complete do
      transition any => :complete
    end
    
    event :error do
      transition any => :error
    end
  end 
  
  def verbose_title
    "#{title} - #{video_file_name}"
  end

  def encoded_file_name
    "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/#{video_file_name}.mp4"
  end
  
  def encode!
    convert!
    encoder = VideoEncoder.new(self)
    job_id = encoder.create_job
    update_attributes(zencoder_job_id: job_id)
  rescue VideoEncoder::EncodingError => e
    encoding_error! e.message
  end

  def check_encoding_status
    return state unless converting?
    result = VideoEncoder.check_job_status(zencoder_job_id)

    case result[:status]
    when 'complete'
      complete!
    when 'converting'
      convert!
    when 'error'
      encoding_error!(result[:message])
    end
    state
  end


  private

  def encoding_error!(message)
    update_attributes(zencoder_error_message: message)
    error!
  end

  def delete_files_from_s3
    aws           = AWS::S3.new(access_key_id: ENV['S3_KEY'], secret_access_key: ENV['S3_SECRET'])
    bucket        = aws.buckets[ENV['S3_BUCKET']]
    video         = bucket.objects[video_file_name]
    encoded_video = bucket.objects["#{video_file_name}.mp4"]

    video.delete
    encoded_video.delete
  end
end
