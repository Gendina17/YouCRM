class MainController < ApplicationController
  before_action :company

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
    User.update(user_params)
  end

  private

  def company
    @company = @current_user.company
  end

  def user_params
    params.permit(:name, :surname, :avatar, :mood)
  end
end
#блок настройки своего профиля, блок выбора для настройки адмена,
# 1F973ож аналитика какаят хз чтот функциональн слоджное
# сделать для пользователя контакты(мб какойт список месседжеров с катгорией другое) инфу
