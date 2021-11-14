class AddIsFiredToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_fired, :boolean
  end
end
