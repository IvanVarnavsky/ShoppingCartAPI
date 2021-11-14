class CartsController < ApplicationController

  # POST /carts?token=
#  def create
#    cart = Cart.new(cart_params)
#    if cart.save
#      render json: cart, status: 201
#    else
#      # Что-то пошло не так
#      render json: {errors: cart.errors}, status: :unprocessable_entity
#    end
#  end

  # GET /carts
#  def index
#    carts = Cart.find_each
#    render json: carts, status: :ok
#  end

  # GET /cart/show?token=
  def show
    cart = cart_find
    render json: [cart, cart.products], status: :ok
  end

  # GET /cart/summa?token=
  def summa
    cart = cart_find
    sum = 0.0
    cart.products.each do |product|
      sum += product.price * product.quantity
    end
    render json: [cart, cart.products,"summa":sum], status: :ok
  end

  # DELETE /cart/clear?token=
  def destroy
    cart = cart_find
    cart.destroy
    render json: { success: true }, status: 204
  end

  # GET /cart/filter?token=..(&more=.., &cheaper=.., &expensive=..)
  def filter
    cart = cart_find
    filtred_cart = Array.new(cart.products)
    if params[:more].present?
      cart.products.each do |product|
        if product.quantity <= params[:more].to_i
          filtred_cart.delete(product)
        end
      end
    end
    if params[:cheaper].present?
      cart.products.each do |product|
        if product.price >= params[:cheaper].to_f
          filtred_cart.delete(product)
        end
      end
    end
    if params[:expensive].present?
      cart.products.each do |product|
        if product.price <= params[:expensive].to_f
          filtred_cart.delete(product)
        end
      end
    end
    render json: filtred_cart, status: :ok
  end

  private
      def cart_params
          params.permit(:token)
      end

      def cart_find
        return Cart.find_by(token: params[:token])
      end
end
