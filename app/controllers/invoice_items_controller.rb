class InvoiceItemsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_invoice_item, only: %i[ show update destroy ]

  # GET /invoice-items
  def index
    authorize InvoiceItem.all

    @invoice_items = api_index(InvoiceItem, params)

    render json: InvoiceItemSerializer.new(@invoice_items)
  end

  # GET /invoice-items/1
  def show
    authorize @invoice_item

    render json: InvoiceItemSerializer.new(@invoice_item)
  end

  # POST /invoice-items
  def create
    authorize InvoiceItem

    @invoice_item = InvoiceItem.new(invoice_item_params)
    serialized_invoice = InvoiceItemSerializer.new(@invoice_item)

    if @invoice_item.save
      render json: serialized_invoice, status: :created
    else
      render json: @invoice_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoice-items/1
  def update
    authorize InvoiceItem

    if @invoice_item.update(invoice_item_params)
      render json: InvoiceItemSerializer.new(@invoice_item)
    else
      render json: @invoice_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoice-items/1
  def destroy
    authorize @invoice_item

    @invoice_item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice_item
    @invoice_item = InvoiceItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def invoice_item_params
    params.fetch(:invoice_item, {}).permit(InvoiceItem::PERMITTED_PARAMS)
  end
end