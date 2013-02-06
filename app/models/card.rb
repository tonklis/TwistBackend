class Card < ActiveRecord::Base
	belongs_to :template
	has_many :games
end
