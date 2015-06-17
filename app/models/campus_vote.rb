class CampusVote < ActiveRecord::Base
  belongs_to :ballot, class_name: 'CampusBallot'
  belongs_to :user
  belongs_to :university
  before_save :set_vote_for_own_uni_cache
  after_save :increment_counter

  validates :user, presence: true
  validates :ballot, presence: true, uniqueness: { scope: :user }
  validates :university, presence: true
  validate :check_ballot_enabled

  private

  def increment_counter
    ballot.votes_rank.increment(university.id)
  end

  def set_vote_for_own_uni_cache
    self.vote_for_own_uni = (user.university.try(:id) == university.id)
    true
  end

  def check_ballot_enabled
    errors.add(:base, '竞投已过期或停用') if ballot.disabled?
  end
end
