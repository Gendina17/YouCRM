class AddFieldsToClients < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :address, :string
    add_column :clients, :description, :text
    add_column :clients, :note, :text
    add_column :clients, :points, :integer, default: 0
    add_column :clients, :password, :string
    add_column :clients, :patronymic, :string
  end
end
