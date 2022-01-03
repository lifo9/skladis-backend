class RolesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_role, only: %i[ show ]

  # GET /roles
  def index
    authorize Role.all

    @roles = paginate Role.all

    render json: RoleSerializer.new(@roles)
  end

  # GET /roles/1
  def show
    authorize @role

    render json: RoleSerializer.new(@role)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @user = Role.find(params[:id])
  end
end