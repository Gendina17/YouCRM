class AddTagToWalls < ActiveRecord::Migration[6.1]
  def change
    add_column :walls, :tag, :string
  end
end
