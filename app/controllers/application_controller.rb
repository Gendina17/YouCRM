class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception

  before_action :authenticate, except: %i[identification create_room authorization confirm_email new_password password_recovery send_password ]

  def current_user
    @current_user ||= session[:current_user_id] &&
      User.find_by_id(session[:current_user_id])
  end

  def crypt
    len = 32
    salt = '\xE3q-\xBA\xBE\x80\xEA\xBA\x9A\xCC\x1F^\x1F6\xD7\x03P\xD1\xDA\xAA\r\xDB\xDD\xEB\x04l\xF7?\xBF\x91&\xDD'
    key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, len)
    ActiveSupport::MessageEncryptor.new(key)
  end

  private

  def authenticate
    redirect_to identification_path unless current_user
  end
end
