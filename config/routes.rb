Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  # Resources all
  resources :users
  resources :crms
  resources :roles
  resources :permissions
  resources :properties
  resources :prospects
  resources :searches

  # Auth Login
  post '/auth/signin', to: 'authentication#signin'
  post '/auth/signup', to: 'authentication#signup'
  
  # Valid
  post '/check/email', to: 'valid#email'

  # Password
  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'

  # Confirmation
  get 'confirmation/link', to: 'confirmation#link'
  post 'confirmation/reset', to: 'confirmation#reset'

  # Oauth Type
  get 'crm/:type/connect', to: 'crms#connect'
  get 'crm/:type/callback', to: 'crms#callback'

  # Search Type
  get 'search/:type/connect', to: 'searches#connect'
  get 'search/:type/callback', to: 'searches#callback'

  # Helath Status
  get '/health', to: 'health#index'

  # Home Status
  get '/', to: 'home#index'

  # Not found
  get '/*a', to: 'application#not_found'
end
