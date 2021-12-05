class AddShowFieldsToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :show_statuses, :boolean, default: true
    add_column :companies, :show_categories, :boolean, default: true
  end
end
