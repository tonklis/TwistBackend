class Game < ActiveRecord::Base
	belongs_to :user
	belongs_to :board
	belongs_to :card
	belongs_to :opponent_game, :class_name => "Game", :foreign_key => :opponent_game_id
	has_many :turns
end
