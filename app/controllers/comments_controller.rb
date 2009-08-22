class CommentsController < ApplicationController
  # POST /comments
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:success] = 'Comment was successfully added.'
        format.html { redirect_to posts_path(@comment.post) }
        format.js
      else
        flash[:error] = 'Sorry, but your comment was not submitted. Please make sure you filled out all required fields.'
        format.html { redirect_to posts_path(@comment.post) }
        format.js { flash.discard }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy

    flash[:notice] = "Comment Deleted"
    redirect_to @post
  end
end
