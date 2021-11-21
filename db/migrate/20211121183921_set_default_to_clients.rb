class SetDefaultToClients < ActiveRecord::Migration[6.1]
  def change
    change_column :companies, :client_fields, :text, default: ""
  end
end
