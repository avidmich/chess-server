class Game < ActiveRecord::Base
  serialize :actual_game, Hash #this instruction is needed for Hash serialization to DB: we are saving JSON (represented as Ruby's Hash object) in a single column of Games table
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'
end
