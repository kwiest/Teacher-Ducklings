class PostsController < ApplicationController
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
      flash[:error] = "We're sorry, but the post you're looking for cannot be found."
      redirect_to root_path
  end
end
