class AddUniqueIndexToDevices < ActiveRecord::Migration
  def change
    add_index :devices, [:registration_id, :user_id], :unique => true
  end
end
