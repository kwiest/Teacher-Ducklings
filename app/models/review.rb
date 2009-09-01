class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  
  has_attached_file :pdf,
                    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  validates_attachment_content_type :pdf, :content_type => ['application/pdf']
end
