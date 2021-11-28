class AddManagerIdToTickets < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :manager_id, :integer
  end
end
