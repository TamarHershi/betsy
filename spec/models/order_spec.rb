require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:good_hash) do
  {
    status: "pending",
    cc_name: "John Carlisle",
    email_address: "jcarl@gmail.com",
    street_address: "653 Gorge Way",
    cc_number: 5110538084994719,
    cc_exp: "06/18",
    cc_cvv: "674",
    zip: 19583
  }
  end
  let(:product_hash) do
     {name: "Geometry Like Woahhh",
      price: 5645,
      stock: "1",
      photo_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDeCvOq-lfd-xau5kCj_RZ5WOD1wldXJybYd9abKVYwZKaGAay",
      description: "I drew this just for you.",
      user_id: 2,
      retired: false
    }
  end
  let(:second_product) do
     {name: "Another Product Thing",
      price: 5645245,
      stock: "2",
      photo_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDeCvOq-lfd-xau5kCj_RZ5WOD1wldXJybYd9abKVYwZKaGAay",
      description: "I drew this just for you.",
      user_id: 1,
      retired: false
    }
  end

  describe ".validates" do
    let (:no_status_hash) do
      {
        status: nil,
        cc_name: "John Carlisle",
        email_address: "jcarl@gmail.com",
        street_address: "653 Gorge Way",
        cc_number: 5110538084994719,
        cc_exp: "06/18",
        cc_cvv: "674",
        zip: 19583
      }
    end
  #   let (:no_name_hash) do
  #     {
  #       status: "pending",
  #       cc_name: nil,
  #       email_address: "jcarl@gmail.com",
  #       street_address: "653 Gorge Way",
  #       cc_number: 5110538084994719,
  #       cc_exp: "06/18",
  #       cc_cvv: "674",
  #       zip: 19583
  #     }
  #   end
  #
  #   let (:no_email_hash) do
  #     {
  #       status: "pending",
  #       cc_name: "John",
  #       email_address: nil,
  #       street_address: "653 Gorge Way",
  #       cc_number: 5110538084994719,
  #       cc_exp: "06/18",
  #       cc_cvv: "674",
  #       zip: 19583
  #     }
  #   end
  #
  #   let (:no_mailing_hash) do
  #     {
  #       status: "pending",
  #       cc_name: "John",
  #       email_address: "jcarl@gmail.com",
  #       street_address: nil,
  #       cc_number: 5110538084994719,
  #       cc_exp: "06/18",
  #       cc_cvv: "674",
  #       zip: 19583
  #     }
  #   end
  #
  #   let (:no_cc_num_hash) do
  #     {
  #       status: "pending",
  #       cc_name: "John",
  #       email_address: "jcarl@gmail.com",
  #       street_address: "123 Fake Street",
  #       cc_number: nil,
  #       cc_exp: "06/18",
  #       cc_cvv: "674",
  #       zip: 19583
  #     }
  #   end
  #
  #   let (:no_cc_exp_hash) do
  #     {
  #       status: "pending",
  #       cc_name: "John",
  #       email_address: "jcarl@gmail.com",
  #       street_address: "123 Fake Street",
  #       cc_number: 5110538084994719,
  #       cc_exp: nil,
  #       cc_cvv: "674",
  #       zip: 19583
  #     }
  #   end
  #
  #   let (:no_cc_cvv_hash) do
  #     {
  #       status: "pending",
  #       cc_name: "John",
  #       email_address: "jcarl@gmail.com",
  #       street_address: "123 Fake Street",
  #       cc_number: 5110538084994719,
  #       cc_exp: "06/18",
  #       cc_cvv: nil,
  #       zip: 19583
  #     }
  #   end
    #
    # let (:no_zip_hash) do
    #   {
    #     status: "pending",
    #     cc_name: "John",
    #     email_address: "jcarl@gmail.com",
    #     street_address: "123 Fake Street",
    #     cc_number: 5110538084994719,
    #     cc_exp: "06/18",
    #     cc_cvv: "123",
    #     zip: nil
    #   }
    # end

    it "must have a status" do
      expect(Order.new(no_status_hash)).to_not be_valid
      expect(Order.new(good_hash)).to be_valid
    end
    #
    # it "must have a credit card name on pay" do
    #   expect(Order.new(no_name_hash)).to_not be_valid
    # end

    # it "must have an email address on pay" do
    #   expect(Order.new(no_email_hash)).to_not be_valid
    # end
    #
    # it "must have a mailing address on pay" do
    #   expect(Order.new(no_mailing_hash)).to_not be_valid
    # end
    #
    # it "must have a credit card num on pay" do
    #   expect(Order.new(no_cc_num_hash)).to_not be_valid
    # end

    # it "must have a credit card expiration date on pay" do
    #   expect(Order.new(no_cc_exp_hash)).to_not be_valid
    # end
    #
    # it "must have a credit card cvv on pay" do
    #   expect(Order.new(no_cc_cvv_hash)).to_not be_valid
    # end
    #
    # it "must have a zip code on pay" do
    #   expect(Order.new(no_zip_hash)).to_not be_valid
    # end

    # it "must have an order item on creation" do
    #   t.integer  "product_id"
    #   t.integer  "order_id"
    #   t.integer  "quantity"
    #     @order = Order.new
    #     @test_order_item = Orderitem.create(product_id: 1, order_id: @)
    # end
  end

  describe "self.pending" do
    it "" do

    end
  end

  describe "decrement_products_stock" do
    it "" do

    end
  end

  describe "total" do
    it "" do

    end
  end

  describe "total_by_user(user_id)" do
    let (:order) do
      order = Order.create(good_hash)
      p = Product.create!(product_hash)
      p2 = Product.create!(second_product)
      order.products << [p, p2]
      return order
    end
    it "returns an integer" do
      expect(order.total_by_user(1)).to be_a(Integer)
    end
    it "returns the total sales for a given user" do
      expect(order.total_by_user(2)).to eq(5645)
      expect(order.total_by_user(1)).to eq(5645245)
    end
  end

  describe "mark_shipped?" do
    before :each do
      p = Product.create!(product_hash)
      p2 = Product.create!(second_product)
      @order = Order.pending(p)
      @order.products << p2
      @order.orderitems[0].item_shipped
      @order.mark_shipped

      @order2 = Order.pending(p)
      @order2.products << [p2]
      # @order2.update(good_hash)
      @order2.orderitems[0].item_shipped
      @order2.orderitems[1].item_shipped
      @order2.mark_shipped
    end
    it "marks an order as shipped only if all orderitems are shipped" do
      expect(@order.status).to eq("pending")
      expect(@order2.status).to eq("completed")
    end
  end

  #describe "session_over" do
  #it ""
  #end

  #test that destroying an order destroys its order items

end
