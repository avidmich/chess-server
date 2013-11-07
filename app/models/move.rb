class Move < ActiveRecord::Base
  belongs_to :game, class_name: 'Game'
end
