class SuppliersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_supplier, only: %i[ show update destroy ]

  # GET /suppliers
  def index
    authorize Supplier.all

    if params[:search]
      @suppliers = paginate Supplier.search_all_fields(params[:search])
    else
      @suppliers = paginate Supplier.all
    end
    @suppliers = @suppliers.api_order_by(params[:order_by], params[:order]) if params[:order_by] || params[:order]

    render json: SupplierSerializer.new(@suppliers, { include: [:address, :contact] })
  end

  # GET /suppliers/1
  def show
    authorize @supplier

    render json: SupplierSerializer.new(@supplier, { include: [:address, :contact] })
  end

  # POST /suppliers
  def create
    authorize Supplier

    @supplier = Supplier.new(supplier_params)

    address = Address.find_by(address_params_without_coordinates)
    if address.present?
      address.coordinates = address_params[:coordinates]
    else
      address = Address.new(address_params)
    end
    address.save!
    @supplier.address = address

    serialized_warehouse = SupplierSerializer.new(@supplier, { include: [:address, :contact] })

    if @supplier.save
      render json: serialized_warehouse, status: :created
    else
      render json: @supplier.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /suppliers/1
  def update
    authorize Supplier

    address = Address.find_by(address_params_without_coordinates)
    if address.present?
      address.coordinates = address_params[:coordinates]
    else
      address = Address.new(address_params)
    end
    address.save!
    @supplier.address = address

    if @supplier.update(supplier_params)
      render json: SupplierSerializer.new(@supplier, { include: [:address, :contact] })
    else
      render json: @supplier.errors, status: :unprocessable_entity
    end
  end

  # DELETE /suppliers/1
  def destroy
    authorize @supplier

    @supplier.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def supplier_params
    params.fetch(:supplier, {}).permit(Supplier::PERMITTED_PARAMS)
  end

  def address_params
    params.fetch(:supplier, {}).permit(Address::PERMITTED_PARAMS)
  end

  def address_params_without_coordinates
    params.fetch(:supplier, {}).permit(Address::PERMITTED_PARAMS_WITHOUT_COORDINATES)
  end
end
