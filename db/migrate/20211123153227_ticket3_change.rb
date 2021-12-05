class Ticket3Change < ActiveRecord::Migration[6.1]
  def change
    change_column :tickets, :product_id, :bigint, null: true
  end
end
