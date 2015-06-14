require 'rails_helper'

RSpec.describe CampusBallot, type: :model do
  let(:ballot) { create :campus_ballot }

  it 'creates campus ballot model' do
    expect(ballot).to be_persisted
  end

  it 'destroys self and associated votes' do
    vote = create :campus_vote, ballot_id: ballot.id
    expect { ballot.destroy }.to change(CampusVote, :count).by -1
  end

  describe 'votes_rank' do
    let(:universities) { 3.times.collect { create :university } }
    let(:vote) {}

    it 'ranks vote counts for universities' do
      [ 0, 0, 2 ].each do |i|
        create :campus_vote, ballot_id: ballot.id, university_id: universities[i].id
      end
      ranks = 3.times.collect { |i| ballot.votes_rank[universities[i].id] }
      expect(ranks).to eq [ 2, 0, 1 ]
    end

    it 'clears votes rank on destroy' do
      uni_id = universities[0].id
      create :campus_vote, ballot_id: ballot.id, university_id: uni_id
      votes_rank = ballot.votes_rank
      expect(votes_rank[uni_id]).to eq 1
      ballot.destroy
      expect(votes_rank[uni_id]).to eq 0
    end
  end

  describe '#users_with_votes_for_own_uni' do
    let(:universities) { 2.times.collect { create :university } }

    it 'lists all users that votes for her own universities' do
      uni_ids = [ 0, 0, 1, 1 ].collect { |i| universities[i].id }
      # Add a user with non-listed university (-1 to set user university_id to nil)
      uni_ids << -1
      users = 5.times.collect { |i| create :user, university_id: uni_ids[i] }

      uni_ids = [ 0, 0, 0, 1, 1 ].collect { |i| universities[i].id }
      5.times.collect { |i| create_vote user_id: users[i].id, university_id: uni_ids[i] }

      expect(ballot.users_with_votes_for_own_uni(universities[0]))
        .to eq [ users[0], users[1] ]
      expect(ballot.users_with_votes_for_own_uni(universities[1]))
        .to eq [ users[3] ]
    end
  end

  describe '#most_voted_universities' do
    let(:universities) { 3.times.collect { create :university } }

    it 'lists most voted universities' do
      vote_times = [ 3, 5, 5 ]
      3.times do |i|
        vote_times[i].times { create_vote university_id: universities[i].id }
      end

      expect(ballot.most_voted_universities.count).to eq 2
      [ 1, 2 ].each do |i|
        expect(ballot.most_voted_universities).to include universities[i]
      end
    end
  end

  def create_vote(options = {})
    params = { ballot_id: ballot.id }
    create :campus_vote, params.merge!(options)
  end
end
