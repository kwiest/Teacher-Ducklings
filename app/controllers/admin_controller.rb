class AdminController < ApplicationController
  before_filter :admin_required
  layout 'admin'
  
  protected
  
  def admin_required
    access_denied unless logged_in? && admin?
  end

end
