class Video < ActiveRecord::Base
  include Permissions
  
  default_scope :order => "created_at DESC"
  
  belongs_to :user
  has_many :meetings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  #has_attached_file :video,
  #  :storage => :s3,
  #  :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
  #  :path => ":attachment/:id/:style.:extension",
  #  :bucket => 'teacherducklingvideostemp'
  has_attached_file :video
  
  #validates_presence_of :title
  validates_attachment_presence :video
  
  
  # Recent Uploads
  def self.find_recent_uploads
    time = Date.today - 7.days
    find(:all, :conditions => [ 'created_at > ?', time ], :order => 'created_at DESC' )
  end
  
  def verbose_title
    "#{user.full_name} - #{title}"
  end
  
end
