Rails.application.routes.draw do
  resources :customers, only: [:index, :show, :create] do
    member do
      patch :move_stage
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
