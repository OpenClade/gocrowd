# app/controllers/concerns/transactional.rb
module Transactional
  extend ActiveSupport::Concern

  included do
    around_action :wrap_in_transaction
  end

  private

  def wrap_in_transaction
    ActiveRecord::Base.transaction do
      yield
    rescue => e
      # Handle the error
      logger.error "Transaction failed: #{e.message}"
      render json: { error: "#{e.message}" }, status: :bad_request
      raise ActiveRecord::Rollback
    end
  end
end