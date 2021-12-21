class AddActiveToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :active, :boolean
  end
end
