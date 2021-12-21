class RemoveSubjectFromNotes < ActiveRecord::Migration[6.1]
  def change
    remove_column :notes, :subject, :string
  end
end
