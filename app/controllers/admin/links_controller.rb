class Admin::LinksController < AdminController
  rescue_from ActiveRecord::RecordNotFound, with: :link_not_found
  
  def index
    @links = Link.all
  end
  
  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def edit
    @link = Link.find(params[:id])
  end

  def create
    @link = Link.new(params[:link])
    
    if @link.save
      flash[:success] = 'Link was successfully created.'
      redirect_to admin_links_path
    else
      render action: 'new'
    end
  end

  def update
    @link = Link.find(params[:id])

    if @link.update_attributes(params[:link])
      flash[:success] = 'Link was successfully updated.'
      redirect_to admin_links_path
    else
      render action: 'edit'
    end
  end

  def destroy
    @link = Link.find(params[:id])
    @link.destroy
    
    flash[:notice] = 'Link was successfully deleted.'
    redirect_to admin_links_path
  end
  
  
  protected
  
  def link_not_found
    flash[:error] = 'Sorry, but we could not find that link.'
    redirect_to admin_links_path
  end
  
end
