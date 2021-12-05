class AddIsAdminToRoles < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :is_admin, :boolean, default: false
  end
end
