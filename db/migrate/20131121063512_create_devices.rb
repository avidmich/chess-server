class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :gcm_id
      t.belongs_to :user

      t.timestamps
    end
  end
end
