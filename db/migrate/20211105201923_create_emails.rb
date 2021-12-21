class CreateEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.string :body
      t.boolean :incoming
      t.integer :company_id

      t.timestamps
    end
  end
end
