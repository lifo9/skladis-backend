class VendorsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_vendor, only: %i[ show update destroy destroy_logo ]

  # GET /vendors
  def index
    authorize Vendor.all

    if params[:search]
      @vendors = Vendor.search_all_fields(params[:search])
    else
      @vendors = paginate Vendor.all
    end
    @vendors = @vendors.api_order_by(params[:order_by], params[:order]) if params[:order_by] || params[:order]

    render json: VendorSerializer.new(@vendors)
  end

  # GET /vendors/1
  def show
    authorize @vendor

    render json: VendorSerializer.new(@vendor)
  end

  # POST /vendors
  def create
    authorize Vendor

    @vendor = Vendor.new(vendor_params)
    serialized_vendor = VendorSerializer.new(@vendor)

    if @vendor.save
      render json: serialized_vendor, status: :created
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vendors/1
  def update
    authorize Vendor

    if @vendor.update(vendor_params)
      render json: VendorSerializer.new(@vendor)
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vendors/1
  def destroy
    authorize @vendor

    @vendor.destroy
  end

  # DELETE /vendors/1/logo
  def destroy_logo
    @vendor.logo.purge
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def vendor_params
    params.fetch(:vendor, {}).permit(Vendor::PERMITTED_PARAMS)
  end
end
