Rails.application.routes.draw do
  get '/', to: 'main#index'
  get '/identification', to: 'registration#identification'
  post '/create_room', to: 'registration#create_room'
  post '/authorization', to: 'registration#authorization'
  root 'main#index'
  resources :registration do
    member do
      get 'confirm_email'
    end
  end
end
