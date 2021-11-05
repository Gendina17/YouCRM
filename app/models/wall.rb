class Wall < ApplicationRecord
  belongs_to :user
  belongs_to :company

  scope :company,    ->(id) { where(company_id: id) }
end
