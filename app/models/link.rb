class Link < ActiveRecord::Base
  has_and_belongs_to_many :categories
  
  validates_presence_of :name, :url
  
  default_scope :order => 'name'
end
