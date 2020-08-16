Rails.application.routes.draw do
  get 'cards/new'
  get 'cards/show'
  # devise_for :users
  devise_for :users, controllers: {
    # confirmations: 'users/confirmations',
    # passwords:     'users/passwords',
    registrations: "users/registrations"
    # sessions:      'users/sessions',
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "requests#index"
  resources :users, only: [:edit, :update]
  resources :cards
  resources :requests do
    collection do
      get :contractor_list
      get :client_list
    end
    member do
      get :pay_confirm
      post :pay
    end
    resources :messages, only: [:index, :create]
    namespace :api do
      resources :messages, only: :index, defaults: { format: "json" }
    end
  end
  get "tags/:tag", to: "requests#index", as: :tag
end
