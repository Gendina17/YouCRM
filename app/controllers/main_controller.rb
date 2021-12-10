class MainController < ApplicationController
  include MainHelper

  before_action :task_for_index, :company, only: :index
  before_action :set_paper_trail_whodunnit

  def index
    @users = User.where(company_id: current_user.company_id).order(:state)
    @tickets = Ticket.company(company.id).open.order(:created_at).reverse.each do |el|
      el[:description] = define_text_time(el.created_at)
    end
  end

  def sort_ticket
    tickets = Ticket.company(company.id).open.order(:created_at).reverse_order
    tickets = tickets.where(status_id: params[:status_id]) if params[:status_id].present?
    tickets = tickets.where(category_id: params[:category_id]) if params[:category_id].present?
    tickets = tickets.where(manager_id: params[:manager_id]) if params[:manager_id].present?
    tickets = tickets.where(client_id: params[:client_id]) if params[:client_id].present?

    case params[:date_id]
    when '2'
      tickets = tickets.reverse
    when '3'
      tickets = tickets.select {|ticket| ticket.product.present? && ticket.product.date.present?}
      tickets = tickets.sort_by {|ticket| ticket.product.date}.reverse
    when '4'
      tickets = tickets.select {|ticket| ticket.product.present? && ticket.product.date.present?}
      tickets = tickets.sort_by {|ticket| ticket.product.date}
    end

    render json: ticket_format(tickets)
  end

  def ticket_close
    tickets = Ticket.company(company.id).where(is_closed: true).order(:created_at).reverse
    render json: ticket_format(tickets)
  end

  def update_close_ticket
    Ticket.find_by(id: params[:id]).update(is_closed: true)
  end

  def add_files_to_client
    Ticket.find_by(id: params[:id]).client.files.attach(params[:files])
    redirect_to '#win5000001'
  end

  def show_files
    files = Ticket.find_by(id: params[:id]).client.files
    if files.attached?
      data  = files.map {|file| [file.url, file.filename] }
      render json: { data: data, key: true }
    else
      render json: { key: false, message: 'По данному клиенту не загружен ни один файл'}
    end
  end

  def show_ticket
    ticket = Ticket.find_by(id: params[:id])
    product = ticket.product
    client = ticket.client
    another_tickets = client.tickets.where.not(id: params[:id]).order(:created_at).reverse
    type_product = company.type_product
    type_client = company.type_client
    notes = ticket.notes.order(:created_at).reverse.map do |note|
      [note.id, note.body, note.manager.full_name, note.manager == current_user ? true : false ]
    end
    loggable_type1 = type_client == 'human' ? 'Client' : 'ClientCompany'
    loggable_type2 = type_product == 'product' ? 'Product' : 'Service'
    logs = TicketLog.where(item_id: client.id, loggable_type: loggable_type1).or(TicketLog.where(ticket_id: ticket.id))
                    .or(TicketLog.where(item_id: product&.id, loggable_type: loggable_type2))
                    .order(:created_at).reverse.map do |log|
      [log.message, define_text_time(log.created_at), log.loggable_type]
    end
    render json: { ticket: ticket, client: client, another_tickets: another_tickets, product: product,
      type_product: type_product,  type_client: type_client, notes: notes, logs: logs }
  end

  def update_client
    Ticket.find_by(id: params[:id]).client.update(params.permit(:name, :surname, :phone, :email, :address,
      :description, :note, :points, :password, :patronymic, :manager_id, :responsible))
    render json: {success: true}
  end

  def update_product
    Ticket.find_by(id: params[:id]).product.update(params.permit(:name, :date, :type_product, :number, :description,
      :price, :discount, :duration, :executor))
    render json: {success: true}
  end

  def update_ticket
    Ticket.find_by(id: params[:id]).update(params.permit(:description, :subject))
    render json: {success: true}
  end

  def send_client_mail
    subject = params[:subject]
    body = params[:body]
    email = @current_user.company.email
    password = crypt.decrypt_and_verify(@current_user.company.password)
    client = Ticket.find_by(id: params[:id]).client
    to = client.email

    options = {
      address: "smtp.gmail.com",
      port: 587,
      domain: 'localhost',
      user_name: email,
      password: password,
      authentication: 'plain',
      enable_starttls_auto: true
    }

    Mail.defaults do
      delivery_method :smtp, options
    end

    Mail.deliver do
      to to
      from email
      subject subject
      html_part do
        content_type 'text/html; charset=UTF-8'
        body body
      end
    end

    send_email = Email.create(to: to, from: email, subject: subject, body: body, company_id: company.id,
      date: Time.current, incoming: false, manager_id: current_user.id, client: client)

    render json: [send_email.subject, send_email.body, send_email.manager.full_name, define_text_time(send_email.created_at)]
  end

  def show_emails
    client = Ticket.find_by(id: params[:id]).client
    emails = Email.where(client_id: client.id)
    key_present = emails.present? ? true : false
    key_sent = company.email.present? && client.email.present? && company.is_send
    response_hash = { key_present: key_present, key_sent: key_sent}
    email_array = emails&.map{ |mail| [mail.subject, mail.body, mail.incoming ? mail.client&.reverse_full_name : mail.manager&.full_name, define_text_time(mail.created_at), mail.incoming]}
    response_hash.merge!(emails: email_array) if key_present
    response_hash.merge!(message: 'Чтобы иметь возможность написать клиенту, укажите его email и email компании') unless key_sent
    render json: response_hash
  end

  def create_note
    note = Note.create(params.permit(:body, :ticket_id))
    note.manager_id = current_user.id
    note.company_id = company.id
    if note.save!
      render json: note
    end
  end

  def delete_note
    Note.find_by(id: params[:id]).destroy
    render json: {success: true}
  end

  def update_note
    note = Note.find_by(id: params[:id])
    note.update(params.permit(:body))
    note.manager_id = current_user.id
    if note.save!
      render json: note
    end
  end

  def change_state
    current_user.state = params[:state]
    current_user.save!
    render json: params[:state]
  end

  def not_new
    Task.where(user_id: current_user.id, active: true).update(is_new: false)
  end

  def create_ticket
    if params[:product][:name].present? &&  company.type_product == Company::TYPE_PRODUCT.first.first.to_s
      product = Product.new(product_params)
    elsif params[:service]&[:name].present?
      product = Service.new(service_params)
    end

    if product.present?
      return render json: {success: false, message:'Ошибка при сохранении товара'} unless product.save!
    end

    if company.type_client == Company::TYPE_CLIENTS.first.first.to_s
      client = params[:client].include?('@') ?
                 Client.company(company.id).find_by(email: params[:client]) :
                 Client.company(company.id).find_by(id: params[:client])
    else
      client = params[:client].include?('@') ?
                 ClientCompany.company(company.id).find_by(email: params[:client]) :
                 ClientCompany.company(company.id).find_by(id: params[:client])
    end
    return render json: {success: false, message:'Клиент с данными параметрами не найден'} unless client.present?

    ticket = Ticket.new(params.permit(:subject, :description, :manager_id, :status_id, :category_id))
    ticket.client = client
    ticket.product = product
    ticket.company_id = company.id

    if ticket.save!
      render json: ticket_format([ticket])
    end
  end

  private

  def company
    @company = @current_user.company
  end

  def task_for_index
    @tasks = Task.where(user_id: current_user.id, active: true)
    @is_new = @tasks.where(is_new: true).present?
  end

  def ticket_format(tickets)
    tickets.map do |ticket|
      [ticket.id, ticket.subject, ticket.client&.reverse_full_name, ticket.product&.name, ticket.manager&.full_name,
        define_text_time(ticket.created_at), ticket.category&.title, ticket.status&.title, ticket.product_type]
    end
  end

  def product_params
    params.require(:product).permit(:name, :type_product, :date, :number, :description, :price, :discount, :important)
  end

  def service_params
    params.require(:service).permit(:name, :type_service, :date, :duration, :description, :price, :discount, :important, :executor)
  end
end

# лог расписание
# основное
# поиск по всему
# аналитика
#
#норм доделать отображение  создание
# если такой клиент уже есть то говорить что есть
# хэш где ключ тору или фолс или наоборот
# полоска отчеркивающая дату создания тикета или цвет
# мб к письмам тикет айди чтоб понятно было к какому тикету
# добавить к логам компани айди чтоб в админку
# какое т обновление логов
# улучшить путем не селектов а подгрузки
# незя без имени клиенту
#
# перспектива - тригеры и партнеры
# выбрать имеющийся заказ
# автоматич добавления в календарь др или даты
