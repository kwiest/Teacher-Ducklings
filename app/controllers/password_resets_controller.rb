class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  before_filter :find_recent_posts
  
  def new
  end
  
  def edit
  end
  
  def create
    @user = User.find_by_email(params[:email])
    
    if @user
      @user.deliver_password_reset_instructions!
      flash[:success] = "Instructions on how to reset your password have been emailed to you. Please check your email."
      redirect_to root_path
    else
      flash[:error] = "We're sorry, but we couldn't find a user with '#{params[:email]}' as their email address. " +
      "Is it possible you made an error while typing?"
      render :action => "new"
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Congratulations on reseting your password. Try not to forget it this time!"
      redirect_to root_path
    else
      flash[:error] = "There was an error trying to reset your password. Please give it another shot."
      render :action => 'edit'
    end
  end
  
  
  private
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    
    unless @user
      flash[:error] = "We're sorry, but we could not locate your account. Try pasting the URL from your email into " + 
      "your browser, OR, just bite the bullet and start the process over again."
      render :action => "new"
    end
  end
  
end
