# app/models/offering.rb
class Offering < ApplicationRecord
  has_many :investments

  enum status: { draft: 0, collecting: 1, closed: 2, completed: 3 }

  after_update :offering_callback

  state_machine :status, initial: :draft, ignore_method_conflicts: true do
    state :draft
    state :collecting
    state :closed
    state :completed

    event :start_collecting do
      transition from: :draft, to: :collecting
    end

    event :close do
      transition from: :collecting, to: :closed
    end

    event :complete do
      transition from: :closed, to: :completed
    end

    state :completed do
      def offering_callback
        handle_investments_on_complete
      end
    end
    
  end

  
  validates :status, presence: true
  validates :name, presence: true


  def handle_investments_on_complete
 
    investments.each do |investment|
      if investment.status != 'received'
        investment.hide!
        investment.save
      end
    end
  end
end
