class Order < ActiveRecord::Base
  belongs_to :user
  has_many :orderitems, :dependent => :destroy
  has_many :products, through: :orderitems

  validate :has_orderitem, on: :create
  validate :customer_destroys_only_pending, on: :destroy
  validates :status, presence: true
  validates :status, inclusion: { in: %w(pending) }, on: :create
  validates :status, inclusion: { in: %w(paid) }, on: :pay
  validates :status, inclusion: { in: %w(complete) }, on: :ship
  validates :status, inclusion: { in: %w(cancelled) }, on: :cancel
  validates :cc_name, presence: true, on: :pay
  validates :email_address, presence: true, on: :pay
  validates :street_address, presence: true, on: :pay
  validates :cc_number, presence: true, on: :pay
  validates :zip, presence: true, on: :pay
  validates :cc_exp, presence: true, on: :pay
  validates :cc_cvv, presence: true, on: :pay
  validates :city, presence: true, on: :pay
  validates :state, presence: true, on: :pay

  def self.pending(first_product)
    Order.transaction do
      order = Order.new(status: 'pending')
      order.orderitems << Orderitem.create!(quantity: 1, order_id: order.id, product_id: first_product.id)
      order.save!
      return order
    end
  end

  def decrement_products_stock
    Order.transaction do
      self.orderitems.each do |orderitem|
        product = orderitem.product
        product.stock -= orderitem.quantity
        product.save!
      end
    end
  end

  def total
      sales = []
      self.orderitems.each do |orderitem|
        sales.push(orderitem.quantity * orderitem.product.price)
      end
      return sales.inject(0) {|r, e| r + e }
  end

  def total_by_user(user_id)
    sales = []
    self.products.each do |product|
      sales.push(product.price) if product.user_id == user_id
    end
    return sales.inject(0) {|r, e| r + e }
  end

  def mark_shipped
    c = 0
    self.orderitems.each do |orderitem|
      c += 1 if orderitem.status == 'shipped'
    end
    self.status = 'completed' if c == self.orderitems.length
    self.save
    return self
  end
  #returns the last four numbers of the cc
  def last_four
    return self.cc_number[-4..-1]
  end

  def customer_destroys_only_pending
    !session[:user_id] && self.status = "pending"
  end

  def has_orderitem
    !!self.orderitems
  end
end
