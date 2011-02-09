class UsersController < ApplicationController
  before_filter :load_user

  def show
  end
  
  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'User was successfully updated.'
      redirect_to @user
    else
      render :edit
    end
  end
  
  
  protected
  
  def load_user
    @user = current_user
  end
end
