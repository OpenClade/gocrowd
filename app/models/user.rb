class User < ApplicationRecord
  belongs_to :investor, optional: true
  
  has_secure_password

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password_present?

  # Метод для создания и сохранения пользователя
  def self.create_user(email, password) 
    user = User.new(email: email, password: password)
    if user.save
      user
    else
      raise ActiveRecord::RecordInvalid.new(user)
    end
  end

  private

  # Проверка, что пароль задан, чтобы валидировать его
  def password_present?
    password.present?
  end
end
