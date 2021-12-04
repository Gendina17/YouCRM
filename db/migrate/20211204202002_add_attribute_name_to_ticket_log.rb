class AddAttributeNameToTicketLog < ActiveRecord::Migration[6.1]
  def change
    add_column :ticket_logs, :attribute_name, :string
  end
end
