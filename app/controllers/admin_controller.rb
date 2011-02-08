class AdminController < ApplicationController
  before_filter :admin_required
  layout 'admin'
  
  def index
  end
  
  protected
  
  def admin_required
    access_denied unless logged_in? && current_user.admin == true
  end

end
