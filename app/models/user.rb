class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
	
	#devise :registerable, :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
	has_many :boards
	has_many :games
	belongs_to :device, :class_name=>"APN::Device"

	validates_presence_of :facebook_id #, password

	def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
		user = User.where(:email => auth.info.email).first
		unless user
			# CHECK FOR NEW/CREATE
			user = User.create(firstname:auth.info.first_name,
												 last_name:auth.info.last_name,
						 facebook_id:auth.uid,
						 email:auth.info.email,
						 password:Devise.friendly_token[0,20]
						 )
			
		end
		user
	 end

	def self.new_with_session(params, session)
		super.tap do |user|
			if data = session["devise.facebook_data"]
				user.email = data.info.email
				user.first_name = data.info.first_name
				user.last_name = data.info.last_name
				user.facebook_id = data.uid
			end
		end
	end

	def self.login(email, first_name, last_name, facebook_id)
		user = User.find_by_facebook_id(facebook_id)
		if not user
			user = User.create(:email => email, :first_name => first_name, :last_name => last_name, :facebook_id => facebook_id)
		elsif not user.email
			user.update_attributes(:email => email, :first_name => first_name, :last_name => last_name)
		end
		user
	end

	def self.registered_users facebook_ids
		registered_users = []
		facebook_ids.each do |facebook_id|
			user = User.find_by_facebook_id(facebook_id)
			registered_users << user if user
		end
		registered_users
	end

	def self.get_from_facebook_info facebook_id, first_name
		user = User.find_by_facebook_id(facebook_id)
		if not user
			user = User.create(:facebook_id => facebook_id, :first_name => first_name)
		end
		user
	end

end
