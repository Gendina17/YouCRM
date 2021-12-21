class AddInfoAndContactsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :info, :string
    add_column :users, :contacts, :json
  end
end
