class OfferingsController < ActionController::API
   
  # GET /offerings or /offerings.json
  def index
    @offerings = Offering.all
    render json: @offerings
  end

  # GET /offerings/1 or /offerings/1.json
  def show
    @offering = Offering.find(params[:id])
    render json: @offering
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