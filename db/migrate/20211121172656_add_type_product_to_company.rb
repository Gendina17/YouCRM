class AddTypeProductToCompany < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :type_product, :string
  end
end
