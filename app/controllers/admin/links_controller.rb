class LinksController < ApplicationController
  before_filter :admin_required
  layout "admin"
  
  def index
    @links = Link.find(:all)
  end
  
  # GET /links/1
  def show
    @link = Link.find(params[:id])
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links
  def create
    @link = Link.new(params[:link])
    
    if @link.save
      flash[:success] = 'Link was successfully created.'
      redirect_to @link
    else
      render :action => "new"
    end
  end

  # PUT /links/1
  def update
    @link = Link.find(params[:id])
    params[:link][:category_ids] ||= []
    
    if @link.update_attributes(params[:link])
      flash[:success] = 'Link was successfully updated.'
      redirect_to links_path
    else
      render :action => "edit"
    end
  end

  # DELETE /links/1
  def destroy
    @link = Link.find(params[:id])
    @link.destroy
    
    flash[:notice] = 'Link was successfully deleted.'
    redirect_to links_path
  end
  
end
