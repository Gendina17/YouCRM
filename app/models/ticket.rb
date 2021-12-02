class Ticket < ApplicationRecord
  belongs_to :client, polymorphic: true, optional: true
  belongs_to :product, polymorphic: true, optional: true
  has_many :notes

  validates_presence_of :subject

  scope :company,    ->(id) { where(company_id: id) }
  scope :client,    ->(id) { where(client_id: id) }
  scope :manager,    ->(id) { where(manager_id: id) }
  scope :open,    -> { where(is_closed: false) }
end
