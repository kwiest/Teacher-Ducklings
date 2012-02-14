class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :categories
  
  validates_presence_of :title, :body
  default_scope :order => 'created_at DESC'
  
  def to_param
    "#{id}-#{title.parameterize}"
  end
end
