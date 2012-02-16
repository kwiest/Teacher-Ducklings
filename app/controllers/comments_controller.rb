class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params[:comment])

    if @comment.save
      flash[:success] = 'Comment successfully added.'
      redirect_to @post
    else
      flash[:error] = 'We could not add your comment. Please make sure all required fields are filled-in.'
      redirect_to @post
    end
  end
end
