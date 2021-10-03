class Company < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  has_many :users
end
