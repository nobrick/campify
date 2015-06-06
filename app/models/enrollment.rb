class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :showtime

  validates :user, presence: true
  validates :showtime, presence: true
  validates :showtime, uniqueness: { scope: :user }
  validate :showtime_enrollable, on: :create

  def showtime_enrollable
    errors.add(:showtime, '未开启报名') unless showtime.enrollable
  end
end
