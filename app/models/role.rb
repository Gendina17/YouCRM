class Role < ApplicationRecord
  has_many :users
  belongs_to :company

  ACTIONS = {
    add_users: 'Добавление новго пользователя в CRM',
    create_role: 'Возможность создавать новые должности и присваивать им роли',
    add_user_role: 'Присвоение пользователю новой должности',
    create_task: 'Создание задач пользователям',
  }

  scope :company,    ->(id) { where(company_id: id) }
end
