class User < ActiveRecord::Base
  has_many :games_as_white, class_name: 'Game', foreign_key: 'white_player_id'
  has_many :games_as_black, class_name: 'Game', foreign_key: 'black_player_id'
end
