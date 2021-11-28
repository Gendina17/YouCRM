class Product < ApplicationRecord
  has_many :tickets, as: :product

  FIELDS = ['Название', 'Описание', 'Дата', 'Тип', 'Пометки', 'Цена', 'Скидка', 'Дата создания',
    'Важность', 'Количество']
end
