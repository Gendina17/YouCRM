class CreateStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :statuses do |t|
      t.integer :company_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
