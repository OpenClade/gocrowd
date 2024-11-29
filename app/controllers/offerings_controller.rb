class OfferingsController < ActionController::API
   
  # GET /offerings or /offerings.json
  def index
    @offerings = Offering.all

    # Apply pagination
    sort_order = params[:sort] == 'desc' ? :desc : :asc
    @offerings = @offerings.order(id: sort_order)

    if params[:page].present? && params[:per_page].present?
      offset = (params[:page].to_i - 1) * params[:per_page].to_i
      limit = params[:per_page].to_i
      @offerings = @offerings.offset(offset).limit(limit)
    end

    render json: @offerings
  end

  # GET /offerings/1 or /offerings/1.json
  def show
    @offering = Offering.find(params[:id])
    render json: @offering
  end

  # PUT /offerings/1
  def update
    @offering = Offering.find(params[:id])
    if offering_params.status == 'approved'
      investments = @offering.investments
      investments.each do |investment|
        investment.status = 'hidden'
        investment.save
      end
    end
    if @offering.update(offering_params)
      render json: @offering
    else
      render json: @offering.errors, status: :unprocessable_entity
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_offering
    @offering = Offering.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def offering_params
    params.require(:offering).permit(:name, :status, :target_amount, :min_invest_amount, :min_target, :max_target, :total_investors, :current_reserved_amount, :funded_amount, :reserved_investors)
  end
end