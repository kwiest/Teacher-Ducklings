# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  helper_method :current_user, :current_user_session, :logged_in?, :login_required, :admin_required, :admin?, :require_no_user
  
  
  protected
  
  def load_model(model_class)
    model_class.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "We're sorry, but the #{model_class.to_s.downcase} you're looking for cannot be found."
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
      flash[:error] = "You can't reset your password if you're already logged in!"
      redirect_to root_path
    end
  end
  
  def access_denied
    flash[:error] = "Sorry, but you don't have access to this section."
    redirect_to root_path
  end

end
