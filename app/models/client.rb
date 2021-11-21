class Client < ApplicationRecord
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :name, :surname, presence: true, length: { maximum: 30 }

  belongs_to :company

  FIELDS = {
    name: 'Имя', surname: 'Фамилия', patronymic: 'Отчество', description: 'Описание', phone: 'Телефон',
    email: 'Почта', address: 'Адрес',  note: 'Заметки',  points: 'Баллы', manager_id: 'Ответственный менеджер',
    password: 'Паспорт'
  }

  scope :company,    ->(id) { where(company_id: id) }
end
