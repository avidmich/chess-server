class AddUniqueIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, [:gplus_id], :unique => true
  end
end
