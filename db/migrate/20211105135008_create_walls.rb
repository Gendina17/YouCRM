class CreateWalls < ActiveRecord::Migration[6.1]
  def change
    create_table :walls do |t|
      t.text :body
      t.integer :user_id
      t.integer :company_id

      t.timestamps
    end
  end
end
