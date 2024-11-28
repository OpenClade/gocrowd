# app/models/investor.rb
class Investor < ApplicationRecord
  belongs_to :user

  enum kyc_status: { pending: 0, approved: 1 }

  validates :kyc_status, presence: true
end