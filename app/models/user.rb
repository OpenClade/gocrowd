class User < ApplicationRecord 
  belongs_to :investor, optional: true
  has_secure_password
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

   
end