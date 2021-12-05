class AddSubjectToTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :subject, :string
  end
end
