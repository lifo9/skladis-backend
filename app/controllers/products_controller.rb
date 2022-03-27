class ProductsController < ApplicationController
  require 'will_paginate/array'
  before_action :authorize_access_request!
  before_action :set_product, only: %i[ show update destroy price_history ]

  # GET /products
  def index
    authorize Product.all

    @products = api_index(Product, params, true, false, false)

    if params[:order] && params[:order_by] == "in_stock"
      if params[:order] == "asc"
        @products = @products.sort_by { |product| product.in_stock }
      else
        @products = @products.sort_by { |product| product.in_stock }.reverse
      end
    end

    if params[:order] && params[:order_by] == "in_stock_critical"
      if params[:order] == "asc"
        @products = @products.sort_by do |product|
          in_stock = product.in_stock
          critical = product.pieces_critical == 0 ? in_stock : product.pieces_critical
          (100 / critical) * in_stock
        end
      else
        @products = @products.sort_by do |product|
          in_stock = product.in_stock
          critical = product.pieces_critical == 0 ? in_stock : product.pieces_critical
          (100 / critical) * in_stock
        end.reverse
      end
    end

    @products = paginate @products

    render json: ProductSerializer.new(@products, { include: [:suppliers] })
  end

  # GET /products/select-options
  def select_options
    authorize Product.all

    render json: api_select_options(Product, [:name], :id, params)
  end

  # GET /products/1
  def show
    authorize @product

    render json: ProductSerializer.new(@product, { include: [:suppliers], params: { image_type: :normal } })
  end

  # GET /products/1/price-history
  def price_history
    authorize @product

    prices = api_index(InvoiceItem, params, true, InvoiceItem.where(product: @product))

    render json: InvoiceItemSerializer.new(prices, { include: [:product, :supplier, :invoice], params: { invoice_date: true } })
  end

  # POST /products
  def create
    authorize Product

    @product = Product.new(product_params)
    if barcode_params.present?
      barcode = Barcode.new(barcode_params)
      @product.barcode = barcode
    end
    serialized_product = ProductSerializer.new(@product, { include: [:suppliers] })

    if @product.save
      render json: serialized_product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    authorize Product

    if barcode_params.present?
      barcode = Barcode.find_by(barcode_params)
      if !barcode.present?
        if @product.barcode.present?
          barcode_temp = @product.barcode
        end
        barcode = Barcode.new(barcode_params)
      end

      barcode.save!
      @product.barcode = barcode
    end

    if @product.update(parse_images(product_params))
      if barcode_temp
        barcode_temp.destroy!
      end

      render json: ProductSerializer.new(@product, { include: [:suppliers] })
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    authorize @product

    @product.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.fetch(:product, {}).permit(Product::PERMITTED_PARAMS)
  end

  def barcode_params
    params.fetch(:product, {}).permit(Barcode::PERMITTED_PARAMS)
  end

  def parse_images(params)
    if params[:images].present?
      params[:images] = params[:images].map do |image|
        if image.is_a?(String) && image.to_i.to_s == image
          image_object = @product.images.find_by(id: image)
          image_object.blob
        else
          image
        end
      end
      return params
    end

    return params
  end
end