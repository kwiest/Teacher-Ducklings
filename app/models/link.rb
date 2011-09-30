class Link < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_attached_file :document,
    :storage => :s3,
    :bucket => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :url => '/links/:id/:basename.:extension',
    :path => '/links/:id/:basename.:extension'
  
  validates_presence_of :name
  
  default_scope :order => 'name'
end
