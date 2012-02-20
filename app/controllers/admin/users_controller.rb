class Admin::UsersController < AdminController
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:success] = 'New user was successfully created.'
      redirect_to admin_users_path
    else
      render action: 'new'
    end
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:success] = 'User was successfully updated.'
      redirect_to admin_users_path
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully deleted.'
  end
  
  
  protected
  
  def user_not_found
    redirect_to admin_users_path, notice: 'Sorry, but that user could not be found.'
  end
  
end
