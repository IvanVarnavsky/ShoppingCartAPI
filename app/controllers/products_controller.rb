require 'securerandom'
class ProductsController < ApplicationController

  # POST /cart/add?token=..&name=..&quantity=..&price=..
  def add
    if cart_find
      cart = cart_find
    else
      cart = Cart.new(token: SecureRandom.hex(10))
    end
    if prod_find(cart)
      product = prod_find(cart)
      new_quantity = params[:quantity].to_i + product.quantity
      product.update(quantity: new_quantity)
    else
      product = cart.products.new(prod_params)
    end

    if product.save
      render json: [cart,[product]], status: 201
    else
      render json: {errors: product.errors}, status: :unprocessable_entity
    end
  end

  # GET /cart/product?token=..&name=..
  def show
    if cart_find
      cart = cart_find
      if prod_find(cart)
        product = prod_find(cart)
        render json: product, status: 201
      else
        render json: "product " + params[:name] + " is not found", status: :ok
      end
    else
      render json: "cart " + params[:token] + " is not found", status: :ok
    end
  end

  # PUT /cart/update?token=..&name=..&quantity=..
  def update
    if cart_find
      cart = cart_find
      if prod_find(cart)
        product = prod_find(cart)
        new_quantity = params[:quantity].to_i
        if (new_quantity > 0)
          product.update(quantity: new_quantity)
          if product.save
            render json: product, status: 201
          else
            render json: {errors: product.errors}, status: :unprocessable_entity
          end
        else
          product.destroy
          if cart.products.empty?
            cart.destroy
          end
          render json: { success: true }, status: 204
        end
      else
        render json: "product " + params[:name] + " is not found", status: :ok
      end
    else
      render json: "cart " + params[:token] + " is not found", status: :ok
    end
  end

  # DELETE /cart/del?token=..&name=..&quantity=..
  def del
    if cart_find
      cart = cart_find
      if prod_find(cart)
        product = prod_find(cart)
        new_quantity = product.quantity - params[:quantity].to_i
        if (new_quantity > 0) && (params[:quantity].to_i > 0)
          product.update(quantity: new_quantity)
          if product.save
            render json: product, status: 201
          else
            render json: {errors: product.errors}, status: :unprocessable_entity
          end
        else
          product.destroy
          if cart.products.empty?
            cart.destroy
          end
          render json: { success: true }, status: 204
        end
      else
        render json: "product " + params[:name] + " is not found", status: :ok
      end
    else
      render json: "cart " + params[:token] + " is not found", status: :ok
    end
  end

  private
   def prod_params
     params.permit(:name, :price, :quantity)
   end

   def cart_find
     return Cart.find_by(token: params[:token])
   end

   def prod_find(cart)
     return cart.products.find_by(name: params[:name])
   end
end
