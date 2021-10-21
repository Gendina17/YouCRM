Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'main#index'
  get '/', to: 'main#index'
  get '/settings', to: 'main#settings'
  get '/change_state', to: 'main#change_state'

  get '/identification', to: 'registration#identification'
  get '/send_password', to: 'registration#send_password'
  post '/create_room', to: 'registration#create_room'
  post '/authorization', to: 'registration#authorization'

  resources :registration do
    member do
      get 'confirm_email'
      get 'new_password'
      post 'password_recovery'
    end
  end

  resources :messages, only: [:index, :create]
end
