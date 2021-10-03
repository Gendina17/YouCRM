Rails.application.routes.draw do
  get 'main/index'
  get '/identification', to: 'registration#identification'
  post '/create_room', to: 'registration#create_room'
  post '/authorization', to: 'registration#authorization'
  root 'main#index'
  # resources :session, only: %i[new create destroy]
end
