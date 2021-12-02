class ClientAndEmails < ActiveRecord::Migration[6.1]
  def change
    remove_column :emails, :client_id, :integer
    add_reference :emails, :client, polymorphic: true
  end
end
