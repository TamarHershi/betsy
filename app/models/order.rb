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
  validates :mailing_address, presence: true, on: :pay
  validates :cc_number, presence: true, on: :pay
  validates :zip, presence: true, on: :pay
  validates :cc_exp, presence: true, on: :pay
  validates :cc_cvv, presence: true, on: :pay

  # def session_over
  #   if self.status = "pending"
  #     self.destroy!
  #   end
  # end

  def self.pending(first_product)
    Order.transaction do
      order = Order.new(status: 'pending')
      order.orderitems << Orderitem.create!(quantity: 1, order_id: order.id, product_id: first_product.id)
      order.save!
      return order
    end
  end

  def total(user_id)
    sales = []
    self.products.each do |product|
      sales.push(product.price) if product.user_id == user_id
    end
    return sales.inject(0) {|r, e| r + e }
  end

  #possibly want merchants to be able to destroy orders of different statuses,
  #but if you are a customer you can only clear cart before you have paid.
  def customer_destroys_only_pending
    if !session[:user_id]
      self.status = "pending"
    end
  end

  def has_orderitem
    !!self.orderitems
  end
end
