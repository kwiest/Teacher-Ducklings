ActionController::Routing::Routes.draw do |map|
  map.resources :reviews

  map.resources :links

  map.resources :categories

  map.resources :posts, :has_many => :comments

  map.resources :meetings
  map.my_meetings '/my_meetings', :controller => 'my_meetings', :action => 'index'

  map.root :controller => 'index'
  
  map.resources :users, :has_many => :videos
  
  map.resources :user_sessions
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.resources :password_resets
  
  map.admin '/admin', :controller => 'admin'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
