class Link < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_attached_file :document
  
  validates_presence_of :name
  
  default_scope :order => 'name'
end
