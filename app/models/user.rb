class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :videos, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_attached_file :photo,
                    :styles => { :small => "50x50", :medium => "150x150" },
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"

  validates_presence_of :first_name, :last_name, :email
  
  def full_name
    [first_name, last_name].join(" ")
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self)
  end
  
end
