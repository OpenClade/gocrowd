# app/controllers/investors_controller.rb
class InvestorsController < TransactionalController 
  before_action :set_investor, only: [:show, :update]

  # GET /investors/:id
  def show
    render json: @investor
  end

  # GET /me/investor
  def me
    @investor = Investor.find_by(user: current_user)
    render json: @investor
  end

  # POST /investors
  def create
    if Investor.exists?(user: current_user)
      render json: { error: 'Investor already exists' }, status: :unprocessable_entity
      return
    end

    @investor = Investor.new(investor_params.merge(user: current_user), kyc_status: 'pending')

    if @investor.save
      render json: @investor, status: :created
    else
      render json: @investor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /investors/:id
  def update
    if @investor.update(investor_params)
      render json: @investor
    else
      render json: @investor.errors, status: :unprocessable_entity
    end
  end

  private

  def set_investor
    @investor = Investor.find(params[:id])
    render json: { error: 'Investor not found' }, status: :not_found if @investor.user != current_user
  end

  def investor_params
    params.require(:investor).permit(:kyc_verified_at)
  end
end