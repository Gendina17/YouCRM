class FixColumnName3 < ActiveRecord::Migration[6.1]
  def change
    rename_column :services, :type, :type_service
  end
end
