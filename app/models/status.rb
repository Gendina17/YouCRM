class Status < ApplicationRecord
  belongs_to :company
  scope :company,    ->(id) { where(company_id: id) }
end
