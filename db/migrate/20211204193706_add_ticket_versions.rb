class AddTicketVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :ticket_versions do |t|
      t.string   :item_type, {:null=>false}
      t.integer  :item_id,   null: false, limit: 8
      t.string   :event,     null: false
      t.string   :whodunnit
      t.json     :object
      t.json     :object_changes
      t.datetime :created_at
    end

    add_index :ticket_versions, %i(item_type item_id)
  end
end
