class Email < ApplicationRecord
  STATE = {incoming: true , outgoing: false}

  validates :to, :from, :subject, :body, presence: true
  validates_format_of :to, :from, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  belongs_to :company
  belongs_to :manager, class_name: 'User', optional: true
  belongs_to :client, polymorphic: true, optional: true

  scope :company,    ->(id) { where(company_id: id) }
end
