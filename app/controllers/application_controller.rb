class ApplicationController < ActionController::API
  include Transactional
  before_action :authorized

  def decoded_token
    header = request.headers['Authorization']
    if header
      token = header.split(" ")[1]
      begin
        JWT.decode(token, ENV['SECRET_KEY'], true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end
    
  
  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, ENV['SECRET_KEY'])
  end 
  
  
  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end  
    
    
  def authorized
    unless !!current_user
      render json: { message: 'Please log in' }, status: :unauthorized
    end
  end
end
