class UserSessionsController < ApplicationController
  before_filter :find_recent_posts
  before_filter :redirect_home_if_logged_in, only: [:new, :create]
  before_filter :login_required, only: [:destroy]

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
    @user_session = current_user_session
    @user_session.destroy  
    redirect_to root_path, notice: 'Bye now. Come back soon!'
  end


  private

  def redirect_home_if_logged_in
    redirect_to(root_path, notice: 'You are already logged in.') if logged_in?
  end
end
