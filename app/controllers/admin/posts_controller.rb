class Admin::PostsController < AdminController
  rescue_from ActiveRecord::RecordNotFound, with: :post_not_found
  
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])
    
    if @post.save
      flash[:success] = 'Post was successfully published.'
      redirect_to admin_posts_path
    else
      render action: 'new'
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      flash[:success] = 'Post was successfully updated and published.'
      redirect_to admin_posts_path
    else
      render action: 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    
    flash[:notice] = 'Post was successfully deleted.'
    redirect_to admin_posts_path
  end
  
  
  protected
  
  def post_not_found
    flash[:notice] = 'Sorry, but we cannot find that post.'
    redirect_to admin_posts_path
  end
end
