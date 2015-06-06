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
end
