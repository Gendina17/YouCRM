class SetDefaultToTicket < ActiveRecord::Migration[6.1]
  def change
    change_column :tickets, :is_closed, :boolean, default: false
  end
end
