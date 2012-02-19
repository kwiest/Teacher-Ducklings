class Admin::CommentsController < AdminController
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = 'Comment successfully deleted.'
    redirect_to admin_post_path(@post)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Sorry, but we could not find what you're looking for."
    redirect_to admin_posts_path
  end
end
