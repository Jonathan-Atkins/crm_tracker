Rails.application.routes.draw do
  resources :customers, only: [:index, :show, :create]

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
