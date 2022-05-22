class ApplicationController < ActionController::API
  require "json_web_token"

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split(" ").last if header
    begin
      decoded_token = JsonWebToken.decode(header)
      current_user = User.find(decoded_token[:user_id])
    rescue JWT::DecodeError => e
      render json: { errors: "Error: #{e.message}" }, status: :unauthorized
    end
  end
end