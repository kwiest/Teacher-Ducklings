class Category < ActiveRecord::Base
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :links
  
  validates :name, presence: true
  
  default_scope order: :name

  def self.find_with_posts_and_links(id)
    where(id: id).includes(:posts, :links).first
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
