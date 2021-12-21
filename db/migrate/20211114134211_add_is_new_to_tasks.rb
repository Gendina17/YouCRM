class AddIsNewToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :is_new, :boolean, default: true
  end
end
