Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  # root "users#login"
  root "home#index"

  resource :users, only: [:create, :update, :destroy, :edit] do
    post :login, on: :collection
    delete :logout, on: :collection
    resources :tasks
  end

  # get '*path', to: 'home#index', via: :all
  # Catch-all for frontend SPA
  get '*path', to: 'home#index', constraints: lambda { |req|
    !req.path.starts_with?("/rails/health") && !req.path.starts_with?("/sidekiq")
  }, via: :all
end
