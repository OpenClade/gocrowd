class Investment < ApplicationRecord
  belongs_to :investor
  belongs_to :offering

   
  has_one_attached :bank_statement

  enum status: { pending: 0, signed: 1, confirmed: 2, received: 3, hidden: 4 }

  state_machine :status, initial: :pending do
     
    event :sign do
      transition from: :pending, to: :signed
    end

    event :confirm do
      transition from: :signed, to: :confirmed
    end

    event :receive do
      transition from: :confirmed, to: :received
    end

    event :hide do
      transition from: [:pending, :signed, :confirmed, :received], to: :hidden
    end
  end

  # Валидации
  validates :amount, presence: true
  validates :status, presence: true
  validates :offering_id, presence: true
  validate :offering_is_open
  validate :amount_within_limits
  validate :offering_not_exceeded
  validate :investor_kyc_approved

  # Метод для обработки загрузки банковского заявления
  def upload_bank_statement(file)
    return false unless file.present?

    bank_statement.attach(file)
    bank_statement.attached?
  end

  private

  def offering_is_open
    errors.add(:offering, 'is not open') unless offering.status == 'collecting' || offering.status == "completed"
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
