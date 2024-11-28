class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def register_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Our Service')
  end
end