class RenameGooglePlusIdToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :google_plus_id, :gplus_id
  end
end
