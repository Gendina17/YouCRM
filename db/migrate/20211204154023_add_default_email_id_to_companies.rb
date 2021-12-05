class AddDefaultEmailIdToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :default_email_id, :integer
  end
end
