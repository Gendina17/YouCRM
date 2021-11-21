class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.datetime :date
      t.string :type
      t.text :note
      t.integer :number
      t.text :description
      t.integer :price
      t.boolean :is_important
      t.integer :discount

      t.timestamps
    end
  end
end
