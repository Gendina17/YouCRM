class Event < ApplicationRecord
  belongs_to :client, polymorphic: true, optional: true
  belongs_to :manager, class_name: 'User'
  belongs_to :company

  scope :company,    ->(id) { where(company_id: id) }
end
