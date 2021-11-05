ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: 'Main'

  content title: 'Главная' do
    columns do
      column do
        panel "Основная информация" do
          h3 'Название компании:  ' + current_user.company.name
          h3 'Зарегестрирована в CRM с '  + current_user.company.created_at.to_s.split(' ', 2).first
          h3 'Количество добавленных пользователей: ' + User.company(current_user.company_id).count.to_s
          creator = User.company(current_user.company_id).first
          h3 'Создатель CRM: ' + creator.name + ' ' + creator.surname
        end
      end

      column do
        panel "Info" do
          h3 'Администраторы:'
          ul do
            User.joins(:role).where(company_id: current_user.company.id).where(name: 'Администратор').map do |user|
              li link_to(user.name, admin_user_path(user))
            end
          end
        end
      end
    end
  end
end
# пепир треил мож выводить кто менял чтот логирование типа сделать и какие есть роли
# сделать условную базу хранилище мож какиет графики аналитика
