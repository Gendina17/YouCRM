class Client < ApplicationRecord
  has_many_attached :files
  has_paper_trail versions: { class_name: 'TicketVersion' }, ignore: [:updated_at, :created_at]

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :name, :surname, length: { maximum: 30 }

  belongs_to :company
  has_many :tickets, as: :client
  has_many :events, as: :client
  has_many :emails, as: :client

  before_create :set_default_name

  FIELDS = {
    name: 'Имя', surname: 'Фамилия', patronymic: 'Отчество', description: 'Описание', phone: 'Телефон',
    email: 'Почта', address: 'Адрес',  note: 'Заметки',  points: 'Баллы', manager_id: 'Ответственный менеджер',
    password: 'Паспорт'
  }

  scope :company,    ->(id) { where(company_id: id) }

  def full_name
    [surname, name].join(' ')
  end

  private

  def set_default_name
    if self.name.blank? && self.surname.blank?
      self.name = 'Без'
      self.surname = 'Имени'
    end
  end
end
