Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers, only: [:index, :show, :create, :update, :destroy] do
        patch :move_stage, on: :member
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end