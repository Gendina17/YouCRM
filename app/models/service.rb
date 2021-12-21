class Service < ApplicationRecord
  has_paper_trail versions: { class_name: 'TicketVersion' }, ignore: [:updated_at, :created_at]

  has_many :tickets, as: :product

  FIELDS = ['Название', 'Описание', 'Дата', 'Тип', 'Продолжительность', 'Пометки', 'Цена',
    'Скидка' , 'Исполнитель', 'Дата создания', 'Важность']
end
