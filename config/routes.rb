Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  # Resources Admin
  namespace :admin do
    resources :users
    resources :roles
    resources :permissions
  end

  # Resources all
  resources :accounts
  resources :user
  resources :crms
  resources :prospects

  # Auth Login
  post '/auth/signin', to: 'authentication#signin'
  post '/auth/signup', to: 'authentication#signup'
  get '/auth/signup/:token', to: 'authentication#signup_invitation'
  post '/auth/signin/code', to: 'authentication#signin_code'
  get '/auth/signin/valid', to: 'authentication#signin_valid'
  get '/auth/logout', to: 'authentication#logout'
  
  # Valid
  post '/check/email', to: 'valid#email'

  # Password
  get '/password/token', to: 'password#token'
  post '/password/forgot', to: 'password#forgot'
  post '/password/reset', to: 'password#reset'

  # Confirmation
  get '/confirmation/link', to: 'confirmation#link'
  post '/confirmation/reset', to: 'confirmation#reset'

  # Change Email
  get '/email/token', to: 'email#token'
  post '/email/link', to: 'email#link'
  post '/email/change', to: 'email#change'

  # User - Password Reset
  post '/user/password', to: 'user#password'

  # Oauth Type
  get '/crm/:type/connect', to: 'integration#connect'
  get '/crm/:type/callback', to: 'integration#callback'
  get '/crm/:type/select', to: 'integration#select'

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
