class AddCompanyIdToClientCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :client_companies, :company_id, :integer
  end
end
