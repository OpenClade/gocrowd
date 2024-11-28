require 'swagger_helper'

RSpec.describe 'offerings', type: :request do
  path '/offerings' do
    get 'Retrieves all offerings' do
      produces 'application/json'

      response '200', 'offerings found' do
        schema type: :array,
          items: {
            properties: {
              id: { type: :integer },
              type: { type: :string },
              state: { type: :string },
              name: { type: :string },
              min_invest_amount: { type: :integer },
              min_target: { type: :integer },
              max_target: { type: :integer },
              total_investors: { type: :integer },
              current_reserved_amount: { type: :integer },
              funded_amount: { type: :integer },
              reserved_investors: { type: :integer }
            }
          }

        run_test!
      end
    end
  end
end