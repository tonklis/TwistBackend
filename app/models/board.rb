class Board < ActiveRecord::Base
	belongs_to :user, :class_name => "User", :foreign_key => :winner_id
	belongs_to :user, :class_name => "User", :foreign_key => :last_action
	belongs_to :previous_board, :class_name => "Board", :foreign_key => :previous_board_id
	has_many :games
end
