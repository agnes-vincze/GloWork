Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :moodtrackers, only: %i[new create index show edit update]
  resources :suggestions, only: %i[new create index update] do
    resources :suggestions_comments, only: %i[create destroy]
    resource :likes, only: %i[create destroy]
  end
  resources :events
  resources :teams, only: [:index, :show]
  resources :users, only: [:create]
  get "dashboard", to: "pages#dashboard"
  resources :questions, only: [:index, :create]
end
