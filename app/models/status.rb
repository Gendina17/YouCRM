class Status < ApplicationRecord
  belongs_to :company

  has_many :tickets

  scope :company,    ->(id) { where(company_id: id) }
end
