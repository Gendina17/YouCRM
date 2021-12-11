Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'main#index'

  get '/', to: 'main#index'
  get '/change_state', to: 'main#change_state'
  get '/not_new', to: 'main#not_new'
  get '/show_ticket', to: 'main#show_ticket'
  post '/update_ticket', to: 'main#update_ticket'
  get '/sort_ticket', to: 'main#sort_ticket'
  get '/ticket_close', to: 'main#ticket_close'
  get '/update_close_ticket', to: 'main#update_close_ticket'
  post '/update_client', to: 'main#update_client'
  post '/add_files_to_client', to: 'main#add_files_to_client'
  get '/show_files', to: 'main#show_files'
  get '/send_client_mail', to: 'main#send_client_mail'
  get '/show_emails', to: 'main#show_emails'
  post '/create_note', to: 'main#create_note'
  post '/update_note', to: 'main#update_note'
  get '/delete_note', to: 'main#delete_note'
  post '/update_product', to: 'main#update_product'
  post '/create_ticket', to: 'main#create_ticket'
  get '/template_selection', to: 'main#template_selection'
  post '/create_client', to: 'main#create_client'
  get '/update_params', to: 'main#update_params'

  get '/settings', to: 'settings#settings'
  post '/update', to: 'settings#update'
  post '/update_avatar', to: 'settings#update_avatar'
  post '/create', to: 'settings#create'
  post '/create_role', to: 'settings#create_role'
  post '/add_role_to_user', to: 'settings#add_role_to_user'
  get '/all_users_in_role', to: 'settings#all_users_in_role'
  get '/dell_role', to: 'settings#dell_role'
  post '/update_role', to: 'settings#update_role'
  get '/all_walls', to: 'settings#all_walls'
  post '/create_wall', to: 'settings#create_wall'
  post '/create_wall_with_attach', to: 'settings#create_wall_with_attach'
  post '/add_email', to: 'settings#add_email'
  post '/create_task', to: 'settings#create_task'
  get '/tasks', to: 'settings#tasks'
  get '/inactive', to: 'settings#inactive'
  post '/update_company_avatar', to: 'settings#update_company_avatar'
  post '/set_clients_fields', to: 'settings#set_clients_fields'
  post '/set_type_product', to: 'settings#set_type_product'
  post '/create_template', to: 'settings#create_template'
  post '/update_template', to: 'settings#update_template'
  get '/delete_template', to: 'settings#delete_template'
  get '/set_default_template', to: 'settings#set_default_template'
  get 'show_template', to: 'settings#show_template'
  post '/create_status', to: 'settings#create_status'
  get '/delete_status', to: 'settings#delete_status'
  post '/create_category', to: 'settings#create_category'
  get '/delete_category', to: 'settings#delete_category'

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

  namespace :admin do
    resources :analytics, only: [:index]
  end
end
