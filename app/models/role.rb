class Role < ApplicationRecord
  has_many :users
  belongs_to :company

  ACTIONS = {
    add_users: 'Добавление нового пользователя в CRM',
    create_role: 'Создание новых должностей',
    add_user_role: 'Присвоение пользователю должности',
    create_task: 'Создание задач',
    settings: 'Доступ к настройкам CRM',
    admin: 'Доступ к админке',
    show_users: 'Просмотр пользователей'
  }

  scope :company,    ->(id) { where(company_id: id) }
end
