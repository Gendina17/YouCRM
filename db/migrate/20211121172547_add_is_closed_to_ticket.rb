class AddIsClosedToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :is_closed, :boolean
  end
end
