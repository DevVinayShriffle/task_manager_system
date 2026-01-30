Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :users, only: [:create, :update, :destroy] do
    resources :tasks
  end

  post '/users/login', to: 'users#login'
end
