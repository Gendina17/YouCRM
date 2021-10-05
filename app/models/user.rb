class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :name, :surname, presence: true, length: { maximum: 30 }
  validates :password, confirmation: true

  belongs_to :company

  before_create :confirmation_token

  def self.authenticate(email, submitted_password, company)
    user = joins(:company).where("companies.name = ?", company)
                          .where(email: email)
                          .first
    return nil if user.nil?
    return user if user.authenticate(submitted_password)
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
