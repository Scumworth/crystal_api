Rails.application.routes.draw do
  resources :profiles, :teams, :users
  post '/auth/login', to: 'authentication#login'
end
