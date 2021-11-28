class RenameFieldInNotes < ActiveRecord::Migration[6.1]
  def change
    rename_column :notes, :client_id, :ticket_id
  end
end
