class AddDateToEmails < ActiveRecord::Migration[6.1]
  def change
    add_column :emails, :date, :datetime
  end
end
