class IndexController < ApplicationController
  before_filter :assign_categories
  before_filter :find_recent_posts

  def index
  end
end
