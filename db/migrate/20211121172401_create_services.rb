class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.string :name
      t.datetime :date
      t.string :type
      t.string :duration
      t.text :note
      t.integer :price
      t.boolean :is_important
      t.integer :discount
      t.text :description
      t.string :executor

      t.timestamps
    end
  end
end
