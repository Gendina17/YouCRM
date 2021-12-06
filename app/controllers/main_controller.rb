class MainController < ApplicationController
  include MainHelper

  before_action :company, only: [:index, :settings]
  before_action :contacts, :roles, :selected_params, only: :settings
  before_action :task_for_index, only: :index
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

  def settings
    @users = User.where(company_id: current_user.company_id)
    @has_new = Wall.company(current_user.company_id).where.not(user_id: current_user.id).count > Wall.
      company(current_user.company_id).where.not(user_id: current_user.id).joins(:users_walls).
      where('users_walls.user_id = ?', current_user.id).count
    @statuses = Status.company(company.id)
    @categories = Category.company(company.id)
    @email_templates = EmailTemplate.select(:id, :name).company(company.id).order(:created_at).reverse
  end

  def change_state
    current_user.state = params[:state]
    current_user.save!
    render json: params[:state]
  end

  def update
    @current_user.update!(user_params)
    @current_user.info = params[:info].strip

    if @current_user.contacts.present?
      contacts = JSON.parse(@current_user.contacts)
    else
      contacts = {}
    end

    contacts.merge!(params[:contact] => params[:value]) if params[:contact].present? && params[:value].present?
    contacts.except!(params[:contact]) if params[:contact].present? && params[:value].blank?

    @current_user.update!(contacts: contacts.to_json)
    render json: 'Данные успешно изменены'
  end

  def update_avatar
    @current_user.avatar.attach(params[:avatar])
    @current_user.save
    redirect_to settings_path
  end

  def update_company_avatar
    @current_user.company.avatar.attach(params[:avatar])
    @current_user.company.save
    @current_user.company.update(is_show_avatar: params[:is_show_avatar])
    redirect_to settings_path
  end

  def create
    return render json: 'Введенные пароли не совпадают' if params[:password] != params[:password_confirmation]

    return render json: 'Пользователь с данным email уже зарегестрирован' if User.
      where(company_id: current_user.company_id, email: params[:email]).present?

    user = User.new(user_create_params)
    user.company_id = current_user.company_id
          user.role_id = Role.last.id

    if user.save!
      UserMailer.registration_not_room_creator(user, current_user).deliver_now
      return render json: "Письмо для завершения регестрации отправлено Вам на почту"
    else
      return render json: 'Пользователя не получилось создать, пожалуйста попробуйте еще раз'
    end
  end

  def create_role
    role = Role.new(name: params[:name], description: params[:description], company_id: current_user.company_id)
    role.the_role = params.require(:permission).values.to_json
    if role.save!
      return render json: 'Роль успешно создана'
    else
      return render json: 'Что то не вышло('
    end
  end

  def add_role_to_user
    user = User.find(params[:role_id])
    user.role_id = params[:user_id]
    if user.save!
      return render json: 'Пользователю успешно присвоена роль'
    else
      return render json: 'Что то не вышло('
    end
  end

  def all_users_in_role
    render json: User.where(role_id: params[:id]).pluck(:name, :surname, :email)
  end

  def create_task
    task = Task.new(task_params)
    task.creator_id = @current_user.id
    if task.save!
      return render json: task
    end
    render json: 'Не получилось создать задачу'
  end

  def all_walls
    walls = []
    Wall.company(current_user.company_id).each do |wall|
      my = wall.user_id == current_user.id ? 1 : 0
      text_time = define_text_time(wall.created_at)
      tag = define_tag(wall.tag)
      src = define_avatar(wall.user)
      attach = define_attach_file(wall, my)
      new = wall.users.exclude?(current_user) ? 'new' : ''
      p new

      walls << [wall.body, wall.tag, text_time, tag, src, my, attach, new]
    end

    Wall.company(current_user.company_id).where.not(user_id: current_user.id).each do |wall|
      wall.users << current_user if wall.users.exclude?(current_user)
    end

    render json: walls
  end

  def create_wall
    wall = Wall.new(params.permit(:body, :tag))
    wall.user_id = current_user.id
    wall.company_id = current_user.company_id

    if wall.save
      text_time = define_text_time(wall.created_at)
      tag = define_tag(wall.tag)
      src = define_avatar(@current_user)

      render json: [wall.body, wall.tag, text_time, tag, src]
    else
      render json: 'не удалось отправить сообщение'
    end
  end

  def create_wall_with_attach
    wall = Wall.new(params.permit(:body))
    wall.user_id = current_user.id
    wall.company_id = current_user.company_id
    wall.tag = 'advertisement'
    wall.attach.attach(params[:attach])
    wall.save
  end

  def add_email
    it_company = company
    it_company.email = params[:email]
    it_company.is_send = params[:send]
    it_company.password = crypt.encrypt_and_sign(params[:password])

    if it_company.save
      render json: 'Почта успешно добавлена'
    else
      render json: 'не получилось'
    end
  end

  def dell_role
    role = Role.find(params[:id])
    role_name = role.name
    if role.users.blank?
      role.destroy
      render json: [1, role_name]
    else
      render json: [0, 'Назначте всем пользователям новые роли, прежде чем удалять должность']
    end
  end

  def update_role
    role = Role.find(params[:id])
    role.the_role = params.require(:permission).values.to_json
    if role.save!
      return render json: 'Роль успешно изменена'
    else
      return render json: 'Что то не вышло('
    end
  end

  def tasks
    @tasks = Task.all
    case params[:active]
    when 'true'
      @tasks = Task.where(creator_id: current_user.id, active: true)
    when 'false'
      @tasks = Task.where(creator_id: current_user.id, active: false )
    else
      @tasks = Task.where(creator_id: current_user.id)
    end

    @tasks = @tasks.where(tag: params[:tag]) if params[:tag].present?
    @tasks = @tasks.where(user_id: params[:user_id]) if params[:user_id].present?
    @tasks = @tasks.order(:created_at).pluck(:id, :subject, :body, :tag, :active, :user_id).
      each do |task|
      task[5] = User.find(task[5]).full_name
      task[3] = task[3].blank? ? '---': task[3]
    end

    render json: @tasks
  end

  def task_for_index
    @tasks = Task.where(user_id: current_user.id, active: true)
    @is_new = @tasks.where(is_new: true).present?
  end

  def not_new
    Task.where(user_id: current_user.id, active: true).update(is_new: false)
  end

  def inactive
    Task.find(params[:id]).update(active: false)
    render json: 'ok'
  end

  def set_clients_fields
    company = current_user.company
    company.update(type_client: params[:type_client])

    company.client_fields = params.require(:fields).values.to_json
    if company.save!
      return render json: 'Данные успешно изменены'
    else
      return render json: 'Что то не вышло('
    end
  end

  def set_type_product
    current_user.company.update(type_product: params[:type_product])
    render json: 'Данные успешно изменены'
  end

  def create_status
    company.update(show_statuses: params[:show_statuses])
    status = Status.new(title: params[:title], description: params[:description])
    status.company_id = company.id
    if status.save!
      render json: status
    end
  end

  def create_category
    company.update(show_categories: params[:show_categories])
    category = Category.new(title: params[:title], description: params[:description])
    category.company_id = company.id
    if category.save!
      render json: category
    end
  end

  def delete_status
    Status.find_by(id: params[:id]).destroy
    render json: [params[:id]]
  end

  def delete_category
    Category.find_by(id: params[:id]).destroy
    render json: [params[:id]]
  end

  def create_template
    render json: EmailTemplate.create!(body: params[:body], subject: params[:subject], company_id: company.id,
      name: params[:name])
  end

  def update_template
    EmailTemplate.find_by(id: params[:id]).update(params.permit(:body, :subject, :name))
    render json: { success: true }
  end

  def delete_template
    EmailTemplate.find_by(id: params[:id]).destroy
    render json: { success: true }
  end

  def set_default_template
    id = params[:id] == 0 ? nil : params[:id]
    company.update(default_email_id: id)
    render json: { success: true }
  end

  def show_template
    render json: EmailTemplate.find_by(id: params[:id])
  end

  private

  def company
    @company = @current_user.company
  end

  def user_params
    params.permit(:name, :surname, :mood)
  end

  def user_create_params
    params.permit(:name, :surname, :password, :email, :password_confirmation, :role_id)
  end

  def contacts
    @contacts = [ 'telegram', 'slack' , 'whatsapp' , 'phone', 'github']
  end

  def roles
    @roles = Role.company(@company.id)
  end

  def task_params
    params.permit(:subject, :body, :user_id, :until_date, :tag)
  end

  def selected_params
    ids =  Task.where(creator_id: current_user.id).pluck(:user_id)
    @selected_users = User.where(id: ids).pluck(:id, :name, :surname)
    @selected_tags = Task.where(creator_id: current_user.id).pluck(:tag).uniq
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
