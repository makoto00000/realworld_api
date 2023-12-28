class ApplicationController < ActionController::API
  def create_token(user_id)
    payload = {user_id: user_id}
    secret_key = Rails.application.credentials.secret_key_base
    token = JWT.encode(payload, secret_key)
    return token
  end

  def authenticate
    authorization_header = request.headers[:authorization]
    if !authorization_header
      render status: :unauthorized
    else
      token = authorization_header.split(" ")[1]
      secret_key = Rails.application.credentials.secret_key_base
      decoded_token = JWT.decode(token, secret_key)
      @current_user = User.find(decoded_token[0]["user_id"])
    end
  end
end
