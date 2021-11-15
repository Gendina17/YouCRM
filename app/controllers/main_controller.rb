class MainController < ApplicationController
  before_action :company, only: [:index, :settings]
  before_action :contacts, :roles, :selected_params, only: :settings
  before_action :task_for_index, only: :index

  def index
    @users = User.where(company_id: current_user.company_id).order(:state)
  end

  def settings
    @users = User.where(company_id: current_user.company_id)
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

  def create# мб с ролью чтот будет
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

  def define_text_time(created_at)
    time = Time.current - created_at
    case time
    when 0..3600
      "#{(time/60).round } minutes ago"
    when 3660..(3600*24)
      "#{(time/3600).round} hours ago"
    when (3600*24)..(3600*48)
      "yesterday"
    else
      created_at.strftime("%d.%m.%Y %H:%M")
    end
  end

  def define_tag(tag)
    case tag
    when 'important'
      '<span title="Важная информация"> <svg xmlns="http://www.w3.org/2000/svg" width="16" height="25" fill="currentColor" class="bi bi-exclamation-octagon" viewBox="0 0 16 7">
               <path d="M4.54.146A.5.5 0 0 1 4.893 0h6.214a.5.5 0 0 1 .353.146l4.394 4.394a.5.5 0 0 1 .146.353v6.214a.5.5 0 0 1-.146.353l-4.394 4.394a.5.5 0 0 1-.353.146H4.893a.5.5 0 0 1-.353-.146L.146 11.46A.5.5 0 0 1 0 11.107V4.893a.5.5 0 0 1 .146-.353L4.54.146zM5.1 1 1 5.1v5.8L5.1 15h5.8l4.1-4.1V5.1L10.9 1H5.1z"/>
               <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
               </svg></span>'
    when 'random'
      '<span title="Это смешно">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="25" fill="currentColor" class="bi bi-emoji-laughing" viewBox="0 0 16 7">
              <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
              <path d="M12.331 9.5a1 1 0 0 1 0 1A4.998 4.998 0 0 1 8 13a4.998 4.998 0 0 1-4.33-2.5A1 1 0 0 1 4.535 9h6.93a1 1 0 0 1 .866.5zM7 6.5c0 .828-.448 0-1 0s-1 .828-1 0S5.448 5 6 5s1 .672 1 1.5zm4 0c0 .828-.448 0-1 0s-1 .828-1 0S9.448 5 10 5s1 .672 1 1.5z"/>
              </svg></span>'
    when 'interesting'
      '<span title="Это может быть интересно">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="30" fill="currentColor" class="bi bi-lightbulb" viewBox="0 0 16 3">
              <path d="M2 6a6 6 0 1 1 10.174 4.31c-.203.196-.359.4-.453.619l-.762 1.769A.5.5 0 0 1 10.5 13a.5.5 0 0 1 0 1 .5.5 0 0 1 0 1l-.224.447a1 1 0 0 1-.894.553H6.618a1 1 0 0 1-.894-.553L5.5 15a.5.5 0 0 1 0-1 .5.5 0 0 1 0-1 .5.5 0 0 1-.46-.302l-.761-1.77a1.964 1.964 0 0 0-.453-.618A5.984 5.984 0 0 1 2 6zm6-5a5 5 0 0 0-3.479 8.592c.263.254.514.564.676.941L5.83 12h4.342l.632-1.467c.162-.377.413-.687.676-.941A5 5 0 0 0 8 1z"/>
              </svg></span>'
    when 'advertisement'
      '<span title="Объявление">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pin-angle-fill" viewBox="0 0 16 10">
              <path d="M9.828.722a.5.5 0 0 1 .354.146l4.95 4.95a.5.5 0 0 1 0 .707c-.48.48-1.072.588-1.503.588-.177 0-.335-.018-.46-.039l-3.134 3.134a5.927 5.927 0 0 1 .16 1.013c.046.702-.032 1.687-.72 2.375a.5.5 0 0 1-.707 0l-2.829-2.828-3.182 3.182c-.195.195-1.219.902-1.414.707-.195-.195.512-1.22.707-1.414l3.182-3.182-2.828-2.829a.5.5 0 0 1 0-.707c.688-.688 1.673-.767 2.375-.72a5.922 5.922 0 0 1 1.013.16l3.134-3.133a2.772 2.772 0 0 1-.04-.461c0-.43.108-1.022.589-1.503a.5.5 0 0 1 .353-.146z"/>
              </svg></span>'
    end
  end

  def define_avatar(user)
    if user.avatar.attached?
      user.avatar.url
    else
      "../assets/avatar#{rand(5) + 1}.jpeg"
    end
  end

  def all_walls
    walls = []
    Wall.company(current_user.company_id).each do |wall|
      my = wall.user_id == current_user.id ? 1 : 0
      text_time = define_text_time(wall.created_at)
      tag = define_tag(wall.tag)
      src = define_avatar(wall.user)

      walls << [wall.body, wall.tag, text_time, tag, src, my]
    end
    @walls = Wall.company(current_user.company_id)
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

  def add_email
    it_company = company
    it_company.email = params[:email]
    it_company.is_send = params[:send]
    it_company.password = crypt.encrypt_and_sign(params[:password])
    #crypt.decrypt_and_verify(encrypted_data)
    # чет не так сохраняет

    if it_company.save
      render json: 'Почта успешно добавлена, но для того чтоб все работало корректно надо .......'
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

# аналитика какаят хз чтот функциональн слоджное
## как то обозночать создателя ну и роли
# первую букву заглавную
# мб как т интеграцию с соц сетями
# редис солар амазон нжинкс мб на сервер вылеть чат сокеты почта бесконечная лента
# делать пользователей уволенными
# какие поля у клиента у заказа какая пролукция
# в ленте делать разного цвета например или картинку если объявление важно беседа и тп
# мб комменты к задачам
# пепир треил мож выводить кто менял чтот логирование типа сделать и какие есть роли
# сделать условную базу хранилище мож какиет графики аналитика
# при создании компании создавать роль админ и роль карент юзер
# сделать все по доступам
# мб письма красивыми
# возможность отправлять с клиента
# <!--сразу после создания добавлять в список и седект и контакты-->
# <!--еще мб не отображать если не подтвержден или уволеееееен-->
# <!--ну и создавать сразу должность главную админа при создании окмнаты и дават ьее юзеру и везде сделать по доступам-->
# некрасивы пока индекс и вол
# <!--мб коммент и ммммммб отредачить таски-->
# атачмент файлы
# мб если добавить хэдэры в письмо то не будет черного списка
# чтоб создавать в админке невидимое поле компани
# шаблоны писем и можно выбирать какой отправлять
# обновление контактов
# c увольнением чтот норм
# с шифрованием от почты
# подгрузка сообщений в чате
# если получится все таки сделать чат
# код распределить мб в хэлперы вынести
