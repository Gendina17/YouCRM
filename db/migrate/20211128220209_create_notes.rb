class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.text :body
      t.string :subject
      t.integer :manager_id
      t.integer :company_id

      t.timestamps
    end
  end
end
