class AddManagerIdToEmails < ActiveRecord::Migration[6.1]
  def change
    add_column :emails, :manager_id, :integer
  end
end
