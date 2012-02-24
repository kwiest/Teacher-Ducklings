class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, only: [:edit, :update]
  before_filter :find_recent_posts, except: [:create, :update]
  before_filter :assign_categories
  
  def new
  end
  
  def edit
  end
  
  def create
    email = params[:user].fetch(:email)
    @user = User.find_by_email(email)
    
    if @user.present?
      @user.deliver_password_reset_instructions!
      flash[:success] = 'Instructions on how to reset your password have been emailed to you.'
      redirect_to root_path
    else
      flash[:error] = "We're sorry, but we couldn't find a user with '#{params[:email]}' as their email address. "
      render action: 'new'
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Your password has been successfully updated.'
      redirect_to root_path
    else
      flash[:notice] = 'Sorry, but your password was not updated. Please try again.'
      render action: 'edit'
    end
  end
  
  
  private
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    
    unless @user.present?
      flash[:error] = "We're sorry, but we could not locate your account. Try pasting the URL from your email into your browser."
      render action: 'new'
    end
  end
  
end
