class Product < ApplicationRecord
  belongs_to :company

  FIELDS = ['Название', 'Описание', 'Дата', 'Тип', 'Пометки', 'Цена', 'Скидка', 'Дата создания',
    'Важность', 'Количество']
end
