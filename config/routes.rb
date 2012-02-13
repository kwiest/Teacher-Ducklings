TeacherDucklings::Application.routes.draw do
  resources :reviews, :links, :users, :meetings
  resources :videos, only: [:index, :show]
  resources :categories, only: :show

  resources :posts, only: [:index, :show] do
    resources :comments
  end
  
  resources :user_sessions
  resources :password_resets
  match '/login'  => 'user_sessions#new'
  match '/logout' => 'user_sessions#destroy'

  namespace :admin do
    resources :reviews, :links, :categories, :meetings, :users, :videos
    resources :posts do
      resources :comments
    end
  end

  root to: 'index#index'
end
