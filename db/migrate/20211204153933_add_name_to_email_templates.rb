class AddNameToEmailTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :email_templates, :name, :string
  end
end
