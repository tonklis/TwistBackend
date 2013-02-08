class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	
	def facebook
		@user = User.find_for_facebook_oauth(auth_hash, current_user)
		persisted = false

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      #sign_in_and_redirect @user, :event => :authentication
			persisted = true
    else
      session["devise.facebook_data"] = auth_hash.except("extra")
      #redirect_to signup_url(@user)
    end
		
		respond_to do |format|
      format.html # index.html.erb
      format.json { render json: persisted }
    end

  end

	def auth_hash
		request.env["omniauth.auth"]
	end

end
