module Api
  module V1
    class InvestorsController < ApplicationController
      before_action :set_investor, only: [:show, :update]
      
      # GET /investors/:id
      def show
        render json: @investor
      end

      # GET /me/investor
      def me
        @investor = Investor.find_by(user: current_user) 
        if @investor
          render json: @investor
        else
          render json: { error: 'Investor not found' }, status: :not_found
        end
      end

      # POST /investors
      def create
        if Investor.exists?(user: current_user)
          render json: { error: 'Investor already exists' }, status: :unprocessable_entity
          return
        end

        @investor = Investor.new(investor_params.merge(user: current_user, kyc_status: 'pending'))

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
        @investor = current_user.investor
        render json: { error: 'Investor not found' }, status: :not_found unless @investor
      end

      def investor_params
        params.require(:investor).permit(:kyc_verified_at)
      end
    end
  end
end
