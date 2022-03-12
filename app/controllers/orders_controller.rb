class OrdersController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_order, only: %i[ show update destroy ]

  # GET /orders
  def index
    authorize Order.all

    @orders = api_index(Order, params)

    render json: OrderSerializer.new(@orders)
  end

  # GET /orders/1
  def show
    authorize @order

    render json: OrderSerializer.new(@orders, { include: [:order_items] })
  end

  # POST /orders
  def create
    authorize Order

    @order = Order.new(order_params)
    serialized_order = OrderSerializer.new(@order, { include: [:order_items] })

    if @order.save
      render json: serialized_order, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    authorize Order

    if @order.update(order_params)
      render json: OrderSerializer.new(@order)
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    authorize @order

    @order.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.fetch(:order, {}).permit(Order::PERMITTED_PARAMS)
  end
end