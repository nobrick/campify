require 'rails_helper'

RSpec.describe CampusBallot, type: :model do
  it 'creates campus ballot model' do
    expect(create :campus_ballot).to be_persisted
  end
end
