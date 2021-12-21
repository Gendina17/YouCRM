class AddManagerIdAndClientIdAndCompanyIdToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :company_id, :integer
    add_column :events, :manager_id, :integer
    add_reference :events, :client, polymorphic: true
  end
end
