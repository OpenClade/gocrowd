module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorized, only: [:create]
      rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

      # POST /users
      def create 
        if User.exists?(email: params[:email])
          render json: { message: 'User already exists' }, status: :unauthorized
          return
        end

        # Используем метод модели для создания пользователя
        user = User.create_user(params[:email], params[:password])
        
        # Генерация токена
        @token = encode_token(user_id: user.id)

        # Отправка письма
        MailSender.send_register_email(user)

        render json: { user: UserSerializer.new(user), token: @token }, status: :created
      end

      # GET /me
      def me
        render json: current_user, status: :ok
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end

      # Обработка ошибки валидации
      def handle_invalid_record(e)
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
