ActiveAdmin.register Role do
  permit_params :name, :description, :the_role

    scope("Должности компании", show_count: true, default: true){ |scope| scope.company(current_user.company.id) }

    filter :name
    filter :users
    filter :description
    filter :the_role


    index title: "Роли" do
      column('Название', :name)
      column('Описание', :description)
      column('Доступы', :the_role)
      actions
    end

    show do
      attributes_table do
        row('Почта', :name, &:name)
        row('Имя', :description, &:description)
        row('Фамилия', :the_role, &:the_role)
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
#либо переопределить мтеод создания либо инхерит поле сделать
