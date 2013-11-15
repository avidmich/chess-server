class AddForeignKeyConstraintsToGame < ActiveRecord::Migration
  def up
    add_foreign_key(:games, :users, {dependent: :delete, column: 'white_player_id', name: 'fk_game_white_player'})
    add_foreign_key(:games, :users, {dependent: :delete, column: 'black_player_id', name: 'fk_game_black_player'})
  end

  def down
    remove_foreign_key(:games, name: 'fk_game_white_player')
    remove_foreign_key(:games, name: 'fk_game_black_player')
  end
end
