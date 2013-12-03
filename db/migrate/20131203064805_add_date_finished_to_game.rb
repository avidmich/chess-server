class AddDateFinishedToGame < ActiveRecord::Migration
  def change
    add_column :games, :date_finished, :datetime
  end
end
