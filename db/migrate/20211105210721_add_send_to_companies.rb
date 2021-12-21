class AddSendToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :send, :boolean
  end
end
