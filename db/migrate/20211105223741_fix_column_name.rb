class FixColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :companies, :send, :is_send
  end
end
