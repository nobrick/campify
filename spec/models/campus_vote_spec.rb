require 'rails_helper'

RSpec.describe CampusVote, type: :model do
  it 'creates campus vote model' do
    expect(create :campus_vote).to be_persisted
  end
end
