class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  
  has_attached_file :pdf,
    :storage => :s3,
    :bucket => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :url => '/reviews/:id/:basename.:extension',
    :path => '/reviews/:id/:basename.:extension'
  validates_attachment_content_type :pdf, :content_type => ['application/pdf']
  
  validates_presence_of :description
end
