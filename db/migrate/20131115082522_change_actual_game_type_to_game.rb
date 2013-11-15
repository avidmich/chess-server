class ChangeActualGameTypeToGame < ActiveRecord::Migration
  def change
    change_column :games, :actual_game, :text, limit: nil
  end
end
