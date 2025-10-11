class ApplicationController < ActionController::API
  def current_user
    return @current_user if defined?(@current_user)

    @current_user = authenticate_user
  end

  private

  def authenticate_user
    token = extract_token
    return nil unless token

    begin
      decoded_token = JWT.decode(token, jwt_secret, true, { algorithm: "HS256" })
      payload = decoded_token[0]

      # Handle both old format (user_id directly) and new format (hash with user_id)
      user_id = payload.is_a?(Hash) ? payload["user_id"] : payload

      User.find(user_id)
    rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound
      nil
    end
  end

  def extract_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header&.start_with?("Bearer ")

    auth_header.split(" ").last
  end

  def jwt_secret
    Rails.application.secret_key_base
  end
end
