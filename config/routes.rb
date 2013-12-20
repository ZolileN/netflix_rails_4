Netflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"
  get "home", to: "videos#index"

  resources :categories, only: [:show]
  resources :videos, only: [:show] do
    post :search, on: :collection
  end
end
