# app/controllers/users_controller.rb
class UsersController < TransactionalController
  skip_before_action :authorized, only: [:create]
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

  def create
    is_exists = User.find_by(email: user_params[:email])
    if is_exists
      render json: { message: 'User already exists' }, status: :unauthorized
      return
    end

    user = User.new(user_params) # Ensure the user variable is assigned here
    if user.save
      @token = encode_token(user_id: user.id)
      MailSender.send_register_email(user)
      render json: {
        user: UserSerializer.new(user),
        token: @token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def me
    render json: current_user, status: :ok
  end

  private

  def user_params 
    return {} if params[:user].nil?
    params.require(:user).permit(:email, :password, :role)
  end

  def handle_invalid_record(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end