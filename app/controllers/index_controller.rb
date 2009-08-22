class IndexController < ApplicationController
  def index
    @posts = Post.find(:all, :limit => 5)
  end

end
