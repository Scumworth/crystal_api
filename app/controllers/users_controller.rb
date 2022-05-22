class UsersController < ApplicationController
  before_action :authenticate_request, except: [:create]
  before_action :set_user, only: [:show, :destroy]

  # GET /users
  def index
    users = User.all
    render json: users, status: :ok
  end

  # GET /users/:id
  def show
    render json: user, status: :ok 
  end

  # POST /users
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else 
      render json: { error: 'Error: unable to create user' }, status: :bad_request
    end
  end

  # PUT /users/:id
  def update
    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: { error: 'Error: unable to update user' }, status: :bad_request
    end
  end

  private  

  def set_user
    user = User.find(params[:id])
  end

  def user_params
    params.permit(:username, :password)
  end
end
