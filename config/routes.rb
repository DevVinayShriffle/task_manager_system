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

  # ADD THIS (VERY IMPORTANT)
  get '*path', to: 'home#index', via: :all
end
