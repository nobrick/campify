class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :showtime

  validates :user, presence: true
  validates :showtime, presence: true
  validates :showtime, uniqueness: { scope: :user }
end
