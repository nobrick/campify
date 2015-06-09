class University < ActiveRecord::Base
  has_many :users, dependent: :nullify
  has_many :votes, class_name: 'CampusVote', dependent: :destroy

  validates :name, presence: true, length: { in: 1..30 }
  validates :city, length: { in: 1..15 }

  def votes_count_for(showtime)
    # CampusVote.where(ballot_id: showtime.ballot.id, university_id: id).count
    showtime.ballot.votes_rank[id]
  end
end
