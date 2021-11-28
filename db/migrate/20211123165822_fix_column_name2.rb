class FixColumnName2 < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :type, :type_product
  end
end
