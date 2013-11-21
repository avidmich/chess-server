class RenameFieldToDevices < ActiveRecord::Migration
  def change
    rename_column :devices, :gcm_id, :registration_id
  end
end
