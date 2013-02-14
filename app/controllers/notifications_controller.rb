class NotificationsController < ApplicationController

	def ios_notification

		token = ""

		if params[:token].length == 64
			token_array = params[:token].scan(/.{1,8}/m)
			message = params[:message]

			token_array.each do |t|
				token += "#{t} "
			end

			token = token[0, token.length - 1]
		elsif params[:token].length == 71
	 		token = params[:token]
		end
		
		device = APN::Device.find_or_create_by_token(:token => token)
		if not device
			raise "Incorrect token format"
		end

		notification = APN::Notification.new   
		notification.device = device   
		notification.badge = 5 
		notification.sound = true   
		notification.alert = message
		notification.save   

		APN::Notification.send_notifications
		respond_to do |format|
      format.json { head :ok }
    end	

	end

end
