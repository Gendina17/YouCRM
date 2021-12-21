ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: 'Основное'

  content title: 'Главная' do
    columns do
      column do
        panel "Основная информация" do
          h3 'Название компании:  ' + current_user.company.name
          h3 'Зарегестрирована в CRM с '  + current_user.company.created_at.to_s.split(' ', 2).first
          h3 'Количество добавленных пользователей: ' + User.company(current_user.company_id).count.to_s
          creator = User.company(current_user.company_id).first
          h3 'Создатель CRM: ' + creator.full_name
          h3 'Основная почта: ' + current_user.company.email
        end
      end

      column do
        panel "Info" do
          h3 'Администраторы:'
          ul do
            User.joins(:role).where(company_id: current_user.company.id).where('roles.is_admin = true').map do |user|
              li link_to(user.full_name, admin_user_path(user))
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Утилиты" do
          li link_to('Информация про YouCrm', admin_crm_info_path)
          li link_to('Уволить пользователя', admin_fired_user_path)
          li link_to('Поменять данные почты компании', admin_change_data_path)
        end
      end
    end
  end
end
