class RemoveFieldsFromTables < ActiveRecord::Migration[6.1]
  def change
    remove_column :clients, :note, :text
    remove_column :client_companies, :note, :text
    remove_column :products, :note, :text
    remove_column :services, :note, :text
  end
end
