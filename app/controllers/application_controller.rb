class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception

  before_action :authenticate, except: %i[identification create_room authorization confirm_email new_password password_recovery send_password ]

  def current_user
    @current_user ||= session[:current_user_id] &&
      User.find_by_id(session[:current_user_id])
  end

  private

  def authenticate
    redirect_to identification_path unless current_user
  end
end
