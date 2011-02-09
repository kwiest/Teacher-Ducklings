class Admin::LinksController < AdminController
  before_filter :load_link, :except => [:index, :new, :create]
  
  def index
    @links = Link.all
  end
  
  def show
  end

  def new
    @link = Link.new
  end

  def edit
  end

  def create
    @link = Link.new(params[:link])
    
    if @link.save
      flash[:success] = 'Link was successfully created.'
      redirect_to admin_links_path
    else
      render :new
    end
  end

  def update
    if @link.update_attributes(params[:link])
      flash[:success] = 'Link was successfully updated.'
      redirect_to admin_links_path
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    
    flash[:notice] = 'Link was successfully deleted.'
    redirect_to admin_links_path
  end
  
  
  protected
  
  def load_link
    @link = load_model(Link)
  end
  
end
