class Board < ActiveRecord::Base
	belongs_to :user, :class_name => "User", :foreign_key => :winner_id
	belongs_to :user, :class_name => "User", :foreign_key => :last_action
	has_many :games
end
