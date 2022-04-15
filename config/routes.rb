Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  # Resources all
  resources :users
  resources :crms
  resources :prospects
  
  # Resources Admin
  # resources :roles
  # resources :permissions

  # Auth Login
  post '/auth/signin', to: 'authentication#signin'
  post '/auth/signup', to: 'authentication#signup'
  get '/auth/logout', to: 'authentication#logout'
  
  # Valid
  post '/check/email', to: 'valid#email'
  post '/check/username', to: 'valid#username'

  # Password
  get '/password/token', to: 'password#token'
  post '/password/forgot', to: 'password#forgot'
  post '/password/reset', to: 'password#reset'

  # Confirmation
  get '/confirmation/link', to: 'confirmation#link'
  post '/confirmation/reset', to: 'confirmation#reset'

  # Oauth Type
  get '/crm/:type/connect', to: 'integration#connect'
  get '/crm/:type/callback', to: 'integration#callback'

  # Search Type
  get '/search/:type/connect', to: 'search#connect'
  get '/search/:type/callback', to: 'search#callback'
  get '/search/:type/list', to: 'search#index'

  # Helath Status
  get '/health', to: 'health#index'

  # Home Status
  get '/', to: 'home#index'

  # Not found
  get '/*a', to: 'application#not_found'
end
