Rails.application.routes.draw do
  devise_for :users 
  
  root "attendances#index"

  resources :attendances, only: [:index, :create, :update]
  resources :leave_requests, only: [:index, :new, :create]

  resources :payments, only: [:index, :new, :create, :show]

  namespace :admin do
    get "audit_logs/index"
    get 'dashboard', to: 'dashboard#index'

    resources :users
    resources :departments
    resources :attendances, only: [:edit, :update, :destroy]
    resources :leave_requests, only: [:index, :update]
    resources :audit_logs, only: [:index]

    resources :payments, only: [:index, :create] do
      member do
        patch :update_request
      end
    end
  end
end
