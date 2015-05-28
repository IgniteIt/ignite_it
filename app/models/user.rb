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

  has_many :projects
  has_many :donations, dependent: :destroy
  has_many :followers
  has_many :followed_projects, through: :followers, source: :project
  has_many :comments, dependent: :destroy

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.gif"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  after_create { send_sign_up_email }

  def send_sign_up_email
    SignUpConfirmation.sign_up_confirm(self).deliver_now
  end

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
      user.avatar = auth.info.image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def has_followed(project)
    followed_projects.include? project
  end
end
