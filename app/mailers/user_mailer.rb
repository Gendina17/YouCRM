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
end
