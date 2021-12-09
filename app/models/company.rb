class Company < ApplicationRecord
  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true

  has_many :users
  has_many :clients
  has_many :client_companies
  has_many :emails
  has_many :roles
  has_many :walls
  has_many :statuses
  has_many :categories
  has_many :email_templates
  has_many :events

  belongs_to :email_template, foreign_key: :default_email_id, optional: true

  TYPE_CLIENTS = [[:human, 'Человек'], [:company, 'Компания']]
  TYPE_PRODUCT = [[:product, 'Товар'], [:service, 'Услуга']]
end
