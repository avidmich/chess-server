class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :type
      t.text :memo
      t.string :app_version
      t.string :os_version
      t.string :sdk_version
      t.string :manufacturer
      t.string :model
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
