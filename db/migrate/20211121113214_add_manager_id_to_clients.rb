class AddManagerIdToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :manager_id, :integer
  end
end
