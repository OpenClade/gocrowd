class AuthService
  def initialize(email, password)
    @email = email
    @password = password
  end

  def login
    user = User.find_by(email: @email)
    
    if user && user.authenticate(@password)
      token = encode_token(user_id: user.id)
      { user: UserSerializer.new(user), token: token }
    else
      raise ActiveRecord::RecordNotFound, "Incorrect email or password"
    end
  end
    
  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, ENV['SECRET_KEY'])
  end   
end
