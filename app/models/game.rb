class Game < ActiveRecord::Base
  serialize :actual_game, Hash #this instruction is needed for Hash serialization to DB: we are saving JSON (represented as Ruby's Hash object) in a single column of Games table
  belongs_to :white, class_name: 'User'
  belongs_to :black, class_name: 'User'
end
