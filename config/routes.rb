Netflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"
  get "home", to: "videos#index"

  resources :categories, only: [:show]
  resources :videos, only: [:show] do
    post :search, on: :collection
  end

  get    "sign_up",  to: "users#new"
  get    "sign_in",  to: "sessions#new"
  delete "sign_out", to: "sessions#destroy"
  resources :users, only: [:create]
  resources :sessions, only: [:create]
end
