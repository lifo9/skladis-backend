class OrderItemsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_order_item, only: %i[ show update destroy ]

  # GET /order-items
  def index
    authorize OrderItem.all

    @order_items = api_index(OrderItem, params)

    render json: OrderItemSerializer.new(@order_items)
  end

  # GET /order-items/1
  def show
    authorize @order_item

    render json: OrderItemSerializer.new(@order_items)
  end

  # POST /order-items
  def create
    authorize OrderItem

    @order_item = OrderItem.new(order_item_params)
    serialized_order = OrderItemSerializer.new(@order_item)

    if @order_item.save
      render json: serialized_order, status: :created
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /order-items/1
  def update
    authorize OrderItem

    if @order_item.update(order_item_params)
      render json: OrderItemSerializer.new(@order_item)
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /order-items/1
  def destroy
    authorize @order_item

    @order_item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_item_params
    params.fetch(:order_item, {}).permit(OrderItem::PERMITTED_PARAMS)
  end
end