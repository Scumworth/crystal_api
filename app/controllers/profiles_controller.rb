class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :update, :destroy]
  before_action :authenticate_request
  before_action :respond_if_unauthenticated, except: [:show, :index]

  # GET /profiles
  def index
    @profiles = Profile.all
    render json: @profiles, status: :ok
  end 

  # GET /profiles/:id
  def show
    render json: @profile, status: :ok
  end
  
  # POST /profiles
  def create
    @profile = Profile.new(profile_params)
    # ensure profile is being created for existing team
    if Team.find_by(id: params[:team_id]) && @profile.save
      render json: @profile, status: :created
    else
      render json: { error: 'Error: unable to create Profile' }, status: :bad_request
    end
  end
  
  # PUT /profiles/:id
  def update
    if @profile
      @profile.update(profile_params)
      render json: @profile, status: :ok
    else 
      render json: { error: 'Error: unable to update Profile' }, status: :bad_request
    end
  end
  
  # DELETE /profiles/:id
  def destroy
    if @profile
      @profile.destroy
      render status: :no_content
    else
      render json: { error: 'Error: unable to delete Profile' }, status: :bad_request
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end
  
  def profile_params
    params.permit(:first_name, :last_name, :email, :team_id)
  end
end
