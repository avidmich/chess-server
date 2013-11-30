class RenameEmailToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :email, :google_plus_id
  end
end
