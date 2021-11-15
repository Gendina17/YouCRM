class Company < ApplicationRecord
  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  has_many :users
  has_many :clients
  has_many :emails
  has_many :roles
  has_many :walls
end
