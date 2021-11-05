class AddCompanyIdToRoles < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :company_id, :integer
  end
end
