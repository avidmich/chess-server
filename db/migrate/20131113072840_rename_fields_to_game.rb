class RenameFieldsToGame < ActiveRecord::Migration
  def change
    rename_column :games, :white_id, :white_player_id
    rename_column :games, :black_id, :black_player_id
  end
end
