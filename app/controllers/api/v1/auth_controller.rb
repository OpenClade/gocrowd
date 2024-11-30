# app/controllers/api/v1/auth_controller.rb
module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authorized, only: [:login]
      rescue_from ActiveRecord::RecordNotFound, with: :handle_unauthorized_error
        
      def login
        auth_service = AuthService.new(login_params[:email], login_params[:password])        
        result = auth_service.login
        render json: result, status: :accepted
      end
        
      private
        
      def login_params 
        params.require(:auth).permit(:email, :password)
      end
      
      def handle_unauthorized_error(e)
        render json: { message: e.message }, status: :unauthorized
      end
    end
  end
end
