class Admin::CommentsController < AdminController
  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = 'Comment successfully deleted.'
    redirect_to admin_post_path(@post)
  end
end