class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
	
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
	has_many :boards
	has_many :games

	validates_presence_of :email, :password #, :first_name, :last_name,

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

end
