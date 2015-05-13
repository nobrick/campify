class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [ :wechat ]
  attr_accessor :login

  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { in: 3..18 },
    format: { with: /\A(?![_\d])(?!.*_{2})[a-zA-Z0-9_]+(?<!_)\z/ }

  validates :password, length: { in: 6..128 }
  validates :bio, length: { maximum: 140 }
  validates :uid, uniqueness: { scope: :provider }, if: 'uid.present?'

  def self.find_by_omniauth(auth)
    find_by(provider: auth.provider, uid: auth.uid)
  end

  # This is the first method called by Devise::RegistrationsController#new, #create
  def self.new_with_session(params, session)
    auth = session[WECHAT_SESSION_KEY]
    user = new(params)
    if auth
      user.username = "ca_#{SecureRandom.hex(5)}" if user.username.blank?
      user.nickname = auth['info']['nickname'] if user.nickname.blank?
    end
    user
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      # Use approaches other than lower() function to improve performance
      where(conditions.to_h).where([ 'lower(username) = :value OR lower(email) = :value', { value: login.downcase } ]).first
    else
      where(conditions.to_h).first
    end
  end
end
