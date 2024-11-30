class Investor < ApplicationRecord
  belongs_to :user
  has_many :investments

  enum kyc_status: { pending: 0, approved: 1 }

  validates :kyc_status, presence: true
  validates :user_id, presence: true, uniqueness: true

  # Метод для верификации KYC
  def approve_kyc!
    update!(kyc_status: :approved)
  end

  # Метод для отмены верификации KYC
  def revoke_kyc!
    update!(kyc_status: :pending)
  end
end
