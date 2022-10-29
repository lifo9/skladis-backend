class SuppliersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_supplier, only: %i[ show update destroy ]

  # GET /suppliers
  def index
    authorize Supplier.all

    @suppliers = api_index(Supplier, params)

    render json: SupplierSerializer.new(@suppliers, { include: [:address, :contact] })
  end

  # GET /suppliers/select-options
  def select_options
    authorize Supplier.all

    render json: api_select_options(Supplier, [:name], :id, params)
  end

  # GET /suppliers/1
  def show
    authorize @supplier

    render json: SupplierSerializer.new(@supplier, { include: [:address, :contact] })
  end

  # POST /suppliers
  def create
    authorize Supplier

    @supplier = Supplier.new(supplier_address_params)

    serialized_supplier = SupplierSerializer.new(@supplier, { include: [:address, :contact] })

    if @supplier.save
      render json: serialized_supplier, status: :created
    else
      render json: @supplier.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /suppliers/1
  def update
    authorize Supplier

    if @supplier.update(supplier_address_params)
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

  def supplier_address_params
    params.fetch(:supplier, {}).permit(Supplier::PERMITTED_PARAMS + [address_attributes: Address::PERMITTED_PARAMS])
  end
end
