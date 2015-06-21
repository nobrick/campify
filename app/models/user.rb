class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [ :wechat ]
  attr_accessor :login

  belongs_to :university
  has_many :proposed_shows, class_name: 'Show', foreign_key: :proposer_id
  has_many :enrollments
  has_many :showtimes, through: :enrollments
  has_many :votes, class_name: 'CampusVote'
  has_many :lotteries
  before_save -> { self.university = nil if self.university_id == -1 } 

  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { in: 3..18 },
    format: { with: /\A(?![_\d])(?!.*_{2})[a-zA-Z0-9_]+(?<!_)\z/ }
  validates :password, presence: true, length: { in: 6..128 }, on: :create
  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  validates :bio, length: { maximum: 140 }
  validates :uid, uniqueness: { scope: :provider }, if: 'uid.present?'
  validates :university_id, presence: true, on: :create

  scope :brief_names_text, -> { all.map { |u| "#{u.nickname} @#{u.username}" }.join(' | ') }

  def self.find_by_omniauth(auth)
    find_by(provider: auth.provider, uid: auth.uid)
  end

  # This is the first method called by Devise::RegistrationsController#new, #create
  def self.new_with_session(params, session)
    super.tap do |user|
      auth = session[WECHAT_SESSION_KEY]
      if auth && auth['extra']['raw_info']
        uid_token = auth['uid'].gsub(/[^a-zA-Z]/, '').downcase
        uid_token = "#{uid_token[0..3]}_#{uid_token[-4..-1]}_#{SecureRandom.hex(1)}"
        user.username = "c_#{uid_token}" if user.username.blank?
        user.nickname = auth['info']['nickname'] if user.nickname.blank?
      end
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

  def vote_for?(showtime)
    CampusVote.exists?(user_id: id, ballot_id: showtime.ballot)
  end

  def vote_for(showtime, university)
    ballot = showtime.ballot
    raise ActiveRecord::RecordNotFound.new('Ballot not enabled') if ballot.nil?
    CampusVote.create(user_id: id, ballot_id: ballot.id, university_id: university.id).persisted?
  end

end
