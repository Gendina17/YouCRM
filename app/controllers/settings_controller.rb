class SettingsController < ApplicationController
  include MainHelper

  before_action :set_paper_trail_whodunnit
  before_action :contacts, :roles, :selected_params, :company, only: :settings

  def settings
    @users = User.where(company_id: current_user.company_id)
    @has_new = Wall.company(current_user.company_id).where.not(user_id: current_user.id).count > Wall.
      company(current_user.company_id).where.not(user_id: current_user.id).joins(:users_walls).
      where('users_walls.user_id = ?', current_user.id).count
    @statuses = Status.company(company.id)
    @categories = Category.company(company.id)
    @email_templates = EmailTemplate.select(:id, :name).company(company.id).order(:created_at).reverse
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
      return render json: "Письмо для завершения регестрации отправлено почту пользователя"
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

  def contacts
    @contacts = [ 'telegram', 'slack' , 'whatsapp' , 'phone', 'github']
  end

  def roles
    @roles = Role.company(company.id)
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

  private

  def selected_params
    ids =  Task.where(creator_id: current_user.id).pluck(:user_id)
    @selected_users = User.where(id: ids).pluck(:id, :name, :surname)
    @selected_tags = Task.where(creator_id: current_user.id).pluck(:tag).uniq
  end

  def company
    @company = @current_user.company
  end

  def user_params
    params.permit(:name, :surname, :mood)
  end

  def user_create_params
    params.permit(:name, :surname, :password, :email, :password_confirmation, :role_id)
  end

  def task_params
    params.permit(:subject, :body, :user_id, :until_date, :tag)
  end
end
