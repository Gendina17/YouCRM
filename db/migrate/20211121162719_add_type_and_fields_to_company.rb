class AddTypeAndFieldsToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :type_client, :string
    add_column :companies, :client_fields, :text
  end
end
