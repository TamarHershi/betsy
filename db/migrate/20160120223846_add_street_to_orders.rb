class AddStreetToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :street_address, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
  end
end
