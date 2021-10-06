Rails.application.routes.draw do
  root 'main#index'
  get '/', to: 'main#index'

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
end
