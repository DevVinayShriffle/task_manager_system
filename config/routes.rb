Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "users#new"
  resource :users, only: [:new, :create, :update, :destroy] do
    get :login, on: :collection
    post :login_user, on: :collection
    resources :tasks
  end

end
