class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
	after_create :assign_default_role


  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def self.from_omniauth(auth)
  	where(auth.slice(provider: auth.provider, uid: auth.uid)).first_or_create do |user|
  		user.provider = auth.provider
  		user.uid = auth.uid
  		user.username = auth.info.nickname
  	end
  end

  def self.new_with_session(params, session)
  	if session["devise.user_attributes"]
  		new(session["devise.user_attributes"]) do |user|
  			user.attributes = params
  			user.valid?
  		end
  	else
  		super
  	end
  end

  def password_required?
  	super && provider.blank?
  end

  def update_with_password(params, *options)
  	if encrypted_password.blank?
  		update_attributes(params, *options)
  	else
  		super
  	end
  end

end
