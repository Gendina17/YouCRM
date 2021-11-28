class Service < ApplicationRecord
  has_many :tickets, as: :product

  FIELDS = ['Название', 'Описание', 'Дата', 'Тип', 'Продолжительность', 'Пометки', 'Цена',
    'Скидка' , 'Исполнитель', 'Дата создания', 'Важность']
end
