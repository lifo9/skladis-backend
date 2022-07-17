class StocksController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_stock, only: %i[ show ]
  before_action :set_current_user_id, only: %i[ stock_in stock_out stock_transfer ]
  before_action :set_stock_service_in_out, only: %i[ stock_in stock_out ]
  before_action :set_stock_service_transfer, only: %i[ stock_transfer ]

  # GET /stocks
  def index
    authorize Stock.all

    @stocks = api_index(Stock, params, true, Stock.where(pieces: 1..), true)

    render json: StockSerializer.new(@stocks, { include: [:product, :room] })
  end

  # GET /stocks/expiration-range
  def expiration_range
    authorize Stock.all

    min_expiration = Stock.minimum(:expiration)
    max_expiration = Stock.maximum(:expiration)

    render json: { min: min_expiration, max: max_expiration }
  end

  # GET /stocks/1
  def show
    authorize @stock

    render json: StockSerializer.new(@stock, { include: [:product, :room] })
  end

  # POST /stocks/in
  def stock_in
    authorize Stock

    stock = @stock_service.stock_in(stock_in_out_params[:location_id], stock_in_out_params[:quantity])

    render json: StockSerializer.new(stock, { include: [:product, :room] })
  end

  # POST /stocks/out
  def stock_out
    authorize Stock

    stock = @stock_service.stock_out(stock_in_out_params[:location_id], stock_in_out_params[:quantity])

    render json: StockSerializer.new(stock, { include: [:product, :room] })
  end

  # POST /stocks/transfer
  def stock_transfer
    authorize Stock

    stocks = @stock_service.transfer(
      stock_transfer_params[:room_from_id],
      stock_transfer_params[:room_to_id],
      stock_transfer_params[:quantity]
    )

    render json: stocks.transform_values { |stock| StockSerializer.new(stock, { include: [:product, :room] }) }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stock
    @stock = Stock.find(params[:id])
  end

  def set_current_user_id
    @current_user_id = current_user&.id
  end

  def stock_in_out_params
    params.fetch(:stock, {}).permit(Stock::PERMITTED_PARAMS_IN_OUT)
  end

  def stock_transfer_params
    params.fetch(:stock, {}).permit(Stock::PERMITTED_PARAMS_TRANSFER)
  end

  def set_stock_service_in_out
    @stock_service = StockService.new(
      user_id: @current_user_id,
      product_id: stock_in_out_params[:product_id],
      expiration: stock_in_out_params[:expiration]
    )
  end

  def set_stock_service_transfer
    @stock_service = StockService.new(
      user_id: @current_user_id,
      product_id: stock_transfer_params[:product_id],
      expiration: stock_transfer_params[:expiration]
    )
  end
end
