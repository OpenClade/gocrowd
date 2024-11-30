# spec/integration/offerings_spec.rb
require 'swagger_helper'

RSpec.describe 'Offerings API', type: :request do
  # Для GET /api/v1/offerings (Получить список офферингов)
  path '/api/v1/offerings' do
    get 'Возвращает список офферингов' do
      tags 'Offerings'
      produces 'application/json'
      
      response '200', 'Offerings found' do
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json).to be_an_instance_of(Array)
        end
      end

      response '404', 'Offerings not found' do
        run_test!
      end
    end
  end 
end
