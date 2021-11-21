class ClientCompany < ApplicationRecord
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  scope :company,    ->(id) { where(company_id: id) }
  belongs_to :company

  FIELDS = {
    name: 'Название', description: 'Описание', phone: 'Телефон', email: 'Почта', address: 'Адрес',
    responsible: 'Представитель компании',  note: 'Заметки',  points: 'Баллы', manager_id: 'Ответственный менеджер'
  }
end
