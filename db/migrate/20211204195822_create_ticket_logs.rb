class CreateTicketLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :ticket_logs do |t|
      t.integer :ticket_id
      t.string :message
      t.string :loggable_type
      t.integer :version_id
      t.integer :manager_id
      t.string :value
      t.string :previos_value

      t.timestamps
    end
  end
end
