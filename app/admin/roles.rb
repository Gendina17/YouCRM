ActiveAdmin.register Role do
  permit_params :name, :description, :the_role

    scope("Должности компании", show_count: true, default: true){ |scope| scope.company(current_user.company.id) }

    filter :name
    filter :users_surname_cont, label: 'User'
    filter :description
    filter :the_role


    index title: "Роли" do
      column('Название', :name)
      column('Описание', :description)
      column('Доступы', :the_role)
      column('Пользователи', :users)
      actions
    end

    show do
      attributes_table do
        row('Почта', :name, &:name)
        row('Имя', :description, &:description)
        row('Фамилия', :the_role, &:the_role)
        row('Пользователи', :users, &:users)
      end
    end

    form do |f|
      role
      f.inputs do
        f.input :name
        f.input :description
        f.input :the_role
      end

      f.actions
    end
end
