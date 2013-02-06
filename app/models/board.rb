class Board < ActiveRecord::Base
	belongs_to :user, :class_name => "User", :foreign_key => :winner_id
	has_many :games
end
