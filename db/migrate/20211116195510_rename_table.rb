class RenameTable < ActiveRecord::Migration[6.1]
  def change
    rename_table :walls_users, :users_walls
  end
end
