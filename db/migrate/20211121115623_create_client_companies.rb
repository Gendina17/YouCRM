class CreateClientCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :client_companies do |t|
      t.string :name
      t.text :description
      t.string :phone
      t.string :email
      t.string :address
      t.string :responsible
      t.text :note
      t.integer :points, default: 0
      t.integer :manager_id

      t.timestamps
    end
  end
end
