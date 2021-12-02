class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  STATES = ['active', 'busy', 'inactive', nil]

  validates :email, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :name, :surname, presence: true, length: { maximum: 30 }
  validates :password, confirmation: true
  validates_inclusion_of :state, in: STATES

  belongs_to :company
  belongs_to :role
  has_many :walls
  has_and_belongs_to_many :walls
  has_many :emails
  has_many :notes

  before_create :confirmation_token

  scope :company,    ->(id) { where(company_id: id) }
  scope :fired,    -> { where(is_fired: true) }
  scope :not_fired,    -> { where(is_fired: false) }

  # default_scope -> { where(is_fired: false) }

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

  def full_name
    [self.surname, self.name].join(' ')
  end
end
