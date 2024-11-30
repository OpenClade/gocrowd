# app/serializers/investment_serializer.rb
class InvestmentSerializer < ActiveModel::Serializer
  attributes :id, :amount, :status, :created_at, :updated_at, :offering_name


  def offering_name
    object.offering.name
  end
end