class CreateWallsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :walls_users, id: false do |t|
      t.belongs_to :wall
      t.belongs_to :user
    end
  end
end
