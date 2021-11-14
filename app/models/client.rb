class Client < ApplicationRecord

  validates :email, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :name, :surname, presence: true, length: { maximum: 30 }

  belongs_to :company

  scope :company,    ->(id) { where(company_id: id) }
end
