json.extract! offering, :id, :type, :state, :name, :min_invest_amount, :min_target, :max_target, :total_investors, :current_reserved_amount, :funded_amount, :reserved_investors, :created_at, :updated_at
json.url offering_url(offering, format: :json)
