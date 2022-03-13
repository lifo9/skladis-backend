class InvoicesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_invoice, only: %i[ show update destroy ]

  # GET /invoices
  def index
    authorize Invoice.all

    @invoices = api_index(Invoice, params)

    render json: InvoiceSerializer.new(@invoices)
  end

  # GET /invoices/1
  def show
    authorize @invoice

    render json: InvoiceSerializer.new(@invoice, { include: [:invoice_items] })
  end

  # POST /invoices
  def create
    authorize Invoice

    @invoice = Invoice.new(invoice_params)
    serialized_invoice = InvoiceSerializer.new(@invoice, { include: [:invoice_items] })

    if @invoice.save
      render json: serialized_invoice, status: :created
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoices/1
  def update
    authorize Invoice

    if @invoice.update(invoice_params)
      render json: InvoiceSerializer.new(@invoice)
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  def destroy
    authorize @invoice

    @invoice.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def invoice_params
    params.fetch(:invoice, {}).permit(Invoice::PERMITTED_PARAMS)
  end
end