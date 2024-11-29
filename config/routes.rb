Rails.application.routes.draw do
  # Mount API documentation
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Concern to wrap non-GET routes in a transaction
  concern :transactional do
    post :create, on: :collection
    put :update, on: :member
    patch :update, on: :member
    delete :destroy, on: :member
  end

  # Resources
  resources :offerings, concerns: :transactional
  resources :investors, only: [:show, :create, :update], concerns: :transactional
  resources :investments, only: [:index, :show, :create, :update], concerns: :transactional do
    member do
      post :upload_bank_statement
    end
  end
  resources :users, concerns: :transactional
  resources :auth, only: [:create], concerns: :transactional

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

end
