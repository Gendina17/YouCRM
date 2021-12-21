class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :description
      t.text :the_role

      t.timestamps
    end
  end
end
