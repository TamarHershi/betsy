require 'httparty'
class OrdersController < ApplicationController
  #look up callbacks
  #also, in order to make filter work, buttons to do stuff to orders need to send an id into params. (see guest_authorize method, which uses id)
  #this is to help make it so only the person who started an order can do stuff to it.
  before_action :guest_authorize, :only =>[:clear_cart, :cancel_as_guest, :pay]
  before_action :navbar_categories, only: [:cart]


  #the order from the perspective of the merchant
  def show
    @order = Order.find(params[:id])
  end

  #the order from the perspective of the guest
  #stuff needed to view the cart page
  def cart
    if !session[:order_id]
      @cart_status = "empty"
    end
  end

  #before you pay, clearing cart destroys order and orderitems.
  #after you've paid, you instead cancel the order, and the order sticks around in the database
  def clear_cart
    @order = Order.find(session[:order_id])
    @order.destroy!
    session[:order_id] = nil
    redirect_to root_path
  end

  def checkout
    @order = Order.find(session[:order_id])
  end

  def confirm
    @order = Order.find(session[:order_id])


  end

  def cancel_as_guest
    @order = Order.find(session[:order_id])
    @order.update_attribute(:status, "cancelled")
    session[:order_id] = nil
    @cart_status = "empty"
    redirect_to root_path
  end

  def finalize
    @order = Order.find(session[:order_id])
    @order.decrement_products_stock
    session[:order_id] = nil
    @cart_status = "empty"
    flash[:notice] = "Thank you for your order!"
    redirect_to root_path
  end

  def pay
# talk to the shipping app and ask for shipping info
    @order = Order.find(session[:order_id])
    @order.update(order_params[:order])
    @order.placed_at = Time.now
    @order.status =  "paid"
    @order.save!

    order_hash = {
      :city =>    params[:order][:city],
      :state =>   params[:order][:state],
      :zip =>     params[:order][:zip],
      :country => "US"
    }
    order_hash = order_hash.to_query
    @result = HTTParty.get('http://localhost:3000/rates#{order_hash}', headers: {'Accept' => 'application/json'}, format: :json).parsed_response
    # return result (in the confirm page?)
    redirect_to order_confirm_path(@order.id)
  end



  #edit and update... are for the guest to do on the cart page?
  #needs more thought
  #we have lots of specific ways we are updating, as it stands right now
  def edit
    @order = Order.find(params[:id])
  end

  def update
    id = params[:id]
    order = Order.find(id)
    order.update_attributes(order_params[:order])
    redirect_to order_path(params[:id])
  end


  private

  def order_params
    params.permit(order:[:status, :cc_name, :email_address, :street_address, :city, :state, :cc_number, :cc_exp, :cc_cvv, :zip, :placed_at])
  end

  #views will need to make sure they send in an id to use here
  def guest_authorize
    unless session[:order_id]
    redirect_to root_path
    end
  end

end
