class ChangeTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :client_id, :bigint
    add_column :tickets, :client_type, :string
    add_column :tickets, :product_id, :bigint
    add_column :tickets, :product_type, :string
  end
end
