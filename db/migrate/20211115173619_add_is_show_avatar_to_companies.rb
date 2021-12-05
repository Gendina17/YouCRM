class AddIsShowAvatarToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :is_show_avatar, :boolean, default: false
  end
end
