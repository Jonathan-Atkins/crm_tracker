Rails.application.routes.draw do
  resources :customers, only: [:index, :show, :create, :destroy] do
    patch :move_stage, on: :member
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

