Rails.application.routes.draw do
  root "books#index"
  resources :authors
  resources :tags
  resources :comments
  resources :posts
  resources :books
  resources :categories
  resources :reports
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  resources :books do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end




  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
