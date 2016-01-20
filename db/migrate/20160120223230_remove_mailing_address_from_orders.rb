class RemoveMailingAddressFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :mailing_address, :string
  end
end
