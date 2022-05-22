class TeamsController < ApplicationController
  before_action :authenticate_request, :respond_if_unauthenticated

  # GET /teams
  def index
    teams = Team.all
    render json: teams, status: :ok
  end

  # GET /teams/:id
  def show
    team = Team.find(params[:id])
    render json: team, status: :ok
  end
end

