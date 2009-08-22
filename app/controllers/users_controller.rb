class UsersController < ApplicationController
  before_filter :authorized?
  layout "admin"
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @videos = @user.videos

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the user you're looking for cannot be found."
      redirect_to root_path
  end
  
  
  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
  end
  
  
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the user you're looking for cannot be found."
      redirect_to root_path
  end

  
  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path
      flash[:success] = "New user created!"
    else
      render :action => 'new'
    end
  end
  
  
  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = 'User was successfully updated.'
        format.html { redirect_to users_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the user you're looking for cannot be found."
      redirect_to root_path
  end
  
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:notice] = "User deleted."
    respond_to do |format|
      format.html { redirect_to users_path }
      format.xml  { head :ok }
    end
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the user you're looking for cannot be found."
      redirect_to root_path
  end

end
