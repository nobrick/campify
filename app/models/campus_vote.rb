class CampusVote < ActiveRecord::Base
  belongs_to :ballot, class_name: 'CampusBallot'
  belongs_to :user
  belongs_to :university

  validates :user, presence: true
  validates :ballot, presence: true, uniqueness: { scope: :user }
  validates :university, presence: true
  # validates :vote_for_own_uni
end
