class AddItemIdToTicketLog < ActiveRecord::Migration[6.1]
  def change
    add_column :ticket_logs, :item_id, :integer
  end
end
