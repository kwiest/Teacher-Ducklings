class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  
  has_attached_file :pdf
  validates_attachment_content_type :pdf, :content_type => ['application/pdf']
end
