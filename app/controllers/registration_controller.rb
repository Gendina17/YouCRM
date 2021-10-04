class RegistrationController < ApplicationController
  def identification
    redirect_to root_path if User.find_by_id(session[:current_user_id]).present?
    @user = User.new
  end

  def create_room
    if Company.where(name: params[:company]).blank?
      company = Company.create(name: params[:company])
    else
      redirect_to identification_url, alert: 'Crm для компании с таким названием уже существует, пожалуйста введите другое'
      return
    end

    user = User.new(user_params)
    user.company = company

    if user.save
      UserMailer.registration_confirmation(user).deliver_now
      redirect_to root_path
    else
      redirect_to identification_url, alert: 'При создании crm произошла ошибка, пожалуйста попробуйте еще раз'
    end
  end

  def authorization
    user = User.authenticate(params[:email], params[:password], params[:company])
    if user.nil?
      redirect_to identification_url, alert: 'Пользователь не найден, проверьте вводимые данные'
    else
      if user.email_confirmed
        sign_in user
        redirect_to root_path
      else
        redirect_to identification_url, alert: 'Профиль не подтвержден'
      end
    end
  end

  def destroy
    sign_out
    redirect_to identification_url
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      sign_in user
      redirect_to root_url
    else
      redirect_to identification_url, alert: ''
    end
  end

  def new_password
    @token = params[:id]
    @user = User.find_by_confirm_token(@token)
    redirect_to identification_url, alert: 'К сожалению, произошла какая-то ошибка' if @user.blank?
  end

  def password_recovery
    user = User.find_by_confirm_token(params[:id])
    user.update(params.permit(:password))
    user.email_activate
    sign_in user
    redirect_to root_url
  end

  def send_password
    user = User.joins(:company).where("companies.name = ?", params[:company])
               .where(email: params[:email])
               .first
    user.confirm_token = SecureRandom.urlsafe_base64.to_s
    user.save!(validate: false)
    UserMailer.password_recovery(user).deliver_now
  end

  private

  def user_params
    params.permit(:name, :surname, :password, :email, :password_confirmation)
  end
end
