class UsersController < ApplicationController
  before_filter :logged_in?
  before_filter :authorized?, :only => [:show, :edit, :update]
  before_filter :admin_required, :except => [:show, :edit, :update]
  layout "admin"
  
  # GET /users
  def index
    @users = User.all
  end
  
  
  # GET /users/1
  def show
    @videos = @user.videos
    render :layout => 'application' unless current_user.admin?
  end
  
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  
  # GET /users/1/edit
  def edit
    render :layout => 'application' unless current_user.admin?
  end

  
  # POST /users
  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:success] = "New user created!"
      redirect_to users_path
    else
      render :new
    end
  end
  
  
  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'User was successfully updated.'
      redirect_to @user
    else
      render :edit
    end
  end
  
  
  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:notice] = "User deleted."
    redirect_to users_path
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the user you're looking for cannot be found."
      redirect_to root_path
  end
  
  
  private
  
  def authorized?
    @user = User.find(params[:id])
    @user.changeable_by?(current_user) || access_denied
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "We're sorry, but the user you're looking for cannot be found."
      redirect_to root_path
  end

end
