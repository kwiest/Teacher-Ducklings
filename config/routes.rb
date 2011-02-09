ActionController::Routing::Routes.draw do |map|
  map.resources :reviews

  map.resources :links

  map.resources :categories, :only => :show

  map.resources :posts, :only => [:index, :show], :has_many => :comments

  map.resources :meetings
  map.my_meetings '/my_meetings', :controller => 'my_meetings', :action => 'index'
  
  map.resources :users
  
  map.resources :user_sessions
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.resources :password_resets
  
  map.admin '/admin', :controller => 'admin'
  map.namespace :admin, :path_prefix => '/admin', :name_prefix => 'admin_' do |admin|
    admin.resources :reviews, :links, :categories, :meetings
    admin.resources :posts, :has_many => :comments
    admin.resources :users, :has_many => :videos
  end

  map.root :controller => 'index'
end
