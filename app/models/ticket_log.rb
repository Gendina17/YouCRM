class TicketLog < ApplicationRecord

  TRANSLATE_ATTRIBUTES = {
    status_id: 'статус', category_id: 'категорю', description: 'описание', manager_id: 'ответственного',
    subject: 'тему', Ticket: 'тикет', Service: 'услугу', name: 'имя', date: 'дату', type_service: 'тип услуги',
    duration: 'продолжительность', price: 'цену', discount: 'скидку', executor: 'исполнителя', type_product: 'тип товара',
    number: 'количество', Product: 'товар', surname: 'фамилию', phone: 'телефон', email: 'почту', address: 'адрес',
    points: 'баллы', password: 'номер паспорта', patronymic: 'отчество', Client: 'клиента', responsible: 'ответственного',
    ClientCompany: 'компанию'
  }

  def self.log_by_paper_trail!(version)
    who = version.whodunnit.present? ? User.find_by(id: version.whodunnit)&.full_name : 'crm'
    version.object_changes.each do |attribute, values|
      case attribute
      when 'manager_id'
        value = values.last.present? ? User.find_by(id: values.last ).full_name : '_'
        prev_value = values.first.present? ? User.find_by(id: values.first ).full_name : '_'
        message = who  + ' изменил(а) ' + TRANSLATE_ATTRIBUTES[attribute.to_sym]  + ': ' + prev_value + ' -> ' + value
      when 'status_id'
        value = values.last.present? ? Status.find_by(id: values.last ).title : '_'
        prev_value = values.first.present? ? Status.find_by(id: values.first ).title : '_'
        message = who  + ' изменил(а) ' + TRANSLATE_ATTRIBUTES[attribute.to_sym]  + ': ' + prev_value + ' -> ' + value
      when 'category_id'
        value = values.last.present? ? Category.find_by(id: values.last ).title : '_'
        prev_value = values.first.present? ? Category.find_by(id: values.first ).title : '_'
        message = who  + ' изменил(а) ' + TRANSLATE_ATTRIBUTES[attribute.to_sym]  + ': ' + prev_value + ' -> ' + value
      when 'is_closed'
        message = who  + ' закрыл(a) тикет '
      else
        value = values.last.present? ? values.last.to_s : '_'
        prev_value = values.first.present? ? values.first.to_s : '_'
        message = who  + ' изменил(а) ' + TRANSLATE_ATTRIBUTES[attribute.to_sym]  + ': ' + prev_value + ' -> ' + value
      end

      create!(
        attribute_name: attribute,
        version_id: version.id,
        loggable_type: version.item_type,
        ticket_id: version.item_type == 'Ticket' ? version.item_id : nil,
        created_at: version.created_at,
        updated_at: version.created_at,
        message: message,
        manager_id: version.whodunnit,
        value: values.last.try(:truncate, 255) || values.last,
        previos_value: values.first.try(:truncate, 255) || values.first,
        item_id: version.item_id
      )
    end
  end

  def self.log_initial!(version)
    who = version.whodunnit.present? ? User.find_by(id: version.whodunnit)&.full_name : 'crm'
    create(
      version_id: version.id,
      loggable_type: version.item_type,
      manager_id: version.whodunnit,
      ticket_id: version.item_type == 'Ticket' ? version.item_id : nil,
      attribute_name: 'create',
      created_at: version.created_at,
      updated_at: version.created_at,
      message: who  + ' создал(а) ' + TRANSLATE_ATTRIBUTES[version.item_type.to_sym],
      item_id: version.item_id
    )
  end
end
