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
      redirect_to root_url
    end

  end

  private

  def user_params
    params.permit(:name, :surname, :password, :email, :password_confirmation)
  end
end
