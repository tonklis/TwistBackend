class NotificationsController < ApplicationController

	NOTIFICATIONS_BATCH = 1

	def ios_register
		
	token = ""

		if params[:token].length == 64
			token_array = params[:token].scan(/.{1,8}/m)

			token_array.each do |t|
				token += "#{t} "
			end

			token = token[0, token.length - 1]
		elsif params[:token].length == 71
	 		token = params[:token]
		end
		
		device = APN::Device.find_or_create_by_token(:token => token)
		if not device 
			raise "Incorrect parameters token: #{token}"
		end

		if params[:facebook_id]
			user = User.find_by_facebook_id(params[:facebook_id])
			if not user.device
				user.update_attribute(:device_id, device.id)
			end
		end
					
		respond_to do |format|
      format.json { head :ok }
    end	

	end

	def send_ios_notification_to_opponent

		game = Game.find(params[:game_id])
		if not game
			raise "No game found with #{params[:game_id]}"
		end

		device = game.opponent_game.user.device

		if device
			message = params[:message]
			sound = params[:sound].nil? ? params[:sound] : true
			badge_number	= game.opponent_game.user.badge_number + 1

			notification = APN::Notification.new   
			notification.device = device   
			notification.badge = badge_number
			notification.sound = sound
			notification.alert = message
			notification.save!

			send_notifications

		end

		respond_to do |format|
      format.json { head :ok }
    end	

	end

	def send_notifications

		if APN::Notification.where("sent_at is null").count >= NOTIFICATIONS_BATCH
			APN::Notification.send_notifications
		end

	end

end
