class PostsController < ApplicationController
  before_filter :admin_required, :except => [ "index", "show" ]
  uses_tiny_mce(:options => {:theme => 'advanced',
    :browsers => %w{msie gecko},
    :theme_advanced_toolbar_location => "top",
    :theme_advanced_toolbar_align => "left",
    :theme_advanced_resizing => true,
    :theme_advanced_resize_horizontal => false,
    :paste_auto_cleanup_on_paste => true,
    :theme_advanced_buttons1 => %w{formatselect fontsizeselect bold italic underline strikethrough separator justifyleft justifycenter justifyright separator bullist numlist separator link unlink undo redo},
    :theme_advanced_buttons2 => [],
    :theme_advanced_buttons3 => [],
    :plugins => %w{contextmenu paste}},
    :only => [:new, :edit])
  layout :choose_layout

  # GET /posts
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.atom # index.atom.builder
    end
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the post you're looking for cannot be found."
      redirect_to root_path
  end

  # GET /posts/new
  def new
    @post = Post.new

    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the post you're looking for cannot be found."
      redirect_to root_path
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  def create
    @post = Post.new(params[:post])
    
    if @post.save
      flash[:success] = 'Post successfully published.'
      redirect_to @post
    else
      render :new
    end
  end

  # PUT /posts/1
  def update
    @post = Post.find(params[:id])
    
    if @post.update_attributes(params[:post])
      flash[:success] = 'Post successfully updated and published.'
      redirect_to @post
    else
      render :edit
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the post you're looking for cannot be found."
      redirect_to root_path
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    
    flash[:notice] = 'Post successfully deleted.'
    redirect_to posts_path
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the post you're looking for cannot be found."
      redirect_to root_path
  end
  
  
  private
  
  def choose_layout
    if["index", "new", "edit"].include? action_name
      "admin"
    else
      "application"
    end
  end
end
