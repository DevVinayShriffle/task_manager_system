Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  # resources :users, only: [:create] do
  #   resources :tasks
  # end

  # post '/users/login', to: 'users#login'
  # resource :users, controller: 'users', only: [:update, :destroy]
  # resources :users, only: [:create]

  resource :users, only: [:create, :update, :destroy] do
    post :login, on: :collection
    resources :tasks
  end

end
