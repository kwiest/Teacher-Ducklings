class Video < ActiveRecord::Base
  include Permissions
  
  belongs_to :user
  has_many :meetings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  
  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :video_file_name

  default_scope :order => "created_at DESC"

  # Callbacks
  after_create :encode
  before_destroy :delete_files_from_s3

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
  
  
  # Recent Uploads
  def self.find_recent_uploads
    time = Date.today - 7.days
    find(:all, :conditions => [ 'created_at > ?', time ], :order => 'created_at DESC' )
  end
  
  def verbose_title
    "#{title} - #{video_file_name}"
  end
  
  def encode
    response = Zencoder::Job.create(
      { 
        :input => "s3://#{ENV['S3_BUCKET']}/#{self.video_file_name}",
        :outputs => [
          { 
            :video_codec => "h264",
            :url => "s3://#{ENV['S3_BUCKET']}/#{self.video_file_name}.mp4",
            :access_control => [
              {
                :grantee => "http://acs.amazonaws.com/groups/global/AllUsers",
                :permission => "READ"
              },
              {
                :grantee => "kyle.wiest@gmail.com",
                :permission => "FULL_CONTROL"
              }
            ]
          }
        ]
      }
    )
    self.zencoder_job_id = response.body.fetch 'id' do
      self.zencoder_error_message = "Could not successfully queue job on Zencoder"
      error!
      return response
    end

    convert!
    response
  rescue Zencoder::HTTPError => e
    self.zencoder_error_message = e.message
    $Log.info "#{e.message} - error"
    error!
    response
  end

  def check_zencoder_status
    return "processed" unless converting?

    result = Zencoder::Job.details(self.zencoder_job_id)
    status = result.body['job']['state']

    if status == "finished"
      complete!
    elsif status == "processing"
      return status
    elsif status == "failed"
      self.zencoder_error_message = result.body['job']['input_media_file']['error_message']
      error!
    end
    
    status
  end

  def encoded_file_name
    "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/#{self.video_file_name}.mp4"
  end
  

  private

    def delete_files_from_s3
      aws           = Aws::S3.new(ENV['S3_KEY'], ENV['S3_SECRET'])
      bucket        = aws.bucket(ENV['S3_BUCKET'])
      video         = bucket.key(self.video_file_name)
      encoded_video = bucket.key(encoded_file_name)

      video.delete
      encoded_video.delete
    end
end
