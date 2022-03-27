class InvoicesController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_invoice, only: %i[ show update destroy destroy_invoice_file, update_stocked_in ]

  # GET /invoices
  def index
    authorize Invoice.all

    @invoices = api_index(Invoice, params)

    render json: InvoiceSerializer.new(@invoices)
  end

  # GET /invoices/invoice-date-range
  def invoice_date_range
    authorize Invoice.all

    min_created_at = Invoice.minimum(:invoice_date)
    max_created_at = Invoice.maximum(:invoice_date)

    render json: { min: min_created_at, max: max_created_at }
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
    @invoice.user = current_user
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

    if @invoice.invoice_items
      @invoice.invoice_items.destroy_all
    end

    if @invoice.update(invoice_params)
      render json: InvoiceSerializer.new(@invoice)
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  def update_stocked_in
    authorize Invoice

    if @invoice.update(stocked_in: params[:stocked_in])
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

  # DELETE /invoices/1/avatar
  def destroy_invoice_file
    @invoice.invoice_file.purge
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