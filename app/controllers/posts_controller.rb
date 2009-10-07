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
  # GET /posts.xml
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
      format.atom # index.atom.builder
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the post you're looking for cannot be found."
      redirect_to root_path
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end

    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the post you're looking for cannot be found."
      redirect_to root_path
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        flash[:success] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:success] = 'Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the post you're looking for cannot be found."
      redirect_to root_path
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      flash[:notice] = 'Post was deleted.'
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
    
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
