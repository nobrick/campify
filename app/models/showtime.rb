class Showtime < ActiveRecord::Base
  belongs_to :show
  has_many :enrollments, dependent: :destroy
  has_many :enrollees, -> { order('enrollments.created_at asc') },
    through: :enrollments, source: :user
  has_one :ballot, class_name: 'CampusBallot', dependent: :destroy
  has_one :lottery_event, dependent: :destroy

  after_initialize :default_values

  validates :title, presence: true, length: { in: 1..30 }
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates_presence_of :show, message: '是无效的'
  validate :ends_at_must_be_after_starts_at

  scope :ongoing, -> { where(ongoing: true).order(created_at: :desc) }
  scope :enrollable, -> { where(ongoing: true, enrollable: true)
    .order(created_at: :desc) }
  scope :on_ballot, -> { includes(:ballot).where.not('campus_ballots.id' => nil)
    .order(created_at: :desc) }
  scope :enrolled_by, -> user {
    joins(:enrollments).where(enrollments: { user_id: user.id })
      .order('enrollments.created_at desc')
  }
  scope :voted_by, -> user {
    joins(ballot: :votes).where(campus_votes: { user_id: user.id })
      .order('campus_votes.created_at desc')
  }

  private

  def default_values
    ongoing = true if ongoing.nil?
  end

  def ends_at_must_be_after_starts_at
    if ends_at.present? && ends_at < starts_at
      errors.add(:ends_at, '必须大于活动开始时间')
    end
  end
end
