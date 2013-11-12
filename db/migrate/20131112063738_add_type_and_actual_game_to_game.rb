class AddTypeAndActualGameToGame < ActiveRecord::Migration
  def change
    add_column :games, :game_type, :string
    add_column :games, :actual_game, :string
  end
end
