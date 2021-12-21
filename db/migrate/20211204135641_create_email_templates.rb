class CreateEmailTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :email_templates do |t|
      t.text :body
      t.string :subject
      t.integer :company_id

      t.timestamps
    end
  end
end
