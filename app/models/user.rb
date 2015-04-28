class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login

  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { in: 3..18 },
    format: { with: /\A(?![_\d])(?!.*_{2})[a-zA-Z0-9_]+(?<!_)\z/ }

  validates :password, length: { in: 6..128 }
  validates :bio, length: { maximum: 140 }

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
