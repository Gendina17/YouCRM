class Task < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :user, foreign_key: :creator_id

  before_create :set_active

  private

  def set_active
    self.active = true
  end
end
