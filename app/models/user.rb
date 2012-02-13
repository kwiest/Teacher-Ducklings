require 'opentok'

class User < ActiveRecord::Base
  include Permissions
  
  default_scope :order => :last_name
  
  acts_as_authentic
  
  has_many :videos, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :meetings, :dependent => :destroy, :foreign_key => "creator_id"

  has_attached_file :photo,
    :storage => :s3,
    :bucket => ENV['S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :url => '/photos/:id/:basename.:extension',
    :path => '/photos/:id/:basename.:extension'

  validates_presence_of :first_name, :last_name, :email
  
  def full_name
    [first_name, last_name].join(" ")
  end
  alias_method :name, :full_name
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver
  end
  
  def user
    self
  end

  def generate_tok_token(session_id)
    open_tok = OpenTok::OpenTokSDK.new ENV['TOKBOX_API_KEY'], ENV['TOKBOX_API_SECRET']
    open_tok.generate_token(:session_id => session_id, :connection_data => "name=#{full_name}")
  end

end
