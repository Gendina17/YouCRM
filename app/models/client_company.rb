class ClientCompany < ApplicationRecord
  has_many_attached :files
  has_paper_trail versions: { class_name: 'TicketVersion' }, ignore: [:updated_at, :created_at]

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :name, length: { maximum: 50 }

  scope :company,    ->(id) { where(company_id: id) }

  belongs_to :company
  has_many :tickets, as: :client
  has_many :events, as: :client
  has_many :emails, as: :client

  before_create :set_default_name

  FIELDS = {
    name: 'Название', description: 'Описание', phone: 'Телефон', email: 'Почта', address: 'Адрес',
    responsible: 'Представитель компании',  note: 'Заметки',  points: 'Баллы', manager_id: 'Ответственный менеджер'
  }

  def full_name
    self.name
  end

  def reverse_full_name
    self.name
  end

  private

  def set_default_name
    if self.name.blank?
      self.name = 'Без имени'
    end
  end
end
