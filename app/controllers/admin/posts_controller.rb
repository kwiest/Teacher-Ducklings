class Admin::PostsController < AdminController
  before_filter :load_post, :except => [:index, :new, :create]
  
  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  # POST /posts
  def create
    @post = Post.new(params[:post])
    
    if @post.save
      flash[:success] = 'Post successfully published.'
      redirect_to admin_posts_path
    else
      render :new
    end
  end

  def update
    if @post.update_attributes(params[:post])
      flash[:success] = 'Post successfully updated and published.'
      redirect_to admin_posts_path
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    
    flash[:notice] = 'Post successfully deleted.'
    redirect_to admin_posts_path
  end
  
  
  protected
  
  def load_post
    @post = load_model(Post)
  end
end
