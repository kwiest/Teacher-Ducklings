class Category < ActiveRecord::Base
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :links
  
  validates_presence_of :name
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
end
