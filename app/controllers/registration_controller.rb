class RegistrationController < ApplicationController
  def identification
    redirect_to root_path if User.find_by_id(session[:current_user_id]).present?
    @user = User.new
  end

  def create_room
    if Company.where(name: params[:company]).blank?
      company = Company.create(name: params[:company])
    else
      return render json: "CRM для компании с данным именем уже существует, пожалуйста введите другое"
    end

    user = User.new(user_params)
    user.company = company

    if user.save
      UserMailer.registration_confirmation(user).deliver_now
      return render json: "Письмо для завершения регестрации отправлено Вам на почту"
    else
      company.destroy
      return render json: 'При создании crm произошла ошибка, пожалуйста попробуйте еще раз'
    end
  end

  def authorization
    company = Company.find_by(name: params[:company])
    return render json: "CRM для компании с данным именем не существует" if company.blank?

    user = User.authenticate(params[:email], params[:password], params[:company])
    if user.nil?
      render json: 'Пользователь не найден, проверьте вводимые данные'
    else
      if user.email_confirmed
        sign_in user
        render json: true
      else
        render json:  'Вы не закончили регистрацию, подтвердите свой профиль'
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
    redirect_to identification_url
  end

  def password_recovery
    user = User.find_by_confirm_token(params[:id])
    user.update(params.permit(:password))
    user.email_activate
    sign_in user
    redirect_to root_url
  end

  def send_password
    company = Company.find_by(name: params[:company])
    return render json: "CRM для компании с данным именем не существует" if company.blank?


    user = User.joins(:company).where("companies.name = ?", params[:company])
               .where(email: params[:email])
               .first
    return render json: 'Пользователь не найден, проверьте вводимые данные' if user.blank?

    user.confirm_token = SecureRandom.urlsafe_base64.to_s
    user.save!(validate: false)
    UserMailer.password_recovery(user).deliver_now

    render json: 'Письмо для восстановления пароля отправлено Вам на почту'
  end

  private

  def user_params
    params.permit(:name, :surname, :password, :email, :password_confirmation)
  end
end
