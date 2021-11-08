class MainController < ApplicationController
  before_action :company, only: [:index, :settings]
  before_action :contacts, :roles, only: :settings

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

  def all_walls
    render json: @walls = Wall.company(current_user.company_id)
  end

  def create_wall
    @wall = Wall.new(params.permit(:body))
    @wall.user_id = current_user.id
    @wall.company_id = current_user.company_id

    if @wall.save
      render json: @wall
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
    when true
      @tasks = Task.where(creator_id: current_user.id, active: true)
    when false
      @tasks = Task.where(creator_id: current_user.id, active: false )
    else
      @tasks = Task.where(creator_id: current_user.id)
    end

    @tasks = @tasks.where(tag: params[:tag]) if params[:tag].present?
    @tasks = @tasks.where(user_id: params[:user_id]) if params[:user_id].present?
    render json: @tasks
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
