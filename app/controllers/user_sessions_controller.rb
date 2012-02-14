class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end
  
  def create  
    @user_session = UserSession.new(params[:user_session])  
    if @user_session.save  
      current_user.update_attributes(last_login_at: Time.now)
      flash[:success] = "Hi #{current_user.first_name}, so good to see you again!"  
      if current_user.admin?
        redirect_to admin_root_path
      else
        redirect_to root_path
      end
    else  
      render :action => 'new'  
    end  
  end

  def destroy
    @user_session = UserSession.find  
    @user_session.destroy  
    flash[:notice] = "Bye now. Come back soon!"  
    redirect_to root_path
  end

end
