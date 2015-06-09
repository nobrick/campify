require 'rails_helper'

RSpec.describe CampusVote, type: :model do
  let(:university) { create :university }
  let(:ballot) { create :campus_ballot }

  it 'creates campus vote model' do
    vote = create_vote
    expect(vote).to be_persisted
  end

  describe 'redis counter cache' do
    it 'increments after model creation' do
      2.times { expect { create_vote }.to change { count_by_redis }.by 1 }
    end

    it 'always equals to actual count for ballot, university' do
      3.times do
        create_vote
        expect(count_by_redis).to eq count_by_model
      end
    end
  end

  def create_vote
    create :campus_vote, ballot_id: ballot.id, university_id: university.id
  end

  def count_by_redis
    ballot.votes_rank[university.id]
  end

  def count_by_model
    CampusVote.where(ballot_id: ballot.id, university_id: university.id).count 
  end
end
