class AddCompanyIdToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :company_id, :integer
  end
end
