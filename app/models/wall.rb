class Wall < ApplicationRecord
  belongs_to :user
  belongs_to :company
  has_and_belongs_to_many :users

  has_one_attached :attach

  TAGS = {
    important: 'Важная информация', interesting: 'Это может быть интересно',
    advertisement: 'Объявление', random: 'Это смешно',
  }

  # validates_inclusion_of :tag, in: TAGS.keys

  scope :company,    ->(id) { where(company_id: id) }
end
