class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :name, :surname, presence: true, length: { maximum: 30 }
  validates :password, confirmation: true, length: { minimum: 6 }

  belongs_to :company

  def self.authenticate(email, submitted_password, company)
    user = joins(:company).where("companies.name = ?", company)
                          .where(email: email)
                          .first
    return nil if user.nil?
    return user if user.authenticate(submitted_password)
  end
end
