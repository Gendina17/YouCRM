Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'main#index'
  get '/', to: 'main#index'
  get '/settings', to: 'main#settings'
  get '/change_state', to: 'main#change_state'
  post '/update', to: 'main#update'
  post '/update_avatar', to: 'main#update_avatar'
  post '/update_company_avatar', to: 'main#update_company_avatar'
  post '/create', to: 'main#create'
  post '/create_role', to: 'main#create_role'
  post '/add_role_to_user', to: 'main#add_role_to_user'
  get '/all_users_in_role', to: 'main#all_users_in_role'
  get '/all_walls', to: 'main#all_walls'
  post '/create_wall', to: 'main#create_wall'
  post '/create_wall_with_attach', to: 'main#create_wall_with_attach'
  post '/add_email', to: 'main#add_email'
  get '/dell_role', to: 'main#dell_role'
  post '/update_role', to: 'main#update_role'
  post '/create_task', to: 'main#create_task'
  get '/tasks', to: 'main#tasks'
  get '/inactive', to: 'main#inactive'
  get '/not_new', to: 'main#not_new'
  post '/set_clients_fields', to: 'main#set_clients_fields'
  post '/set_type_product', to: 'main#set_type_product'
  post '/create_status', to: 'main#create_status'
  post '/create_category', to: 'main#create_category'
  get '/delete_category', to: 'main#delete_category'
  get '/delete_status', to: 'main#delete_status'

  get '/identification', to: 'registration#identification'
  get '/destroy', to: 'registration#destroy'
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
