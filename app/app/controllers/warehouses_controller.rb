class WarehousesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_warehouse, only: %i[ show update destroy ]

  # GET /warehouses
  def index
    authorize Warehouse.all

    @warehouses = api_index(Warehouse, params)

    render json: WarehouseSerializer.new(@warehouses, { include: [:address] })
  end

  # GET /warehouses/select-options
  def select_options
    authorize Warehouse.all

    render json: api_select_options(Warehouse, [:name], :id, params)
  end

  # GET /warehouses/1
  def show
    authorize @warehouse

    render json: WarehouseSerializer.new(@warehouse, { include: [:address] })
  end

  # POST /warehouses
  def create
    authorize Warehouse

    @warehouse = Warehouse.new(warehouse_address_params)

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

    if @warehouse.update(warehouse_address_params)
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
  def warehouse_address_params
    params.fetch(:warehouse, {}).permit(Warehouse::PERMITTED_PARAMS + [address_attributes: Address::PERMITTED_PARAMS])
  end
end
