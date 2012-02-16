class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :categories
  
  validates :title, presence: true
  validates :body,  presence: true

  default_scope order('created_at DESC')
  scope :recent, limit(5)
  
  def to_param
    "#{id}-#{title.parameterize}"
  end
end
