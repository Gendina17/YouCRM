class AddClientIdToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :client_id, :integer
  end
end
