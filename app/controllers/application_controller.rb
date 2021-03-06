class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user, :logged_in?, :admin?
  
  
  protected
  
  def load_model(model_class)
    model_class.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "We're sorry, but the #{model_class.to_s.downcase} you're looking for cannot be found."
  end

  def find_recent_posts
    @posts = Post.recent
  end

  def assign_categories
    @categories = Category.all
  end
  
  
  private
  
  def logged_in?
    UserSession.find
  end
  
  def current_user_session  
    return @current_user_session if defined?(@current_user_session)  
    @current_user_session = UserSession.find  
  end  
  
  def current_user  
    @current_user = current_user_session && current_user_session.record  
  end
  
  def login_required
    access_denied unless logged_in?
  end
  
  def admin?
    logged_in? && current_user.admin
  end
  
  def require_no_user
    if logged_in?
      redirect_to root_path, notice: "Sorry, but you can't reset your password if you're already logged in."
    end
  end
  
  def access_denied
    redirect_to root_path, notice: "Sorry, but you don't have access to that page." 
  end

end
