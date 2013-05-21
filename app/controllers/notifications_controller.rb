class NotificationsController < ApplicationController

	NOTIFICATIONS_BATCH = 1

	def android_register

		registration_id = params[:regid]
		device = Gcm::Device.find_or_create_by_registration_id(registration_id)
		if not device 
			raise "Incorrect parameters regid: #{registration_id}"
		end

		if params[:facebook_id]
			user = User.find_by_facebook_id(params[:facebook_id])
			if not user.android_devices.index(device)
				user.android_devices << device
				user.save!
			end
		end
					
		respond_to do |format|
      format.json { head :ok }
    end	

	end

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
			if not user.android_devices.index(device)
				user.ios_devices << device
				user.save!
			end
		end
					
		respond_to do |format|
      format.json { head :ok }
    end	

	end

	def send_notification_to_opponent

		game = Game.find(params[:game_id])
		if not game
			raise "No game found with #{params[:game_id]}"
		end

		ios_devices = game.opponent_game.user.ios_devices
		android_devices = game.opponent_game.user.android_devices

		ios_devices.each do |ios_device|
			message = params[:message]
			sound = params[:sound].nil? ? params[:sound] : true
			badge_number	= game.opponent_game.user.badge_number + 1

			notification = APN::Notification.new   
			notification.device = ios_device   
			notification.badge = badge_number
			notification.sound = sound
			notification.alert = message
			notification.save!

			game.opponent_game.user.update_attribute(:badge_number, badge_number)

      begin
  			ios_send_notifications
      rescue
        logger.error "Error sending IOS notifications"
      end

		end

		android_devices.each do |android_device|

			notification = Gcm::Notification.new
			notification.device = android_device
			notification.collapse_key = "AdivinaMe"
			notification.delay_while_idle = true
			notification.data = {:message => params[:message], :title => "AdivinaMe"}

			notification.save!
      begin
			  Gcm::Notification.send_notifications			
      rescue
        logger.error "Error sending IOS notifications"
      end

		end

		respond_to do |format|
      format.json { head :ok }
    end	

	end

	def ios_send_notifications

		if APN::Notification.where("sent_at is null").count >= NOTIFICATIONS_BATCH
			APN::Notification.send_notifications
		end

	end

end
