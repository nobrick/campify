class CampusBallot < ActiveRecord::Base
  include Redis::Objects

  belongs_to :showtime
  has_many :votes, class_name: 'CampusVote',
    foreign_key: 'ballot_id', dependent: :destroy
  sorted_set :votes_rank
  after_destroy :reset_votes_rank

  validates :showtime, presence: true
  validates :expires_at, presence: true
  validate :expires_at_must_be_in_future

  def users_with_votes_for_own_uni(university)
    query_hash = { ballot_id: id, university_id: university.id, vote_for_own_uni: true }
    User.includes(:votes).where(campus_votes: query_hash)
  end

  def most_voted_universities
    return [] if id.nil?
    score = votes_rank[votes_rank.last]
    University.find votes_rank.revrangebyscore(score, score)
  end

  def enabled?
    persisted? && !expired? && expires_at > Time.now
  end

  def disabled?
    !enabled?
  end

  # def university_ids_with_votes_count
    # votes_rank.members(with_scores: true)
  # end

  private

  def expires_at_must_be_in_future
    errors.add(:expires_at, '必须大于当前时间') if expires_at && expires_at < Time.now
  end

  def reset_votes_rank
    votes_rank.clear
  end

  def default_values
    expired = false if expired.nil?
  end
end
