require 'rails_helper'

RSpec.describe CampusVote, type: :model do
  let(:university) { create :university }
  let(:ballot) { create :campus_ballot }
  let(:user) { create :user }

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

  describe 'vote_for_own_uni cache' do
    it 'caches whether user votes for her own university' do
      user.update_attribute(:university_id, university.id)
      vote = create_vote user_id: user.id
      expect(vote.vote_for_own_uni).to eq true
    end

    it 'caches whether user votes for her own university (false case)' do
      vote = create_vote user_id: user.id
      expect(vote.vote_for_own_uni).to eq false
    end
  end

  def create_vote(options = {})
    params = { ballot_id: ballot.id,
               university_id: university.id,
               user_id: (create :user).id }
    create :campus_vote, params.merge!(options)
  end

  def count_by_redis
    ballot.votes_rank[university.id]
  end

  def count_by_model
    CampusVote.where(ballot_id: ballot.id, university_id: university.id).count 
  end
end
