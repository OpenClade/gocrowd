# app/services/mail_sender.rb

module MailSender
  def self.send_register_email(user)
    UserMailer.register_email(user).deliver_now
  end
end