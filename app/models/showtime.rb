class Showtime < ActiveRecord::Base
  belongs_to :show
  has_many :enrollments
  has_many :members, through: :enrollments, source: :user

  after_initialize :default_values

  validates :title, presence: true, length: { in: 1..30 }
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates_presence_of :show, message: '是无效的'
  validate :ends_at_must_be_after_starts_at

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
