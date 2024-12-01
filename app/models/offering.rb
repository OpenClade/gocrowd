# app/models/offering.rb
class Offering < ApplicationRecord
  has_many :investments

  enum status: { draft: 0, collecting: 1, closed: 2, completed: 3 }

  after_update :offering_callback

  state_machine :status, initial: :draft do

    event :start_collecting do
      transition from: :draft, to: :collecting
    end

    event :close do
      transition from: :collecting, to: :closed
    end

    event :complete do
      transition from: :closed, to: :completed
    end 
  end

  
  validates :status, presence: true
  validates :name, presence: true


  def handle_investments_on_complete
 
    investments.find_each do |investment|
      if investment.status != 'received' && investment.status != 'hidden'
        investment.hide!
        investment.save
      end
    end
  end

  private

  def offering_callback
    handle_investments_on_complete if status == 'completed' 
  end
end
