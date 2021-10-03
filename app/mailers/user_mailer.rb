class UserMailer < ApplicationMailer
  default from: "you.crm.with.love@gmail.com"

  def registration_confirmation(user)
    @user = user
    mail(to: "#{user.name} <#{user.email}>", subject: "Please confirm your registration")
  end
end
