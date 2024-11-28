# app/models/offering.rb
class Offering < ApplicationRecord
  has_many :investments

  enum status: { draft: 0, collecting: 1, closed: 2, completed: 3 }, _default: "draft"

  def collecting?
    status == 'collecting'
  end

  validates :status, presence: true
  validates :name, presence: true
end