# app/models/investment.rb
class Investment < ApplicationRecord
  belongs_to :investor
  belongs_to :offering

  enum status: { pending: 0, signed: 1, confirmed: 2, received: 3, hidden: 4 }
  
  has_one_attached :bank_statement

  validates :amount, presence: true
  validates :status, presence: true
  validates :offering_id, presence: true
  validate :offering_is_open
  validate :amount_within_limits
  validate :offering_not_exceeded
  validate :investor_kyc_approved

  private

  def offering_is_open
    errors.add(:offering, 'is not open') unless offering.status == 'collecting'
  end

  def amount_within_limits
    if amount.blank?
      errors.add(:amount, 'is required')
      return
    end
    if amount < offering.min_target
      errors.add(:amount, 'is below the minimum investment')
    elsif amount > offering.max_target
      errors.add(:amount, 'exceeds the maximum investment')
    end
  end

  def offering_not_exceeded
    if offering.funded_amount && amount.to_d > offering.max_target
      errors.add(:amount, 'exceeds the maximum investment')
    end
  end

  def investor_kyc_approved
    errors.add(:investor, 'KYC not approved') unless investor.kyc_status == 'approved'
  end
end