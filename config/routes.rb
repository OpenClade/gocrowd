Rails.application.routes.draw do
  # Mount API documentation
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Resources
  namespace :api do
    namespace :v1 do
      resources :auth do 
        post :login, on: :collection
      end
      resources :users, only: %i[index create update] do
        get :me, on: :collection
      end
      resources :investors, only: %i[index create] do 
        get :me, on: :collection
      end
      resources :investments, only: %i[index create] do
        post :upload_bank_statement, on: :member
      end
      resources :offerings, only: %i[index]      
    end
  end
   

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

end
