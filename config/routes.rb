Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  
  resources :users, only: [:create, :update, :destroy] do
    resources :tasks
  end

  post '/users/login', to: 'users#login'

  # ADD THIS (VERY IMPORTANT)
  get '*path', to: 'home#index', via: :all
end
