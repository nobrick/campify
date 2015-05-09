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

  def self.find_by_omniauth(auth)
    find_by(provider: auth.provider, uid: auth.uid)
  end

  # This method will be called by Devise::RegistrationsController#new, #create
  def self.new_with_session(params, session)
    # auth = session.delete 'devise.wechat_data'
    auth = session['devise.wechat_data']
    Rails.logger.debug auth
    Rails.logger.debug params
    if auth
      user = find_or_initialize_by(provider: auth['provider'], uid: auth[:uid]) do |user|
        user.uid = auth['uid']
        user.provider = auth['provider'] # wechat
        user.username = "ca_#{SecureRandom.hex(5)}"
        user.password = Devise.friendly_token[0,20]

        info = auth['info']
        user.nickname = info['nickname']
        user.gender = case info['sex']
                      when 1 then 'male'
                      when 2 then 'female'
                      when 0 then nil
                      end
        user.province = info['province']
        user.city = info['city']
        user.country = info['country']
        user.wechat_headimgurl = info['headimgurl']
      end

      # Override attributes from params for #create
      user.assign_attributes(params)
      user
    else
      new(params)
    end
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
