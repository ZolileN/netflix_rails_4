Netflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"
  get "home", to: "videos#index"

  resources :categories, only: [:show]
  resources :videos, only: [:show] do
    post :search, on: :collection
    resources :reviews, only: [:create]
  end

  get    "sign_up",  to: "users#new"
  get    "sign_in",  to: "sessions#new"
  delete "sign_out", to: "sessions#destroy"
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]

  get "my_queue", to: "queue_items#index"
  post "update_queue", to: "queue_items#update_queue"
  resources :queue_items, only: [:create, :destroy]

  get "people", to: "relationships#index"
  resources :relationships, only: [:create, :destroy]

  get "forgot_password", to: "forgot_passwords#new"
  get "forgot_password_confirmation", to: "forgot_passwords#confirm"
  resources :forgot_passwords, only: [:create]

  get "expired_token", to: "password_resets#expired_token"
  resources :password_resets, only: [:show, :create]
end
