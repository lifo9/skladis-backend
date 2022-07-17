class LocationsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_location, only: %i[ show update destroy ]

  # GET /locations
  def index
    authorize Location.all

    @location = api_index(Location, params)

    render json: LocationSerializer.new(@location)
  end

  # GET /locations/1
  def show
    authorize @location

    render json: LocationSerializer.new(@location)
  end

  # GET /locations/select-options
  def select_options
    authorize Location.all

    render json: api_select_options(Location, [:name], :id, params)
  end

  # POST /locations
  def create
    authorize Location

    @location = Location.new(location_params)
    serialized_location = LocationSerializer.new(@location)

    if @location.save
      render json: serialized_location, status: :created
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /locations/1
  def update
    authorize Location

    if @location.update(location_params)
      render json: LocationSerializer.new(@location)
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /locations/1
  def destroy
    authorize @location

    @location.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def location_params
    params.fetch(:location, {}).permit(Location::PERMITTED_PARAMS)
  end

end
