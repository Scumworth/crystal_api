class TeamsController < ApplicationController
  before_action :authenticate_request, :respond_if_unauthenticated
  
  # NOTE: This controller is very simple and only enables routes for
  # viewing teams and all the users on teams.
  #
  # An optimization would be to create routes allowing users to
  # create their own teams through api requests.
  #
  # GET /teams
  def index
    @teams = Team.all
    render json: @teams, status: :ok
  end

  # GET /teams/:id
  def show
    @team = Team.find(params[:id])
    render json: @team, status: :ok
  end
end

