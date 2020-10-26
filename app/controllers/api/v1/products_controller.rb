class Api::V1::ProductsController < ApplicationController
  before_action :check_login, only: %i[create]
  before_action :set_product, only: %i[show update destroy]
  before_action :check_owner, only: %i[update destroy]

  def index
    @products = Product.all

    render json: @products, status: :ok
  end

  def show
    render json: @product, status: :ok
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: { errors: @product.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end
end