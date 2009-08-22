class MyProfilesController < ApplicationController
  before_filter :login_required
  
  def show
    @user = User.find(current_user.id)
  end

  def edit
    @user = User.find(current_user.id)
  end
  
  def update
    @user = User.find(current_user.id)
    
    if @user.update_attributes(params[:user])
      flash[:success] = 'You have successfully updated your profile!'
      redirect_to my_profile_path
    else
      format.html { render :action => "edit" }
    end
  end

end
