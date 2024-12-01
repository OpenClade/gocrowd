module Api
  module V1
    class InvestmentsController < ApplicationController
      before_action :set_investment, only: [:show, :update, :approve]
      before_action :set_offering, only: [:create]

      # GET /investments
      def index
        @investor = Investor.find_by(user: current_user) 
        if @investor.nil?
          render json: { error: 'Investor not found' }, status: :not_found
          return
        end

        # Фильтрация скрытых инвестиций
        @investments = @investor.investments.where.not(status: :hidden)

        # Apply sorting
        sort_order = params[:tid_sort] == 'desc' ? :desc : :asc
        @investments = @investments.order(id: sort_order)

        # Apply pagination
        if params[:toffset].present? && params[:tlimit].present?
          offset = params[:toffset].to_i
          limit = params[:tlimit].to_i
          @investments = @investments.offset(offset).limit(limit)
        end

        render json: @investments
      end

      # POST /investments/:id/upload_bank_statement
      def upload_bank_statement
        @investment = Investment.find(params[:id])
        if @investment.upload_bank_statement(params[:file])
          render json: { investment: @investment }, status: :ok
        else
          render json: { error: 'Failed to upload file' }, status: :unprocessable_entity
        end
      end

      # GET /investments/:id
      def show
        render json: @investment
      end

      # POST /investments
      def create
        @investor = Investor.find_by(user: current_user)
        if @investor.nil?
          render json: { error: 'Investor not found' }, status: :not_found
          return
        end

        @investment = Investment.new(investment_params.merge(investor: @investor, status: Investment.statuses[:pending]))

        if @investment.save
          render json: @investment, status: :created
        else
          render json: { errors: @investment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /investments/:id/approve
      def approve
        if @investment.approve!
          render json: @investment, status: :ok
        else
          render json: { errors: @investment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /investments/:id
      def update
        if @investment.update(investment_params)
          render json: @investment
        else
          render json: { errors: @investment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_investment
        @investment = Investment.find(params[:id])
        render json: { error: 'Investment not found' }, status: :not_found unless @investment.investor == current_user.investor
      end

      def set_offering
        @offering = Offering.find(investment_params[:offering_id])
        render json: { error: 'Offering not found' }, status: :not_found unless @offering
      end

      def investment_params
        params.require(:investment).permit(:offering_id, :amount)
      end
    end
  end
end
