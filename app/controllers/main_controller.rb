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
  #норм обрабатывать без пробелов
  def update
    @current_user.update!(user_params)

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

  private

  def company
    @company = @current_user.company
  end

  def user_params
    params.permit(:name, :surname, :mood, :info)
  end

  def user_create_params
    params.permit(:name, :surname, :password, :email, :password_confirmation)
  end

  def contacts
    # @contacts = { telegram: :Telegram, slack: :Slack, whatsapp: :WhatsApp, phone: :Phone, github: :Github }
    @contacts = [ 'telegram', 'slack' , 'whatsapp' , 'phone', 'github']
  end

  def roles
    @roles = Role.company(@company.id)
  end

  def task_params
    params.permit(:subject, :body, :user_id, :until_date, :tag)
  end
end

#блок настройки своего профиля, блок выбора для настройки адмена,
# 1F973ож аналитика какаят хз чтот функциональн слоджное
# сделать для пользователя контакты(мб какойт список месседжеров с катгорией другое) инфу
## как то обозночать создателя ну и роли
# первую букву заглавную
# посмотреть по роли кто в ней
# мб как т интеграцию с соц сетями
# редис солар амазон нжинкс мб на сервер вылеть чат сокеты почта бесконечная лента
# удалять роли и делать пользователей уволенными
# какие поля у клиента у заказа какая пролукция
