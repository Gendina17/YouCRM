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
    return render json: Ticket.company(company.id).open.order(:created_at).reverse if params[:all] == 'true'
  end

  def ticket_close
    render json: Ticket.company(company.id).where(is_closed: true).order(:created_at).reverse.each do |e|
      e[:client_type]= e.client.full_name
      e[:product_type]= e.product&.name
    end
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
    email_array = emails&.map{ |mail| [mail.subject, mail.body, mail.incoming ? mail.client&.full_name : mail.manager&.full_name, define_text_time(mail.created_at), mail.incoming]}
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

  private

  def company
    @company = @current_user.company
  end

  def task_for_index
    @tasks = Task.where(user_id: current_user.id, active: true)
    @is_new = @tasks.where(is_new: true).present?
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
#
#
# перспектива - тригеры и партнеры
