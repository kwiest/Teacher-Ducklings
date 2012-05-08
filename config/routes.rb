TeacherDucklings::Application.routes.draw do
  resources :links, :users, :meetings, :videos
  resources :categories, only: :show

  resources :posts, only: [:index, :show] do
    resources :comments
  end
  
  resources :user_sessions
  resources :password_resets
  match '/login'  => 'user_sessions#new'
  match '/logout' => 'user_sessions#destroy'

  namespace :admin do
    resources :links, :categories, :meetings, :users

    resources :posts do
      resources :comments
    end

    resources :videos do
      resources :reviews
    end

    root to: 'dashboard#index'
  end

  root to: 'index#index'
end
