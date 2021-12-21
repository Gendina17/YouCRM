class AddCompanyIdToClientss < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :company_id, :integer
  end
end
