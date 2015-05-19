class User < ActiveRecord::Base
  attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  validates :username,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.gif"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_h).first
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name
      user.avatar = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

#   def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
#     user = User.create( image:process_uri(auth.info.image))
#   end

# private

#   def self.process_uri(uri)
#     require 'open-uri'
#     require 'open_uri_redirections'
#     open(uri, :allow_redirections => :safe) do |r|
#       r.base_uri.to_s
#     end
#   end
end
