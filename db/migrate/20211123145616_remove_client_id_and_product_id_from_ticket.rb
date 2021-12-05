class RemoveClientIdAndProductIdFromTicket < ActiveRecord::Migration[6.1]
  def change
    remove_column :tickets, :client_id, :integer
    remove_column :tickets, :product_id, :integer
  end
end
