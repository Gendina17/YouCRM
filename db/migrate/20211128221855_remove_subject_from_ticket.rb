class RemoveSubjectFromTicket < ActiveRecord::Migration[6.1]
  def change
    remove_column :tickets, :subject, :string
  end
end
