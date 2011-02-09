class Admin::UsersController < AdminController
  before_filter :load_user, :except => [:index, :new, :create]
  
  def index
    @users = User.all
  end
  
  def show
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:success] = "New user created!"
      redirect_to admin_users_path
    else
      render :new
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'User was successfully updated.'
      redirect_to admin_users_path
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    
    flash[:notice] = "User deleted."
    redirect_to admin_users_path
  end
  
  
  protected
  
  def load_user
    @user = load_model(User)
  end
  
end
