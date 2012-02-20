class UsersController < ApplicationController
  before_filter :login_required
  before_filter :find_recent_posts
  before_filter :load_user

  def show
  end
  
  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'User profile successfully updated.'
      redirect_to @user
    else
      render action: 'edit'
    end
  end
  
  
  protected
  
  def load_user
    @user = current_user
  end
end
