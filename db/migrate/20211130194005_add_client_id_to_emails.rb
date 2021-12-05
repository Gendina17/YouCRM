class AddClientIdToEmails < ActiveRecord::Migration[6.1]
  def change
    add_column :emails, :client_id, :integer
  end
end
