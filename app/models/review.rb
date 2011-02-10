class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  
  has_attached_file :pdf,
    :url => "/pdfs/:id/:style/:basename.:extension",
    :path => ":rails_root/public/pdfs/:id/:style/:basename.:extension"
  validates_attachment_content_type :pdf, :content_type => ['application/pdf']
  
  validates_presence_of :description
end
