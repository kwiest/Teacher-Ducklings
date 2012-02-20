class PostsController < ApplicationController
  before_filter :find_recent_posts

  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.atom # index.atom.builder
    end
  end

  def show
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: "Sorry, but the post you're looking for cannot be found."
  end
end
