class Game < ActiveRecord::Base
	belongs_to :user
	belongs_to :board
	belongs_to :card
	belongs_to :opponent_game, :class_name => "Game", :foreign_key => :opponent_game_id
	has_many :turns

	def calculate_money 
		if self.guess_count == 1
			money = 30
		elsif self.guess_count == 2
			money = 20
		elsif self.guess_count == 3
			money = 10
		elsif self.guess_count > 3
			money = 5
		end
		money
	end
end
