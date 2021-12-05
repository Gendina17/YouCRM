class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :subject
      t.integer :status_id
      t.integer :category_id
      t.integer :client_id
      t.text :description
      t.integer :product_id

      t.timestamps
    end
  end
end
