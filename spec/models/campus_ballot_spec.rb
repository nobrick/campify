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
end
