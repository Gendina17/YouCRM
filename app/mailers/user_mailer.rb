class UserMailer < ApplicationMailer
  default from: "you.crm.with.love@gmail.com"

  def registration_confirmation(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: "Подтверждение регистрации YouCRM")
  end

  def password_recovery(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: "Восстановление пароля YouCRM")
  end

  def registration_not_room_creator(user, creator)
    @user = user
    @creator = creator
    mail(to: "#{user.name} <#{user.email}>", subject: "Окончание регистрации YouCRM")
  end
end
