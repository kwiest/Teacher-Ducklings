class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :categories
  
  validates_presence_of :title, :body
  default_scope :order => 'created_at DESC'
  
  def to_param
    "#{id}-#{title.parameterize}"
  end
  
  def self.find_by_category_name name
    Category.find_by_name(name).posts
  end
end
