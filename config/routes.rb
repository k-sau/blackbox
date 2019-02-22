Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get '/home', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/two_factor_auth', to: 'two_factor_auth#new'
  post '/two_factor_auth_verify', to: 'two_factor_auth#create'
  get '/two_factor_login_verify', to: 'two_factor_auth#verify'
  post '/two_factor_login_verify', to: 'two_factor_auth#verify_post'
  resources :users
end
