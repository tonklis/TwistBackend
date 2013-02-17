class Card < ActiveRecord::Base
	belongs_to :template
	has_many :games

	def self.get_friend facebook_id, name
		card = Card.find_by_facebook_id(facebook_id)
		if not card
			card = Card.create(:description => name, :url => "http://graph.facebook.com/"+facebook_id+"/picture?width=250&height=250", :template_id => Template.find_by_description("Amigos").id, :facebook_id => facebook_id)
		end
		card
	end

end
