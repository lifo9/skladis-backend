class WarehousesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_warehouse, only: %i[ show update destroy ]

  # GET /warehouses
  def index
    authorize Warehouse.all

    @warehouses = api_index(Warehouse, params)

    render json: WarehouseSerializer.new(@warehouses, { include: [:address] })
  end

  # GET /warehouses/1
  def show
    authorize @warehouse

    render json: WarehouseSerializer.new(@warehouse, { include: [:address] })
  end

  # POST /warehouses
  def create
    authorize Warehouse

    @warehouse = Warehouse.new(warehouse_params)

    address = Address.find_by(address_params_without_coordinates)
    if address.present?
      address.coordinates = address_params[:coordinates]
    else
      address = Address.new(address_params)
    end
    address.save!
    @warehouse.address = address

    serialized_warehouse = WarehouseSerializer.new(@warehouse, { include: [:address] })

    if @warehouse.save
      render json: serialized_warehouse, status: :created
    else
      render json: @warehouse.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /warehouses/1
  def update
    authorize Warehouse

    address = Address.find_by(address_params_without_coordinates)
    if address.present?
      address.coordinates = address_params[:coordinates]
    else
      address = Address.new(address_params)
    end
    address.save!
    @warehouse.address = address

    if @warehouse.update(warehouse_params)
      render json: WarehouseSerializer.new(@warehouse, { include: [:address] })
    else
      render json: @warehouse.errors, status: :unprocessable_entity
    end
  end

  # DELETE /warehouses/1
  def destroy
    authorize @warehouse

    @warehouse.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def warehouse_params
    params.fetch(:warehouse, {}).permit(Warehouse::PERMITTED_PARAMS)
  end

  def address_params
    params.fetch(:warehouse, {}).permit(Address::PERMITTED_PARAMS)
  end

  def address_params_without_coordinates
    params.fetch(:warehouse, {}).permit(Address::PERMITTED_PARAMS_WITHOUT_COORDINATES)
  end
end
