class CommentsController < ApplicationController
  before_filter :find_recent_posts
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:success] = 'Comment was successfully added.'
        format.html { redirect_to @post }
        format.json { 
          flash.discard
          render :partial => 'comments/comment.html.erb', :comment => @comment
        }
      else
        flash[:error] = 'Sorry, but your comment was not submitted. Please make sure you filled out all required fields.'
        format.html { redirect_to posts_path(@post) }
        format.json { flash.discard }
      end
    end
  end
end
