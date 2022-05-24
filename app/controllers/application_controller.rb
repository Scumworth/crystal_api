class ApplicationController < ActionController::API
  require "json_web_token"

  def authenticate_request
    header = request.headers['Authorization']
    if header
      header = header.split(" ").last
      begin
        decoded_token = JsonWebToken.decode(header)
        @current_user = User.find_by_username(decoded_token[:username])
      rescue JWT::DecodeError => e
        render json: { errors: "Error: #{e.message}" }, status: :unauthorized
      end
    end
  end

  def current_user
    @current_user
  end
  
  def respond_if_unauthenticated
    render json: { error: "Error: You must log in to complete this request" }, status: :unauthorized unless @current_user
  end
end
