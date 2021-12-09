class Ticket < ApplicationRecord
  has_paper_trail versions: { class_name: 'TicketVersion' }, ignore: [:updated_at, :product_type, :product_id, :client_id, :client_type, :created_at]

  belongs_to :client, polymorphic: true, optional: true
  belongs_to :product, polymorphic: true, optional: true
  belongs_to :manager, class_name: 'User', optional: true
  has_many :notes

  validates_presence_of :subject

  scope :company,    ->(id) { where(company_id: id) }
  scope :client,    ->(id) { where(client_id: id) }
  scope :manager,    ->(id) { where(manager_id: id) }
  scope :open,    -> { where(is_closed: false) }
end
