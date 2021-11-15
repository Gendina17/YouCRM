class Wall < ApplicationRecord
  belongs_to :user
  belongs_to :company

  TAGS = {
    important: 'Важная информация', interesting: 'Это может быть интересно',
    advertisement: 'Объявление', random: 'Это смешно',
  }

  # validates_inclusion_of :tag, in: TAGS.keys

  scope :company,    ->(id) { where(company_id: id) }
end
