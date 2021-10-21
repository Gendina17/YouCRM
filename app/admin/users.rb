ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :surname, :company_id, :password_digest, :email_confirmed, :confirm_token, :state
  #
  # or
  #
  permit_params do
    permitted = [:name, :email, :surname, :company_id, :password_digest, :email_confirmed, :confirm_token, :state]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  scope("Пассивы", show_count: false){ |scope| scope.com }

  index do |user|
    selectable_column

    column('ID', :id)
    column('Заголовок', :name)
    print user

    actions
  end

end
