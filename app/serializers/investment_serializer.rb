# app/serializers/investment_serializer.rb
class InvestmentSerializer < ActiveModel::Serializer
  attributes :id, :amount, :status, :created_at, :updated_at, :investor_name, :offering_name

  def investor_name
    object.investor.user.first_name + " " + object.investor.user.last_name
  end

  def offering_name
    object.offering.name
  end
end