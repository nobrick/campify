class CampusBallot < ActiveRecord::Base
  belongs_to :showtime

  validates :showtime, presence: true
  validates :expires_at, presence: true
  validate :expires_at_must_be_in_future

  private

  def expires_at_must_be_in_future
    errors.add(:expires_at, '必须大于当前时间') if expires_at && expires_at < Time.now
  end
end
