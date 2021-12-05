class Note < ApplicationRecord
  belongs_to :ticket
  belongs_to :manager, class_name: 'User'
end
