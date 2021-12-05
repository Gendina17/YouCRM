class Change2Ticket < ActiveRecord::Migration[6.1]
  def change
    remove_column :tickets, :client_id, :bigint
    remove_column :tickets, :product_id, :bigint
    remove_column :tickets, :client_type, :string
    remove_column :tickets, :product_type, :string
    add_reference :tickets, :client, polymorphic: true
    add_reference :tickets, :product, polymorphic: true
  end
end
