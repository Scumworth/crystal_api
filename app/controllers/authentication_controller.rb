class AuthenticationController < ApplicationController
  require "json_web_token"

  before_action :authenticate_request, except: :login

  # POST /auth/login
  def login
    user = User.find_by_username(params[:username])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(username: user.username)
      render json: {username: user.username, token: token }, status: :ok
    else
      render json: { error: 'Error: unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
