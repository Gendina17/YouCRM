class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :subject
      t.string :body
      t.integer :creator_id
      t.integer :user_id
      t.date :until_date

      t.timestamps
    end
  end
end
