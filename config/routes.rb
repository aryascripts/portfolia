Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # OAuth routes
  use_doorkeeper

  # Session routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Redirect root to accounts
  root to: redirect('/accounts')

  resources :accounts, only: [:index, :new, :create, :show]
  resources :imports, only: [:index, :create]
  post '/import/csv', to: 'accounts#import'
  get '/import', to: 'accounts#import'
end
