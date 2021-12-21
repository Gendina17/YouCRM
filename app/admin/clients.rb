ActiveAdmin.register Client do
  permit_params :name, :surname, :phone, :email

  scope("Клиенты", show_count: true, default: true){ |scope| scope.company(current_user.company.id) }

  filter :name
  filter :surname
  filter :email
  filter :phone

  index title: "Клиенты" do
    column('Почта', :email)
    column('Имя', :name)
    column('Фамилия', :surname)
    column('Телефон', :phone)
    actions
  end

  show do
    attributes_table do
      row('Почта', :email, &:email)
      row('Имя', :name, &:name)
      row('Фамилия', :surname, &:surname)
      row('Телефон', :phone, &:phone)
    end
  end

  form do |f|
    client
    f.inputs do
      f.input :email
      f.input :name
      f.input :surname
      f.input :phone
    end

    f.actions
  end
end
