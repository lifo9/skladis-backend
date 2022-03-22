class StockTransactionsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_stock_transaction, only: %i[ show ]

  # GET /stock-transactions
  def index
    authorize StockTransaction.all

    @stock_transactions = api_index(StockTransaction, params)

    render json: StockTransactionSerializer.new(@stock_transactions, { include: [:user, :stock, 'stock.product', 'stock.room'] })
  end

  # GET /stock-transactions/created-at-range
  def created_at_range
    authorize StockTransaction.all

    min_created_at = StockTransaction.minimum(:created_at)
    max_created_at = StockTransaction.maximum(:created_at)

    render json: { min: min_created_at, max: max_created_at }
  end

  # GET /stock-transactions/1
  def show
    authorize @stock_transaction

    render json: StockTransactionSerializer.new(@stock_transaction, { include: [:user, :stock, 'stock.product', 'stock.room'] })
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stock_transaction
    @stock_transaction = StockTransaction.find(params[:id])
  end
end