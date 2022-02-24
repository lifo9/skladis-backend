class ProductsController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_product, only: %i[ show update destroy ]

  # GET /products
  def index
    authorize Product.all

    if params[:search]
      @products = paginate Product.search_all_fields(params[:search])
    else
      @products = paginate Product.all
    end
    @products = @products.api_order_by(params[:order_by], params[:order]) if params[:order_by] || params[:order]

    render json: ProductSerializer.new(@products, { include: [:suppliers] })
  end

  # GET /products/1
  def show
    authorize @product

    render json: ProductSerializer.new(@product, { include: [:suppliers], params: { image_type: :normal } })
  end

  # POST /products
  def create
    authorize Product

    @product = Product.new(product_params)
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

    if @product.update(product_params)
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
end